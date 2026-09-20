# Brand guide — Integrated AI (by DFENS AI)

**Status: placeholder.** This brand pass reuses DFENS AI Ltd's existing design
system (`../dfensai-site/marketing/BRAND.md`) verbatim — palette, type, motion,
voice — with a new wordmark, a new placeholder mark, and copy grounded in
DFENS Mind instead of the AI-firewall product. The user intends to refine this
with Claude Code once the product is closer to launch. Nothing here should be
treated as final.

## Names

| Thing | Name | Notes |
|---|---|---|
| Company | **DFENS AI Ltd** | Same legal entity as dfens.ai. Registered legal name in every formal/legal context — footer copyright, boilerplate, the privacy notice (published only on dfens.ai). |
| Product / site brand | **Integrated AI** | Set plain (no tracking gimmick yet — unlike DFENS's wide-tracked wordmark). Endorsement tag "by DFENS AI" shown small next to it. |
| Underlying engine | **DFENS Mind** | The public, open MCP server (`github.com/jamesletley-ps/dfens-mind`) — unlike `ai-firewall`, this one is NOT internal-only; it's fine to name and link to it. |

## Domains

| Domain | Role |
|---|---|
| **integratedai.co.uk** | Primary for this product. Live on AWS Amplify — see `deploy/terraform/`. |
| dfens.ai | Sibling product (DFENS, AI-firewall). Privacy/legal notices live there only. |

Note: `dfensai-site`'s own `BRAND.md` separately reserves `integratedaisolutions.net`
as a defensive redirect domain to dfens.ai. That's a different domain
(`.net`, redirect-only) from this product's live `integratedai.co.uk` (`.co.uk`,
UK ccTLD) — not a conflict, but worth knowing both exist.

## Tagline

Primary: **"Your AI already remembers. Your team doesn't."**
Support line: **"One shared memory across your team — not just your own sessions."**
Category: **"Shared AI memory"** — an MCP memory server, not a firewall; don't
borrow DFENS's "AI Assurance" category language, it doesn't fit this product.

**2026-09-20 decision:** lead with the team gap, not the tool gap. Per-session
and per-tool AI memory already exists elsewhere (Claude's own memory, ChatGPT
memory, Cursor rules) — that's not the argument to win. The one this product
actually wins is that none of those travel to a *teammate*. Cross-tool support
(MCP, any client) stays real and stays in the copy — eyebrow, subhead, and the
"Works with your stack" section — just not as the headline hook anymore.

## Voice

Reused from DFENS, adapted to a memory/MCP product instead of a firewall:

- **Direct, technical, plain.** Say what the product does in concrete nouns:
  contexts, thoughts, tools, orgs, grants. No hype.
- **Claims discipline.** Don't assert a capability the code doesn't have.
  Skill distribution works from a human session or an org API key as of
  2026-09-20 — say so plainly, it's live, not a roadmap item. There's still
  no self-serve *web* portal — a real self-serve signup path exists, but
  it's a couple of plain HTTP calls (`onboarding.py`), never an MCP tool
  call and never a web UI — say exactly that, don't blur the two.
- **Engineer-to-engineer** on `/developers/`; a little more outcome-first on
  the landing page, matching DFENS's own audience split.
- Avoid: "revolutionary", "AI-powered" as a selling point, unquantified
  absolutes ("never lose context"), and inventing specifics for entitlements
  the code names but doesn't fully describe (e.g. `background_scanners` —
  described functionally, not with an invented mechanism). One logged
  exception: `background_scanners` itself is described as current
  ("bots that automatically capture context...") ahead of the code landing,
  per an explicit 2026-09-20 decision in `PRODUCT.md` — still functional
  only, no invented mechanism beyond that one sentence.

## Visual identity (ported verbatim from DFENS v1.0, see `../dfensai-site`)

- **Palette:** Signal `#22c55e` (accent), Ink `#08090B` (canvas), Panel
  `#0F1217`, Steel `#1A1E26`, Bone `#EDEFF2` (text), Mist `#9BA3AF`, Slate
  `#828C9B` (muted text), Slate deep `#5B6472` (non-text only), Pass/Flag/Block
  verdict scale kept for table pills.
- **Type:** Archivo (display/UI) + JetBrains Mono (labels/code), self-hosted
  under `assets/fonts/`.
- **Motion:** fast, mechanical, 120–420ms, ease-out, `prefers-reduced-motion`
  honored. DFENS's animated "gate" hero (packets passing/blocking through a
  firewall) and rule-fire ticker are deliberately **not** ported — they
  narrate a firewall's decision loop, which doesn't apply here, and a static
  product (pre-revenue, no live traffic yet) showing fabricated "live"
  activity would violate the same claims-discipline this brand is meant to
  inherit.
- **Mark:** new placeholder — three nodes on spokes around a hollow hub, in
  Signal green, meant to read as "many tools, one shared store." Simple by
  design; not a final logo.
- **Accessibility:** WCAG 2.1 AA target, same as DFENS.

## Boilerplate (footer)

> Integrated AI gives your team's AI tools a shared, semantically searchable
> memory — capture a thought in one project, recall it weeks later in
> another, from Claude or any MCP-speaking client. Integrated AI is a DFENS AI
> Ltd product; DFENS AI Ltd also builds DFENS, self-hosted AI Assurance for
> LLM traffic (dfens.ai). Based in the United Kingdom.
