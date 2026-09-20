variable "aws_region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS region for the Amplify app. Route53 is global and unaffected by this."
}

variable "app_name" {
  type        = string
  default     = "dfens-mind-site"
  description = "Name of the Amplify app, as shown in the AWS console."
}

variable "repository_url" {
  type        = string
  default     = "https://github.com/jamesletley-ps/dfens-mind-site"
  description = "GitHub repository Amplify builds and deploys from (branch: main)."
}

variable "domain_name" {
  type        = string
  default     = "integratedai.co.uk"
  description = "Custom domain to associate with the Amplify app. Must already exist as a Route53 hosted zone in this account."
}

variable "github_access_token" {
  type        = string
  sensitive   = true
  description = <<-EOT
    GitHub personal access token (repo + workflow scopes) Amplify uses once,
    at app-creation time, to install its deploy webhook on repository_url.
    Supply via TF_VAR_github_access_token — never put this in a .tfvars file
    or commit it. E.g.: TF_VAR_github_access_token=$(gh auth token)
  EOT
}
