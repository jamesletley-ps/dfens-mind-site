# Terraform: AWS Amplify Hosting + integratedai.co.uk

Provisions an AWS Amplify app (Git-based deploy from `main`, using the
repo's own `amplify.yml`) and associates it with the existing
`integratedai.co.uk` Route53 zone (apex + `www`), replacing the domain's
current redirect to `dfens.ai`.

Applies here are **operator-run, not automated** — no CI workflow calls
`terraform apply`. State is local (`terraform.tfstate`, gitignored); this is
a single small stack with one operator, so remote state/locking isn't worth
the overhead.

## Before the first apply

**1. IAM.** Neither AWS identity available in this environment
(`clawed`/`dfens-terraform`, account `081234808651`) can call `amplify:*`
or read its own IAM policy — confirmed via `aws amplify list-apps` and
`aws iam list-user-policies`, both `AccessDenied`. Attach
[`iam-policy.json`](./iam-policy.json) to the `dfens-terraform` IAM user
before running `apply`. It's scoped to: Amplify app/branch/domain-
association/webhook management; `iam:CreateServiceLinkedRole` for
`AWSServiceRoleForAmplify` (this account has never used Amplify, so AWS
creates that role on first `CreateApp` call — the caller needs permission
for that one-time step); and Route53 changes scoped to the
`integratedai.co.uk` zone (`Z1K92X884HVT4F`) only.

**2. GitHub token.** `aws_amplify_app` needs a token once, at creation, to
install its deploy webhook on `jamesletley-ps/dfens-mind-site`. Use the
existing `gh` auth (active account already has `repo`+`workflow` scopes):

```bash
export TF_VAR_github_access_token=$(gh auth token)
```

Never put this in a `.tfvars` file or commit it.

## Apply

```bash
export AWS_PROFILE=dfens-terraform
export TF_VAR_github_access_token=$(gh auth token)

terraform init
terraform plan   # review carefully — see "DNS cutover" below
terraform apply
```

### DNS cutover — what `plan` will show

`integratedai.co.uk` and `www.integratedai.co.uk` currently alias/CNAME to
a CloudFront distribution (in a *different* AWS account) that
302-redirects to `https://www.dfens.ai/` — a leftover from before the
company rebranded "Integrated AI" to "DFENS AI." Those records aren't
Terraform-managed (no prior state), so `plan` will show them as new
resources to *create*, but applying is a same-value UPSERT against the
live records — no import needed, and no other record in the zone (MX, SPF,
DKIM, `_dmarc`, the old ACM-validation CNAME, the Google site-verification
CNAME) is touched.

**This is an intentional, confirmed cutover** — this site is
`integratedai.co.uk`'s actual owner now; the redirect was only ever a
rebrand-era stopgap. After `apply`, the old redirect stops working for this
domain. That's expected. The Amplify app behind the old redirect (in
whichever account owns it) is not deleted by this config — it's simply no
longer pointed at by this domain.

### The "two apply" caveat

`aws_amplify_domain_association` returns its DNS hints
(`certificate_verification_dns_record`, each `sub_domain.dns_record`) as
soon as AWS has generated them — usually within the same `apply`, since
`dns.tf`'s records depend on those outputs. If AWS hasn't populated them
synchronously, `apply` may finish with `dns.tf`'s records unchanged (empty
values) or with an error. **Just run `terraform apply` again** — it's
idempotent, and the second pass picks up the now-populated hints. Check
`terraform output domain_association_status`: empty means run apply again;
a `<name> CNAME <value>` string means `dns.tf` has what it needs.

## Verify

```bash
terraform output custom_domain_urls
curl -I https://integratedai.co.uk       # should serve the site, not a dfens.ai redirect
curl -I https://www.integratedai.co.uk
aws amplify get-domain-association \
  --app-id "$(terraform output -raw amplify_app_id)" \
  --domain-name integratedai.co.uk \
  --query 'domainAssociation.domainStatus'   # want: AVAILABLE
```

Push to `main` on GitHub triggers an Amplify build automatically
(`enable_auto_build = true` on the `main` branch) — the build itself just
runs the copy steps in `../../amplify.yml`, same as CI's own dry-run of
that spec in `.github/workflows/ci.yml`.

## Local-only checks (no AWS credentials needed)

```bash
terraform fmt -check
terraform init -backend=false
terraform validate
```

## Out of scope

- The old redirect's Amplify app/CloudFront distribution (different AWS
  account) — not touched, not torn down here.
- `dfensai-site`'s own Amplify app — unrelated, set up manually per its own
  `docs/aws-deploy.md`.
- `hello@integratedai.co.uk` mailbox provisioning (`TODOS.md`) — outside
  Terraform's reach, tracked separately.
