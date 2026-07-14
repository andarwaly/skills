---
name: obsidian-web-clipper
description: >-
  Use when creating Web Clipper templates for a website, inspecting pages
  for available variables, or debugging extraction failures and import errors.
---

# Obsidian Web Clipper

Obsidian Web Clipper templates are structured JSON files that define how the clipper extension captures web content and metadata. Every variable climbs **the extraction ladder**: schema, then meta, then selector, then prompt, in decreasing order of reliability.

## Context needed

Ask the user about anything missing below until you understand what they want to capture. **Never assume.**

1. **Vault convention:** How the user organizes their vault, folder structure, naming pattern, and any vault-wide rule the template needs to follow.
   *read: `CLAUDE.md`, `AGENTS.md`, `README.md` if present*
2. **Existing frontmatter systems:** What properties (YAML frontmatter) does the user already use across notes? Any property they always include? Any they want for this specific content type?
   *read: `.obsidian/templates.json` for the templates location, `.obsidian/plugins/templater-obsidian` if the user uses Templater and configures their template location there, `.obsidian/types.json` for property types the user has already defined*
3. **Note body structure:** What should the captured content look like? Bare `{{content}}`? Sections with headings? AI summary? Custom formatting?
   *read: the user's existing template files to learn how they capture things*
4. **Interpreter usage:** Does the user want LLM-powered extraction (summaries, structured data, transformations)? Requires enabling Interpreter in the extension.
5. **Target folder:** Prefer the template folder the user already defined, and record it as `user-template-folder/Clipper`.

## Anti-patterns

- **Selector-first extraction:** reaching for a CSS selector before checking schema or meta. **The tell:** the template breaks the moment the site redesigns its markup, when a schema.org type or meta tag would have kept working. This is the extraction ladder climbed downward instead of up.
- **Unresolved `REPLACE_ME`:** shipping a template with a placeholder token still in a property value. **The tell:** import succeeds silently, and the field renders the literal string `REPLACE_ME` in the note instead of erroring. The failure surfaces in the user's vault, not at import time.

---

## Building the template

### 1. Context gathering

Cover everything in Context needed above. Present the expected output to the user as rendered markdown, not JSON.

### 2. Understand the JSON structure

The skeleton at [templates/template.json](templates/template.json) covers every configurable field. [references/template-reference.md](references/template-reference.md) has the full spec: field types, trigger formats, behavior values.

### 3. Set up the JSON template

Copy `templates/template.json`. Set `name` to platform + content type (e.g. `"Medium Article"`). Fill resolved values from Context needed; remove unused fields.

**Done when:** File has `schemaVersion`, `name`, `behavior`, `noteContentFormat`, `noteNameFormat`, `path`, `triggers`, and `properties`. All `REPLACE_ME` tokens present.

### 4. Set triggers

Replace `triggers` with URL patterns for the target platform: bare prefix for known domains, regex for subdomains.

```json
"triggers": [
  "https://medium.com/",
  "/^https:\\/\\/[a-zA-Z0-9-]+\\.medium\\.com\\/.*$/"
]
```

**Done when:** The trigger list targets content pages (articles, videos) and excludes navigation pages (homepage, search, settings). Regex is wrapped in forward slashes.

### 5. Wire platform extraction

Replace the `REPLACE_ME` tokens (`author`, `published`, tags, output folder) by climbing the extraction ladder: schema first, then meta, then selector, then prompt as a last resort. Reference [references/common-platform-variables.md](references/common-platform-variables.md) and [examples/](examples/) for complete worked templates.

**Done when:** Every `REPLACE_ME` extraction field is replaced with a variable expression matching the platform's confirmed field type (see [references/page-inspection.md](references/page-inspection.md) if the platform isn't known). See [references/template-reference.md](references/template-reference.md) for full syntax.

### 6. Adapt note content format

The skeleton's `{{content}}` covers article text, highlights, or selection, which is sufficient for most platforms.

If the platform needs special treatment:
- **Videos with transcripts:** Customize `noteContentFormat` to structure transcript content (see examples)
- **LLM-enhanced notes:** Add prompt variables like `{{"summarize this"}}` in `noteContentFormat` and set `context` to scope input
- **Conditional formatting:** Add template logic around `{{content}}`

**Done when:** `noteContentFormat` produces the desired note structure for the target platform.

### 7. Deliver

The `.json` must be structurally valid and importable. All `REPLACE_ME` tokens must be resolved.

**Done when:** JSON parses without error. The user imports into Web Clipper settings and verifies on a real page.

---

## Troubleshooting & Debugging

### Target platform not in known list
Climb the extraction ladder manually: inspect the live page for schema, meta, and selectors before writing variables. See [references/page-inspection.md](references/page-inspection.md).

### JSON won't import
`properties` must be an array, not an object. See [references/gotchas.md#json-structure](references/gotchas.md) and [references/template-reference.md](references/template-reference.md) for the full schema.

### Old field names / property types
See [references/gotchas.md#json-structure](references/gotchas.md) and [references/template-reference.md](references/template-reference.md).

### Filter gotchas
See [references/filter-reference.md#gotchas](references/filter-reference.md).

### Content gotchas / platform limitations
See [references/gotchas.md#platform-specific](references/gotchas.md) and [references/common-platform-variables.md](references/common-platform-variables.md).

### Security
Full Web Clipper settings exports leak interpreter API keys in plaintext (`interpreter_settings.providers[].apiKey`). Never commit a full export to version control. See [references/gotchas.md#security](references/gotchas.md).

---

## Reference Pointer

| File | When to reach |
|------|----------------|
| [references/template-reference.md](references/template-reference.md) | Schema fields, variable types, and template logic in one file |
| [references/filter-reference.md](references/filter-reference.md) | Full filter reference with gotchas |
| [references/common-platform-variables.md](references/common-platform-variables.md) | Known extraction patterns for 10+ platforms |
| [references/page-inspection.md](references/page-inspection.md) | Discover selectors/schema on an unlisted platform |
| [references/gotchas.md](references/gotchas.md) | Common errors and solutions |
| [examples/](examples/) | Complete template JSON files, ready to reference |
