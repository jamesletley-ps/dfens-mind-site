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

## Provision integratedai.co.uk DNS + hosting

**What:** Register/confirm the domain, choose a host (this site ships an
`amplify.yml` matching the sibling site's pattern as a default, not a decided
choice), and point DNS at it. Also provision `hello@integratedai.co.uk` with
SPF/DKIM/DMARC — every CTA and the footer currently point at that address and
it doesn't exist yet.

**Priority:** P0 — nothing on this site works publicly until this is done.

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

## Provision the deployment hostname referenced in /developers/

**What:** `developers/index.html`'s MCP client setup snippet uses
`https://mcp.integratedai.co.uk/mcp` as a placeholder hostname (flagged
in-page with a note box). Update it once a real deployment exists.

**Depends on:** DNS/hosting above, plus an actual `dfens-mind` deployment for
this brand (or a decision to point at a shared deployment — not decided here).

**Priority:** P0 — blocks anyone actually connecting a client.
