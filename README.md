# dfens-mind-site

Marketing site for **Integrated AI (by DFENS AI)** — the hosted, multi-tenant
memory service built on the open [DFENS Mind](https://github.com/jamesletley-ps/dfens-mind)
MCP server. Sibling product to [dfens.ai](https://dfens.ai) (DFENS, AI-firewall);
same company (DFENS AI Ltd), different brand and domain.

**Brand status:** placeholder. Palette, type, and layout are ported verbatim
from `../dfensai-site`'s design system; the wordmark, mark, and copy are new.
The user intends to refine branding with Claude Code closer to launch — see
`marketing/BRAND.md` and `TODOS.md`.

## Contents

```
index.html             Landing page — hero, the problem, how it works,
                        capabilities, tool table, works-with, security, pricing teaser
pricing/index.html      Pricing page (Individual / Team / Enterprise + FAQ)
documentation/index.html MCP client setup, auth, full tool reference, context/org model
contact/index.html      Contact — Odoo form, plus the self-serve-via-MCP path
404.html                Not-found page
PRODUCT.md              Durable product record (users, positioning, evidence on hand)
TODOS.md                Site-specific follow-ups (DNS/hosting, cross-link, trademark check)
assets/style.css        Design system — ported from dfensai-site, DFENS-specific
                        animated hero/ticker deliberately dropped (see BRAND.md)
assets/fonts.css        @font-face for the self-hosted brand fonts
assets/fonts/           Archivo + JetBrains Mono woff2 (first-party, no CDN)
marketing/BRAND.md      Names, domains, tagline, voice, palette — marked placeholder
```

## Grounded in the product

Every capability claim on this site was verified against `../dfens-mind`'s
actual code (not just its README, which lags the code — e.g. the skill
distribution tools exist in `server.py` before the README's own tool table
mentions them) as of 2026-09-20:

- Core tools: `capture_thought`, `search_thoughts` (semantic, Vertex AI
  `gemini-embedding-001`), `browse_recent`, `view_stats`, `update_thought`,
  `delete_thought`.
- Context model: org-visibility vs. restricted-with-grant, automatic private
  personal context.
- Org/role model: `owner`/`admin`/`member`, poweruser self-serve context
  creation.
- Auth: federated OIDC sign-in, plus DFENS Mind's own OAuth 2.1 authorization
  server minting RS256 JWTs.
- Storage: Postgres + pgvector, row-level multi-tenant ownership; data
  residency across three regions.
- Plans (`admin/plans.go`): Individual free/hard-capped, Team £5/seat/month up
  to 20 seats, Enterprise custom (the code's £20/seat figure is flagged
  unconfirmed, so the site doesn't state it).
- Skill distribution tools are real and shipped. As of 2026-09-20
  (`dfens-mind/TODOS.md`, "Approach B"), they work from a human OIDC session
  or an org API key identically — the site describes this as live, not a
  future capability.
- Org bootstrap (`onboarding.py`): real, unauthenticated HTTP routes (not MCP
  tools) that create + verify an org and return a live API key, defaulting
  to the free Individual plan. `start_checkout`/`subscription_status` *are*
  real MCP tools, so upgrading plans happens without leaving the MCP client.
- `background_scanners` (Enterprise) is, in the code, still just a boolean
  plan flag with no implementation. The site describes it as a current
  capability anyway — see `PRODUCT.md`'s Capabilities section for why
  (explicit, logged exception: it's being built now, expected live by
  deploy) and the exact one-sentence boundary on what's said about it.

Nothing on the site asserts a capability the engine doesn't have. There's no
self-serve *web* portal, but there is a real self-serve signup path over
plain HTTP (never described as an MCP tool call, since it isn't one).

## Preview locally

```bash
python3 -m http.server 8000
# → http://localhost:8000
```

## CI

`.github/workflows/ci.yml` runs on every push and PR to `main`:

```bash
./scripts/check-links.sh       # local links + #anchors resolve (offline)
python3 scripts/check-html.py  # tag balance, duplicate ids, <title> present
```

CI also assembles the publish directory (`dist/`) exactly as `amplify.yml`
does and fails if anything under `marketing/` or any `*.md` leaks into it —
internal collateral must never be served.

## Deploy

Live on AWS Amplify Hosting, provisioned via Terraform in
`deploy/terraform/` (app `dfens-mind-site`) — push to `main` auto-deploys
using `amplify.yml`, matching the sibling `dfensai-site`'s pattern. See
`deploy/terraform/README.md` for how to change infra (IAM policy needed,
the two-apply domain-association caveat, teardown).

### Domain setup

| Domain | Status |
|---|---|
| integratedai.co.uk | Primary. Live — apex + `www` both point at this Amplify app. |
| dfens.ai | Sibling product. Privacy/legal notices live there only; this site links out rather than duplicating them. |

`hello@integratedai.co.uk`'s DNS-side MX/SPF/DKIM already existed before
this site was hosted (left over from Google Workspace setup); confirming the
mailbox itself is provisioned is tracked in `TODOS.md`.

## Before public launch (TODOs left in the files)

See `TODOS.md` for the full list: confirming the `hello@` mailbox, the
dfensai-site reciprocal link, a trademark check on "Integrated AI", and
final mark/logo design. The `documentation/index.html` deployment hostname
is no longer a placeholder — it points at the live production MCP endpoint,
`https://mind-api.dfens.ai/mcp`.
