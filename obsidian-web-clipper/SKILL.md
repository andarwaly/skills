---
name: obsidian-web-clipper
description: >-
  Use when creating Web Clipper templates for a website, inspecting pages
  for available variables, or debugging extraction failures and import errors.
---

# Obsidian Web Clipper

A skill pack for building [Obsidian Web Clipper](https://obsidian.md/help/web-clipper) templates, inspecting pages for available data, and diagnosing common issues.

- [Template Creation](#template-creation) — produce a `.json` file ready to import
- [Page Inspection](#page-inspection) — find variables and selectors on unfamiliar pages
- [Troubleshooting & Debugging](#troubleshooting--debugging) — fix common errors

---


## Template Creation

### Discovery — gather requirements first




**Cover these topics (not necessarily in this order):**

1. **Vault conventions** — How does the user organize their vault? Folder structure, naming patterns, any vault-wide rule the template must follow.
2. **Target folder** — Where should clipped notes land? (e.g. `Clippings/`, `Inbox/`, `Resources/Articles/`)
3. **Existing frontmatter system** — What properties (YAML frontmatter) does the user already use across notes? Any property they always include? Any they want for this specific content type?
4. **Interpreter (AI) usage** — Does the user want LLM-powered extraction (summaries, structured data, transformations)? Requires enabling Interpreter in the extension.
5. **Note body structure** — What should the note content look like? Bare `{{content}}`? Sections (AI Summary, Highlights, Key Quotes)? Custom formatting?

The agent should explore the user's vault structure if accessible (folder layout, existing notes, property patterns) before asking about it. Do not ask questions the vault itself can answer.

Only after all requirements are confirmed, proceed to template construction.

### Archetype

A single structural skeleton at [templates/template.json](templates/template.json) shows the full set of configurable fields. Copy it, then fill the resolved values from the discovery phase and remove unused fields.
Refer to [references/template-json-reference.md](references/template-json-reference.md) for every field, property type, trigger format, and behavior value.

#### 1. Start from skeleton

Copy `templates/template.json` into a working file. Set `name` to the platform and content type (e.g. `"Medium Article"`, `"YouTube Video"`).

**Done when:** File has `schemaVersion`, `name`, `behavior`, `noteContentFormat`, `noteNameFormat`, `path`, `triggers`, and `properties`. All `REPLACE_ME` tokens present.

#### 2. Set triggers

Replace `triggers` with URL patterns for the target platform. Use bare prefix strings for known domains. Add a regex for subdomains.

```json
"triggers": [
  "https://medium.com/",
  "/^https:\\/\\/[a-zA-Z0-9-]+\\.medium\\.com\\/.*$/"
]
```

**Done when:** The trigger list targets content pages (articles, videos) and excludes navigation pages (homepage, search, settings). Regex is wrapped in forward slashes.

#### 3. Wire platform extraction

Replace the `REPLACE_ME` tokens: `author`, `published`, tags, and output folder. Reference the [Platform Quick Reference](#platform-quick-reference) below.

Start with the strongest variable type, fall back through weaker ones (schema → meta → selector → prompt).

**Done when:** Every variable resolves to a non-empty value when tested against a real page from the platform. See [references/variable-reference.md](references/variable-reference.md) for full syntax.

#### 4. Adapt note content format

The skeleton uses `{{content}}` which automatically includes article text, highlights, or selection. For most platforms this is sufficient.

If the platform needs special treatment:
- **Videos with transcripts:** Customize `noteContentFormat` to structure transcript content (see examples)
- **LLM-enhanced notes:** Add prompt variables like `{{"summarize this"}}` in `noteContentFormat` and set `context` to scope input
- **Conditional formatting:** Add template logic around `{{content}}`

**Done when:** `noteContentFormat` produces the desired note structure for the target platform.

#### 5. Deliver

The `.json` must be structurally valid and importable. All `REPLACE_ME` tokens must be resolved.

**Done when:** JSON parses without error. The user imports into Web Clipper settings and verifies on a real page.

---

## Page Inspection

When the target platform is not in the known list, inspect the page to find what's actually available before writing variables. See [references/12-platform-variables.md](references/12-platform-variables.md) for known patterns across 10+ platforms.

### Step 1: Check meta tags and schema

Open the page and run in the browser console:

```js
JSON.stringify({
  ogTitle: document.querySelector('meta[property="og:title"]')?.content,
  ogImage: document.querySelector('meta[property="og:image"]')?.content,
  ogDescription: document.querySelector('meta[property="og:description"]')?.content,
  author: document.querySelector('meta[name="author"]')?.content,
  published: document.querySelector('meta[property="article:published_time"]')?.content,
  schemaType: document.querySelector('script[type="application/ld+json"]')?.textContent?.substring(0, 500)
}, null, 2)
```

**Done when:** You have identified which of the 4 fields (author, published, description, cover) are available via meta tags or schema.org.

### Step 2: Find selectors for missing fields

For any field that came up null, find the right CSS selector:

```js
// Author
document.querySelector('.author-name')?.textContent
document.querySelector('[rel="author"]')?.textContent

// Date
document.querySelector('time')?.getAttribute('datetime')
document.querySelector('.post-date')?.textContent

// Tags
document.querySelectorAll('.tag-list a')?.length
```

**Done when:** Every field the template will extract has a confirmed selector or schema path that returns a non-null value.

### Step 3: Confirm extraction priority

Rank by reliability:
1. **Schema.org** — most reliable (structured, typed)
2. **Meta** — reliable when present
3. **Selector** — fragile, site-change-prone
4. **Prompt** — LLM extraction, last resort

**Done when:** Every variable uses the strongest available extraction type.


### JSON won't import

`properties` must be an array, not an object. See [references/template-json-reference.md](references/template-json-reference.md) for the full schema.

### Old field names

| Old (broken) | New (correct) |
|-------------|---------------|
| `noteName` | `noteNameFormat` |
| `noteLocation` | `path` |
| `content` | `noteContentFormat` |

### Property types

Each property needs a `type`: `text`, `multitext`, `date`, `checkbox`, `number`. See [references/template-json-reference.md](references/template-json-reference.md).

### Filter gotchas

Quoted arguments: `{{title|replace:"old":"new"}}`. No regex capture groups. `date` must be last when chained. See [references/filter-reference.md](references/filter-reference.md).

### Content gotchas

- YouTube `datePublished` is the video's upload date, not the current date
- `selectorHtml:body|markdown` needs the `markdown` filter after it
- Prompt variables need Interpreter enabled in the extension

### Security

Full Web Clipper settings exports contain interpreter API keys in plaintext (`interpreter_settings.providers[].apiKey`). Never commit a full export to version control.

### Platform limitations

See [references/12-platform-variables.md](references/12-platform-variables.md) for per-platform notes.

## Platform Quick Reference

Variable extraction patterns for the three most common platforms. For GitHub, Reddit, Apple Podcasts, Hacker News, and others, see [references/12-platform-variables.md](references/12-platform-variables.md).

| Field | Medium | Substack | YouTube |
|-------|--------|----------|---------|
| name | `"Medium Article"` | `"Substack Article"` | `"YouTube Video"` |
| author | `{{author\|wikilink}}` | `{{meta:name:author\|wikilink}}` | `{{schema:@VideoObject:author\|wikilink}}` |
| published | `{{meta:property:article:published_time\|date:"YYYY-MM-DD"}}` | `{{schema:@NewsArticle:datePublished\|date:"YYYY-MM-DD"}}` | `{{schema:@VideoObject:uploadDate\|date:"YYYY-MM-DD"}}` |
| tags | `to-read, medium` | `to-read, substack` | `to-watch, youtube` |
| path | `Clippings/Articles` | `Clippings/Articles` | `Clippings/Videos` |
| triggers | `["https://medium.com/"]` | `["https://substack.com/"]` | `["https://www.youtube.com/"]` |

Complete template JSON files: [examples/](examples/). More platforms: [references/12-platform-variables.md](references/12-platform-variables.md).

---

## Reference

| File | When to reach |
|------|---------------|
| [references/template-json-reference.md](references/template-json-reference.md) | Full schema reference — all fields, property types, triggers, behavior |
| [references/variable-reference.md](references/variable-reference.md) | Full syntax for preset, meta, selector, schema, prompt variables |
