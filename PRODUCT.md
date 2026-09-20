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
into contact, since there's no self-serve signup portal yet (see
Capabilities and Constraints).

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
- **Domain:** `integratedai.co.uk`, not yet provisioned.
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
  shipped code — but human-OIDC-session-only. No unattended/API-key access
  path exists yet (`TODOS.md` in `dfens-mind`, "Approach B"). **This site
  describes skill distribution as a future/roadmap capability**, per an
  explicit decision during this site's build, not as a live headline feature.
- Billing: `start_checkout` → Go admin-service → Odoo-hosted checkout,
  reconciled hourly via a Cloud Run job. Same Odoo instance/pattern as sibling
  product ai-firewall. Inbound Odoo webhook path is deliberately not wired
  yet — not a claim to make on the site.

**Commercial model** (`admin/plans.go` in `dfens-mind`, real committed
defaults):

- **Individual** — free, hard-capped (500 thoughts / 2,000 embedding calls /
  50MB per month).
- **Team** — £5/seat/month, up to 20 seats, usage billed rather than capped.
- **Enterprise** — code comment flags the £20/seat figure as an unconfirmed
  per-seat assumption, so this site presents Enterprise as **"Custom — contact
  us"** rather than stating that price. Entitlements: `custom_oauth`,
  `retention_archive`, `background_scanners` — described functionally on the
  pricing page, no invented mechanism detail for `background_scanners`
  specifically, since its exact behavior isn't documented anywhere found in
  this session's investigation.

**Undecided, and not to be invented:**

- The £20/seat Enterprise figure (code comment flags it unconfirmed).
- Exact mechanism of the `background_scanners` entitlement.
- Public availability / GA date — the product has no live paying customer yet
  (`dfens-mind/TODOS.md`).
- `integratedai.co.uk` DNS/hosting — not provisioned.
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
- No self-serve signup portal — every tier is set up directly by DFENS AI Ltd
  today.
- No live deployment URL for `integratedai.co.uk` yet.
- No confirmed Enterprise per-seat price.

## Accessibility & Inclusion

WCAG 2.1 AA is the target, matching the ported design system's existing
commitment (contrast, focus visibility, semantic heading order, keyboard
operability).
