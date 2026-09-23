# TODOS

Site-specific follow-ups. Product follow-ups (billing wiring, skill
distribution's Approach B, etc.) live in `dfens-mind/TODOS.md`, not here.

## Add a reciprocal link from dfensai-site

**What:** Add a link to `integratedai.co.uk` from `../dfensai-site`'s header
and/or footer nav, matching how this site already links back to `dfens.ai`.
Exact snippet to drop into `dfensai-site/index.html` (and its other pages'
shared footer block), inside the existing `.foot .cols` "Company" column:

```html
<li><a href="https://integratedai.co.uk">Integrated AI</a></li>
```

**Why:** The user asked for the two sites to link to each other. This half
(dfensai-site → here) was deliberately deferred this session — dfensai-site
auto-deploys to production on push to `main` via AWS Amplify, so it wasn't
touched without a separate go-ahead.

**Priority:** P1 — do before either site is publicly promoted.
**Depends on:** None. Can be done any time; a live `integratedai.co.uk` isn't
required first (the link works once DNS/hosting below is done).

## ~~Provision integratedai.co.uk DNS + hosting~~ — done 2026-09-20

Live on AWS Amplify (`deploy/terraform/`, app `dfens-mind-site`,
`d93q94v8twmof`), apex + `www` both serving. The domain's Route53 zone
already existed (Google Workspace mail was already wired there from before
the "Integrated AI" → "DFENS AI" rebrand); `integratedai.co.uk` was also
still claimed by `dfensai-site`'s own Amplify app (`integratedai-site`,
leftover from before that rebrand) — that domain association was deleted
there to free it up. See `deploy/terraform/README.md` for the full story
and how to redeploy.

**Still outstanding:** confirm the `hello@integratedai.co.uk` mailbox is
actually provisioned in Google Workspace (DNS-side MX/SPF/DKIM already
existed and were left untouched by this change) — every CTA and the footer
point at that address.

**Priority:** P1 — mailbox check before public launch.

## Trademark check on "Integrated AI"

**What:** Run a UK IPO search on "Integrated AI" before public launch, same
diligence DFENS AI Ltd already did for "DFENS" (see `dfensai-site/marketing/BRAND.md`).
"Integrated" + "AI" is a much more generic pair of words than "DFENS", so this
is genuinely more likely to collide with something — check early.

**Priority:** P1 — before public launch.

## Final mark/logo design

**What:** The connected-node placeholder mark (three nodes around a hollow
hub) is a deliberate placeholder — simple, on-brand color, not a finished
logo. The user intends to redesign branding with Claude Code once the product
is closer to launch.

**Priority:** P2.

## ~~Provision the deployment hostname referenced in /documentation/~~ — done 2026-09-21

`documentation/index.html`'s MCP client setup snippet now points at the real
production endpoint, `https://mind-api.dfens.ai/mcp` (not the
`integratedai.co.uk` domain — the MCP service is hosted under the shared
`dfens.ai` deployment). The in-page placeholder note box was removed.

## ~~Swap signup CTAs to the real portal once it ships~~ — done 2026-09-22

**What:** 2026-09-21 — `index.html`, `pricing/index.html`,
`documentation/index.html`, and `contact/index.html` were reworded so
"Start free" reads like `../dfensai-site`'s clean signup CTAs instead of
leading with raw curl/MCP framing. The HTTP bootstrap walkthrough now lives
on `/documentation/#setup` as the canonical, honest "the API already works,
the UI doesn't yet" story. Every signup CTA still points at `/contact/`
underneath, since there's no web portal yet.

**2026-09-22:** the customer portal shipped to production
(`dfens-mind/portal.py`, `https://mind-api.dfens.ai/portal/` — see that
repo's `TODOS.md` "Customer Portal (MVP eng-reviewed 2026-09-21, built
2026-09-21)" / "Buy additional seats" / "Contexts self-service +
member-invite UI" entries). Every `/contact/`-pointing signup CTA on this
site now points at the real portal, same pattern as `../dfensai-site`'s
`portal.dfens.ai/signup?plan=…` links:

- Individual ("Start free", nav + hero + pricing tier + docs):
  `https://mind-api.dfens.ai/portal/onboarding` — the org-creation form.
- Team ("Start on Team", pricing tier): `https://mind-api.dfens.ai/portal/?plan=team`
  — the dashboard, `plan` query param pre-hints the upgrade panel
  (`dashboard_handler`'s `plan_hint`); redirects through `/portal/login` for a
  signed-out visitor and preserves the `next` path back to it.
- Enterprise stays `/contact/` — deliberately not self-serve, same posture as
  `../dfensai-site`'s Enterprise CTA (mailto, "Contact sales").

`PRODUCT.md` updated to reflect the portal as live, not roadmapped.

**2026-09-23:** Enterprise is per-seat priced (`admin/plans.go`, £20/seat/month,
no seat cap) and checkout-purchasable through the exact same Odoo mechanism as
Team — no product reason to gate it behind sales. Account owner confirmed the
£20/seat figure as decided, not the placeholder the code comment had flagged
it as. Enterprise's "Contact sales" CTA on `pricing/index.html` is now "Start
on Enterprise" → `https://mind-api.dfens.ai/portal/?plan=enterprise`, price
shown alongside Team's. `contact/index.html`'s note-box and the pricing
page's FAQ/#access copy updated to describe all three tiers as self-serve.
`PRODUCT.md`'s Commercial model and Undecided sections updated to mark the
price confirmed.

**2026-09-23 (same day):** Team's 20-seat cap removed and "context-linked
skill distribution" added as a Team pricing-page feature, both account-owner
decisions. Backend: `dfens-mind/admin/plans.go`'s `team` `PlanRecord` no
longer sets `SeatCap` (nil = unlimited, same shape Enterprise already had).
This site: `pricing/index.html` (meta description, Team's `tier-price` now
"no seat cap" matching Enterprise's phrasing, Team's stale "Up to 20 seats on
one organization" bullet swapped for "Context-linked skill distribution
across your team's tools", Enterprise's tier-note/tier-list de-duplicated
now that seat count no longer distinguishes it from Team) and `index.html`'s
`#pricing-teaser` sub-copy. `PRODUCT.md`'s Commercial model updated —
including a flagged gap: `dfens-platform/store`'s `SeedPlans` is
insert-only (`ON CONFLICT (id) DO NOTHING`), so this code change alone does
**not** raise the cap on an already-seeded staging/production `team` plan
row; see `dfens-mind/TODOS.md`'s "Production 'team' plan row still has
seat_cap=20 — needs a manual console edit" entry for the (deliberately
manual, not scripted) fix.
