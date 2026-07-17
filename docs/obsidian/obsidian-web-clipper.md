# obsidian-web-clipper

Build Obsidian Web Clipper templates for any website, inspect pages for extractable data, and debug import or extraction failures.

## When to use

Use this skill when you need an importable JSON template for a website you want to clip into Obsidian. It covers the full pipeline: discovering your vault's conventions, building the template with reliable extraction strategies, and shipping a file that imports cleanly.

Also reach for it when an existing template fails to import (JSON structure errors, unknown fields) or extracts nothing (wrong selectors, missing meta tags, platform redesigns their markup).

## How it works

Obsidian Web Clipper captures pages as Markdown notes, driven entirely by JSON templates. Each template defines URL triggers, extraction rules, frontmatter properties, and the note body format. The core discipline this skill enforces is the **extraction ladder**:

1. **Schema** — structured data (schema.org, JSON-LD) embedded in the page
2. **Meta** — HTML `<meta>` tags with descriptions, authors, dates
3. **Selector** — CSS selectors aimed at specific elements
4. **Prompt** — LLM-powered extraction (Interpreter) as a last resort

Variables are resolved top-to-bottom: schema over meta, meta over selector, selector over prompt. Climbing downward rather than upward is the most common source of brittle templates — a selector breaks when the site redesigns, but a schema.org property keeps working.

Once extraction is wired, the template is handed back as a `.json` file ready to import into the Web Clipper extension settings.

## Usage

Ask your agent to build a template for a specific platform:

> Create an Obsidian Web Clipper template for Medium articles.

The agent runs a three-phase workflow:

1. **Context gathering** — reads your vault's conventions (`CLAUDE.md`, `AGENTS.md`, existing templates, `.obsidian` config) to match your folder structure and frontmatter preferences, asking only about what it can't discover.
2. **Template creation** — copies the field skeleton, sets URL triggers for the target platform, wires extraction variables by climbing the ladder, and resolves every placeholder token.
3. **Delivery** — hands back a structurally valid `.json` with no unresolved tokens, ready for import.

If the platform isn't in the known list (10+ platforms are already covered, including Medium, Substack, YouTube, GitHub, Reddit, and Wikipedia), the skill inspects the live page to discover schema, meta tags, and selectors before writing any variables. If an existing template fails, it walks the gotcha reference rather than guessing at the fix.

## Installation

This skill ships as part of the `andarwaly/skills` collection:

```bash
npx skills add andarwaly/skills
```

## Reference

- [template-reference.md](../../skills/obsidian/obsidian-web-clipper/references/template-reference.md) — Full schema fields, variable types, and template logic
- [common-platform-variables.md](../../skills/obsidian/obsidian-web-clipper/references/common-platform-variables.md) — Known extraction patterns for 10+ platforms
- [filter-reference.md](../../skills/obsidian/obsidian-web-clipper/references/filter-reference.md) — Filter syntax and gotchas
- [page-inspection.md](../../skills/obsidian/obsidian-web-clipper/references/page-inspection.md) — Reverse-engineer selectors on an unlisted platform
- [gotchas.md](../../skills/obsidian/obsidian-web-clipper/references/gotchas.md) — Common import and extraction failures

See the [skill source](../../skills/obsidian/obsidian-web-clipper/) for the full agent-facing instructions.
