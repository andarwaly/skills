# Grilling Session — Skill Factory Decisions

Date: 2026-06-23

## Product Scope

Build curated agent skill packages, distributed via skills.sh, free. Monorepo at `dzakyandarwa/skill-factory`.

## Initial Skill Pack (3 skills)

| # | Skill | Type | Priority |
|---|-------|------|----------|
| 1 | Obsidian Web Clipper | Stateless (one-time generator) | First |
| 2 | POE2 Build Planner | Stateful (Builds > Season > Class) | Second |
| 3 | Skill Factory Router | User-invoked (discovery + updates) | Third |

## Obsidian Web Clipper

### Design
- One-time generator. User runs it once per site, gets a JSON clipper template, done.
- Diagnostic fallback: if a template breaks later, skill explains what a CSS class is and how to inspect.
- Bundled examples: YouTube transcript, Medium article, other common sites.
- If the user's agent has browser access, use it to help inspect the target page.

### Flow
1. Scan vault for a `templates/` folder via `obsidian-cli`
2. Report findings to user
3. Ask: "Do you already have a template, format, or rules for your vault?"
4. If yes, adapt to existing conventions. If no, offer default frontmatter and template structure.
5. Inspect target page, find selectors, generate clipper JSON.

### Audience
Obsidian users who don't know how to inspect a site, write CSS selectors, or navigate the clipper variable syntax.

## POE2 Build Planner

### Design
- Three layers: interview → live research → build output.
- Stateful workspace: `Builds > <Season> > <Class> > build files`.
- Old leagues auto-archived by folder structure. Skill detects version mismatch on startup.

### Layers
1. **Interview** — what playstyle? what class? what content goals?
2. **Research** — laddered data sources. Embedded canonical sources first (GGG passive tree export, RePoE). Fall back to web search discovery. Prompt user to update sources if fallback fires repeatedly.
3. **Build** — generate both `.build.json` (machine-readable, GGG format) and HTML guide (human-readable, maxroll-style).

### Data Sources (from poe2-ai-planner)
- `poe2-skilltree-export/data.json` — official passive tree (5,151 nodes)
- RePoE community exports: skill gems, base items, mods, uniques, ascendancies
- External live: maxroll.gg, mobalytics.gg, poe.ninja, poe2db.tw, pathofexile.com patch notes

### Audience
New POE2 players who want guided build creation, contextualized to current league meta.

## Skill Factory Router

User-invoked discovery skill. Lists available skills, helps user choose, checks for updates. No context load — fired by hand only.

## Technical Decisions

| Decision | Choice |
|----------|--------|
| Skill format | agentskills.io standard only. No Claude Code extensions. |
| Frontmatter | name + description + metadata (author, version). license optional. |
| Write pipeline | humanizer + write-a-skill → review via Matt Pocock stateless/stateful test + writing-great-skills |
| Distribution | Free on skills.sh via `npx skills add dzakyandarwa/skill-factory` |
| Monetization | None initially. Marketplace later if demand warrants. |
| Local install | Never. Skills stay in project `skills/` directory. |
