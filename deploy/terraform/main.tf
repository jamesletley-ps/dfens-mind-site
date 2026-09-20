# AWS Amplify Hosting for dfens-mind-site (integratedai.co.uk), Git-based
# deploy from GitHub. Credentials come from the operator's environment
# (AWS_PROFILE) — applies here are operator-run, not automated, matching
# ../../../ai-firewall/deploy/terraform's own provider setup.
provider "aws" {
  region = var.aws_region
}

resource "aws_amplify_app" "site" {
  name       = var.app_name
  repository = var.repository_url

  # Used once, at creation, to install Amplify's deploy webhook on the repo.
  # Not required on subsequent applies once the app exists.
  access_token = var.github_access_token

  platform = "WEB"

  # No preview builds for arbitrary branches — only main.tf's explicit
  # aws_amplify_branch below is ever built.
  enable_auto_branch_creation = false

  # No build_spec override: the repo's own committed amplify.yml (which
  # assembles dist/ from index.html, 404.html, pricing/, developers/,
  # contact/, assets/ and excludes marketing/ and *.md) is the single
  # source of truth for the build.

  # Amplify's own default error page otherwise replaces the site's real
  # 404.html for any unmatched path.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/404.html"
  }
}

resource "aws_amplify_branch" "main" {
  app_id            = aws_amplify_app.site.id
  branch_name       = "main"
  stage             = "PRODUCTION"
  enable_auto_build = true
}

# Custom domain. wait_for_verification is false: verification needs the
# CNAME this resource's own output produces to already exist in Route53,
# which dns.tf creates from that same output — see README's "two-apply"
# note for what to do if AWS hasn't populated the DNS records fast enough
# for a single apply to pick them up.
resource "aws_amplify_domain_association" "site" {
  app_id                = aws_amplify_app.site.id
  domain_name           = var.domain_name
  wait_for_verification = false

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = ""
  }

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = "www"
  }
}
