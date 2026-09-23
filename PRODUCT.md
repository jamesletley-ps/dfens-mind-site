# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

**Primary: an engineering lead or team already running more than one AI
coding tool/harness** (Claude Code, Claude Desktop, other MCP-speaking
agents), who feels the pain of context not carrying over between sessions,
repos, or tools. They arrive wanting a concrete answer: does this actually let
my team's AI tools share memory, and how much does it cost.

Secondary: an individual developer wanting their own cross-project memory
before pitching it to a team.

## Product Purpose

**DFENS AI Ltd** builds **Integrated AI**, a hosted, multi-tenant memory
service for AI tools, on top of the open **DFENS Mind** MCP server
(`github.com/jamesletley-ps/dfens-mind`). It lets any MCP-speaking client
capture and semantically recall notes across every project a team works on,
instead of each session starting from zero.

This repository is the marketing site, not the engine — the engine lives in
the public `dfens-mind` repo. The site's job is to move a qualified visitor
into self-serve signup through the live customer portal — every tier,
Individual, Team, and Enterprise, checks out the same way (see Capabilities
and Constraints — the web portal shipped to production 2026-09-22).

## Positioning

Category: **Shared AI memory** — an MCP memory server, distinct from DFENS AI
Ltd's other product (DFENS, an AI-firewall/AI-Assurance product at
`dfens.ai`). The two are sibling products from the same company, cross-linked,
sharing billing infrastructure (Odoo) but not a brand or a category.

The mechanism a copy-pasted-instructions approach can't match: one shared,
semantically searched memory, addressed by an explicit `context` id, with a
real org/role/grant model underneath it — not a flat notes file per repo.

## Operating Context

- **How it's evaluated:** by a technical buyer (the engineering lead), not a
  compliance buyer — closer to DFENS Cloud's technical-evaluator audience than
  its CISO audience. The pitch is "does my team's context actually travel,"
  not a security questionnaire.
- **How this site ships:** static HTML/CSS, no build step, matching the
  sibling dfensai-site's engineering pattern. CI (`check-links.sh`,
  `check-html.py`) runs on every push; `amplify.yml` is a sane default build
  spec, not a confirmed hosting decision (see TODOS.md).
- **Domain:** `integratedai.co.uk` — live on AWS Amplify as of 2026-09-20 (see
  `deploy/terraform/`). The actual `dfens-mind` MCP server is hosted
  separately, under the shared `dfens.ai` deployment, at
  `https://mind-api.dfens.ai/mcp` — live as of 2026-09-21. The customer
  portal (org creation, plan upgrade/checkout, keys, members) is served
  same-origin at `https://mind-api.dfens.ai/portal/` — live as of 2026-09-22.
- **Company:** DFENS AI Ltd — same legal entity as dfens.ai.

## Capabilities and Constraints

**Product capabilities that are real and citable** (verified against
`../dfens-mind`'s code as of 2026-09-20):

- Core memory tools: `capture_thought`, `search_thoughts` (semantic, Vertex AI
  `gemini-embedding-001`), `browse_recent`, `view_stats`, `update_thought`,
  `delete_thought` — all shipped in `server.py`.
- Context model: org-visibility vs. restricted-with-grant, automatic private
  personal context per user.
- Org/role model: `owner`/`admin`/`member`, poweruser self-serve context
  creation.
- Federated OIDC sign-in (any standards-compliant provider) plus DFENS Mind's
  own OAuth 2.1 authorization server minting RS256 JWTs.
- Postgres + pgvector, row-level multi-tenant ownership. Data residency:
  `europe-west1`, `us-central1`, `asia-northeast1`.
- Skill distribution tools (`create_skill`/`get_skill`/`list_skills`/
  `update_skill`/`delete_skill`/`list_skill_files`/`get_skill_file`) are real,
  shipped code. **Update 2026-09-20:** `dfens-mind/TODOS.md`'s "Approach B"
  (wiring `org_api_keys` into MCP auth) shipped today — every authorization
  primitive, skill tools included, now works identically for a human OIDC
  session or an org API key, so an unattended harness can pull skills on its
  own. **This site now describes skill sharing as live**, superseding the
  earlier "future/roadmap" framing. Still not self-serve: minting additional
  named-service API keys (for more harnesses) is CLI-only (`manage_org.py`)
  today, not an MCP tool — DFENS AI Ltd still does this directly. No live
  HTTP-level verification against a running deployment has been done yet
  either (unit/integration-tested only), per that same TODO entry.
- Org bootstrap (`dfens-mind/onboarding.py`): real, unauthenticated
  `POST /v1/organizations` → email-verify → `POST /v1/organizations/{id}/verify`
  HTTP routes (deliberately not MCP tools — MCP requires auth that doesn't
  exist pre-signup). Returns a live API key; new orgs default to the
  Individual plan (`organizations.plan_id DEFAULT 'individual'`). This is a
  genuine self-serve signup path — **not** a web portal, and its own
  docstring flags beta-scope gaps (no CAPTCHA, in-memory per-process rate
  limiting, no resend-code path).
- `start_checkout(org_id, plan_id)` and `subscription_status(org_id)` are
  real `@mcp.tool()` functions (not REST) — so upgrading from the free
  Individual plan to Team/Enterprise happens as an MCP tool call once an org
  exists, via a Odoo-hosted checkout link. Never handles card data directly.
- **Customer portal — live 2026-09-22** (`dfens-mind/portal.py`, server-rendered
  Starlette + Jinja2, same-origin at `https://mind-api.dfens.ai/portal/`, not a
  separate SPA or subdomain): sign in via the existing OIDC/OAuth 2.1 stack,
  create an organization (defaults to Individual, free, active immediately),
  upgrade to Team via the same Odoo-hosted checkout `start_checkout` uses,
  buy additional seats, mint/revoke API keys, invite/remove members
  (seat-capped), and grant/revoke restricted-context access. This is now the
  genuine self-serve signup path this site's CTAs point at — supersedes the
  earlier "no web portal yet" framing below.
- Billing: `start_checkout` → Go admin-service → Odoo-hosted checkout,
  reconciled hourly via a Cloud Run job. Same Odoo instance/pattern as sibling
  product ai-firewall. Inbound Odoo webhook path is deliberately not wired
  yet — not a claim to make on the site.
- `background_scanners` (Enterprise plan entitlement, `admin/plans.go`) is,
  as of this site's code (2026-09-20), only a boolean feature flag — no
  scanner service, ingestion bot, or automatic memory-population mechanism
  exists in `dfens-mind` yet. **Decision 2026-09-20 (explicit, from the
  account owner):** the site describes this as a current capability —
  "bots that automatically capture context into memory from your team's
  other tools" — ahead of the code landing, because the account owner is
  building it now and expects it live by the time this site deploys. This
  is a deliberate exception to this doc's usual "verified in code first"
  rule, made knowingly, not a fabrication slipping through. Still don't
  invent mechanism/source-integration specifics beyond that one sentence —
  exactly which tools it connects to, how it's triggered, and what it
  scans remain undecided (see Undecided, below). If this capability still
  isn't live in `dfens-mind` by the time the site is promoted publicly,
  this copy needs to be pulled or re-scoped back to "coming."

**Commercial model** (`admin/plans.go` in `dfens-mind`, real committed
defaults):

- **Individual** — free, hard-capped (500 thoughts / 2,000 embedding calls /
  50MB per month).
- **Team** — £5/seat/month, up to 20 seats, usage billed rather than capped.
- **Enterprise** — £20/seat/month, no seat cap. **Confirmed 2026-09-23 by the
  account owner** (the code comment in `admin/plans.go` had flagged this as an
  unconfirmed assumption; that assumption is now the decided price). Self-serve
  through the customer portal's Odoo-hosted checkout, same mechanism as Team —
  no "Contact sales" gate. Entitlements: `custom_oauth`, `retention_archive`,
  `background_scanners` — described functionally on the pricing page, no
  invented mechanism detail for `background_scanners` specifically, since its
  exact behavior isn't documented anywhere found in this session's
  investigation.

**Undecided, and not to be invented:**

- Exact mechanism of the `background_scanners` entitlement — which sources
  it connects to, how capture is triggered, what it scans. The one-sentence
  functional description (see Capabilities, above) is presented as current;
  everything past that sentence is still undecided.
- Public availability / GA date — the product has no live paying customer yet
  (`dfens-mind/TODOS.md`).
- Trademark clearance on "Integrated AI".
- Final mark/logo — the connected-node placeholder mark is explicitly interim.

## Brand Commitments

`marketing/BRAND.md` is the binding authority for identity, and is itself
marked as a placeholder pass — see that file. Durable facts that won't change
with a rebrand: the company is DFENS AI Ltd; privacy/legal notices are
published only on dfens.ai, never duplicated here; the two sites link to each
other.

## Evidence on Hand

**Real, and usable in copy:** every capability listed above, verified against
`../dfens-mind`'s actual code (not its README, which lags the code on the
skills tools) during this site's build, 2026-09-20.

**Absences that future work must not fabricate:**

- No customers, testimonials, or usage numbers — pre-revenue.
- **Update 2026-09-22:** the self-serve **web** signup portal shipped and is
  live in production at `https://mind-api.dfens.ai/portal/` (`dfens-mind/portal.py`
  — see Capabilities, above). The 2026-09-21 roadmap note below is superseded;
  site copy should now describe the portal as a real, live way to sign up and
  upgrade, not "on the way." `onboarding.py`'s HTTP bootstrap still exists and
  is still worth documenting for automation, but it's no longer the only
  self-serve path.
  ~~**Decision 2026-09-21:** a real customer portal (subscription
  management, API keys, usage, member/seat management) is now roadmapped
  at `dfens-mind/ui-portal/`, reusing dfens-mind's existing OAuth 2.1/OIDC
  rather than a separate auth system — see that repo's `TODOS.md` for the
  phased plan.~~ (Superseded: it shipped as `portal.py` in the existing
  Python service, not a separate `ui-portal/` SPA.)
- ~~No confirmed Enterprise per-seat price.~~ (Superseded 2026-09-23: £20/seat/month,
  confirmed by the account owner — see Commercial model, above.)
- `background_scanners`'s exact mechanism (sources, triggers, scan
  behavior) — the one-line functional description is a deliberate,
  logged exception (see Capabilities, above); don't extend it further
  without a new decision.

## Accessibility & Inclusion

WCAG 2.1 AA is the target, matching the ported design system's existing
commitment (contrast, focus visibility, semantic heading order, keyboard
operability).
