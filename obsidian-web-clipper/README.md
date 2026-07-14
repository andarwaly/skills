<div align="center">

# obsidian-web-clipper

*Build Obsidian Web Clipper templates for any website*

[![skills.sh](https://img.shields.io/badge/skills.sh-andarwaly%2Fskills-blue?style=flat-square)](https://skills.sh)
[![Version](https://img.shields.io/badge/version-1.0.0-informational?style=flat-square)](SKILL.md)
[![Spec](https://img.shields.io/badge/Spec-agentskills.io-green?style=flat-square)](https://agentskills.io)

[Installation](#installation) • [Updating](#updating) • [Usage](#usage) • [Structure](#structure)

</div>

An [agent skill](https://agentskills.io) that turns a request like "make me a Web Clipper template for Medium" into an importable `.json` file. It also inspects unfamiliar pages for extractable data and diagnoses import/extraction failures.

**The problem**: [Obsidian Web Clipper](https://obsidian.md/help/web-clipper) saves web pages into your vault as Markdown, driven entirely by JSON templates you write by hand. That means learning a field schema, a variable syntax with four extraction strategies, a filter pipeline, and a Twig-like logic language, just to clip one site correctly.

**The fix**: this skill carries that knowledge so your agent doesn't have to guess at it. It reads your vault's conventions first, then builds the template using whichever extraction strategy is most reliable for the target platform.

> [!NOTE]
> Every variable in a template resolves through **the extraction ladder**: schema.org data, then meta tags, then CSS selectors, then an LLM prompt, in decreasing order of reliability. Climbing it top-down is the core discipline the skill enforces.

## Installation

This skill ships as part of the `andarwaly/skills` collection:

```bash
npx skills add andarwaly/skills
```

Skills auto-index from CLI telemetry, so once the collection is registered your agent picks up `obsidian-web-clipper` the next time a request matches its trigger: creating a template, inspecting a page, or debugging an import error.

## Updating

```bash
npx skills update obsidian-web-clipper
```

Pull-based only, there's no version pinning; this always fetches whatever is current on `main`.

## Usage

Ask your agent to build a template for a site:

> Create an Obsidian Web Clipper template for Substack articles.

The skill runs a three-phase workflow:

1. **Context gathering**: reads your vault's `CLAUDE.md`/`AGENTS.md`, existing templates, and `.obsidian` config to match your folder structure and frontmatter conventions, asking only about what it can't discover.
2. **Template creation**: copies the field skeleton, wires triggers and extraction variables for the target platform, and resolves every `REPLACE_ME` token.
3. **Delivery**: hands back a structurally valid `.json`, ready to import into Web Clipper settings.

If the platform isn't in the known list, the skill inspects the live page in the browser console for schema, meta tags, and selectors before writing a single variable. If an existing template fails to import or extracts nothing, it walks the gotcha reference instead of guessing.

> [!TIP]
> Ten-plus platforms already have known-good extraction patterns: Medium, Substack, YouTube, GitHub, Reddit, Wikipedia, and more. See [`references/common-platform-variables.md`](references/common-platform-variables.md).

## Structure

```
obsidian-web-clipper/
├── SKILL.md                          # Entry point: workflow, anti-patterns, troubleshooting
├── templates/template.json           # Field skeleton every new template starts from
├── examples/                         # Complete, importable template JSON files
└── references/
    ├── template-reference.md         # Schema fields, variable types, template logic
    ├── filter-reference.md           # Filter syntax and gotchas
    ├── common-platform-variables.md  # Known extraction patterns, 10+ platforms
    ├── page-inspection.md            # Reverse-engineer selectors on an unlisted platform
    └── gotchas.md                    # Common import/extraction failures
```

The reference layer follows progressive disclosure: `SKILL.md` carries the workflow, the anti-patterns, and the extraction ladder; anything a specific step needs on demand (full filter syntax, per-platform selectors, the JSON schema) lives in `references/` and is pulled in only when that step is reached.

> [!WARNING]
> A full Web Clipper settings export contains interpreter API keys in plaintext (`interpreter_settings.providers[].apiKey`). Never commit one to version control.
