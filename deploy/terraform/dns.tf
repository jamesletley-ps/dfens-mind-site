# Route53 records for the Amplify custom domain, in the *existing*
# integratedai.co.uk zone (looked up, not created — it already carries live
# Google Workspace MX/SPF/DKIM/DMARC that this config must not touch).
#
# Scope is deliberately narrow: only the three records Amplify needs
# (cert validation + apex + www). Everything else already in the zone is
# left alone.
data "aws_route53_zone" "primary" {
  name         = var.domain_name
  private_zone = false
}

locals {
  # aws_amplify_domain_association returns each DNS hint as one
  # "<name> <type> <value>" string; split it into the pieces
  # aws_route53_record needs.
  cert_verification_parts = split(" ", aws_amplify_domain_association.site.certificate_verification_dns_record)
  apex_dns_parts          = split(" ", [for s in aws_amplify_domain_association.site.sub_domain : s.dns_record if s.prefix == ""][0])
  www_dns_parts           = split(" ", [for s in aws_amplify_domain_association.site.sub_domain : s.dns_record if s.prefix == "www"][0])
}

# ACM certificate validation for the custom domain, requested internally by
# Amplify when aws_amplify_domain_association.site is created.
resource "aws_route53_record" "cert_validation" {
  zone_id         = data.aws_route53_zone.primary.zone_id
  name            = local.cert_verification_parts[0]
  type            = local.cert_verification_parts[1]
  ttl             = 300
  records         = [local.cert_verification_parts[2]]
  allow_overwrite = true
}

# www.integratedai.co.uk -> Amplify. Overwrites the existing, Terraform-
# unmanaged CNAME that pointed at the old dfens.ai-redirect CloudFront
# distribution — allow_overwrite is required for this specific record
# (it already exists, unmanaged, with a different value; without it the
# Route53 API rejects the create as a collision instead of upserting).
resource "aws_route53_record" "www" {
  zone_id         = data.aws_route53_zone.primary.zone_id
  name            = local.www_dns_parts[0]
  type            = "CNAME"
  ttl             = 300
  records         = [local.www_dns_parts[2]]
  allow_overwrite = true
}

# integratedai.co.uk (apex) -> Amplify. Route53 rejects a literal CNAME at
# the zone apex, so this is an ALIAS A record at the hostname Amplify's ""
# sub_domain names instead. Z2FDTNDATAQYW2 is AWS's fixed CloudFront alias
# hosted-zone id (the same value the superseded apex record already used).
# allow_overwrite is required: this record already exists, unmanaged, with
# a different alias target.
resource "aws_route53_record" "apex" {
  zone_id         = data.aws_route53_zone.primary.zone_id
  name            = var.domain_name
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = local.apex_dns_parts[2]
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}
