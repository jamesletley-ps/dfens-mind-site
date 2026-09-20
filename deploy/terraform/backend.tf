# Local state. This stack is a single Amplify app + one Route53 domain
# association for one static site, applied by one operator — remote state
# with locking would be pure overhead here, and nothing else in this repo
# shares state with it. terraform.tfstate* is gitignored; treat the local
# state file as the source of truth and don't hand-edit Route53/Amplify
# outside Terraform once this is applied.
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
