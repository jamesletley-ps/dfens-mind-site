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

## Swap signup CTAs to the real portal once it ships

**What:** 2026-09-21 — `index.html`, `pricing/index.html`,
`documentation/index.html`, and `contact/index.html` were reworded so
"Start free" reads like `../dfensai-site`'s clean signup CTAs instead of
leading with raw curl/MCP framing. The HTTP bootstrap walkthrough now lives
on `/documentation/#setup` as the canonical, honest "the API already works,
the UI doesn't yet" story. Every signup CTA still points at `/contact/`
underneath, since there's no web portal yet.

A full customer portal (subscription management, API keys, usage, member
& seat management) is now roadmapped in `dfens-mind` (see that repo's
`TODOS.md`, entry added 2026-09-21) — this is a product follow-up, so the
implementation lives there, not here, per this file's own header note.
Once any phase of it ships (even just "create an org" as a real web form),
swap this site's `/contact/`-pointing signup CTAs for real links to it.

**Priority:** P2 — no committed timeline on the portal side yet.
