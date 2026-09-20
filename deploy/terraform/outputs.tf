output "amplify_app_id" {
  value       = aws_amplify_app.site.id
  description = "Amplify app id, e.g. for `aws amplify start-deployment` or the console URL."
}

output "amplify_default_domain" {
  value       = aws_amplify_app.site.default_domain
  description = "Amplify-assigned domain (main.<app_id>.amplifyapp.com) — works even before the custom domain finishes verifying."
}

output "domain_association_status" {
  value       = aws_amplify_domain_association.site.certificate_verification_dns_record
  description = "Non-empty once Amplify has generated the cert-validation DNS hint dns.tf consumes. Empty here on a fresh apply usually means a second `terraform apply` is needed — see README."
}

output "custom_domain_urls" {
  value       = ["https://${var.domain_name}", "https://www.${var.domain_name}"]
  description = "Expect these to serve the site once the domain association reaches AVAILABLE (check the Amplify console or `aws amplify get-domain-association`)."
}
