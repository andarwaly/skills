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

Before writing any code, interview the user to understand what they need. Ask until you have clear answers:

1. **What website or platform** is this template for? (e.g. Wikipedia, Medium, a blog, a podcast site)
2. **What content** should be captured? (article body, video transcript, comments, highlights)
3. **What metadata fields** matter to them? (author, published date, tags, cover image, description, custom fields)
4. **Where should notes land** in their vault? (folder path, naming convention)
5. **Any special processing?** (AI summary via Interpreter, conditional logic, table formatting)
6. **Any special trigger patterns?** (specific subdomain, regex, schema.org type matching)

Repeat each answer back for confirmation before proceeding. Only move to execution after the user confirms all answers.

### Archetype

A single structural skeleton at [templates/template.json](templates/template.json) shows the full set of configurable fields. Copy it, then fill the resolved values from the discovery phase and remove unused fields.

Refer to [references/template-json-reference.md](references/template-json-reference.md) for every field, property type, trigger format, and behavior value.

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

---

## Troubleshooting & Debugging

Use when extraction is failing, values are wrong, or the template won't import.

### JSON won't import

**`properties` must be an array, not an object.**

Wrong:
```json
"properties": { "title": "{{title}}" }
```

Correct:
```json
"properties": [
  { "name": "title", "value": "{{title}}", "type": "text" }
]
```

### Old field names don't work

| Old (broken) | New (correct) |
|-------------|---------------|
| `noteName` | `noteNameFormat` |
| `noteLocation` | `path` |
| `content` | `noteContentFormat` |

### Filter syntax

Every filter argument must be quoted:

Wrong: `{{title|replace:old:new}}`
Correct: `{{title|replace:"old":"new"}}`

No regex capture groups in `replace`. Chain multiple simple `replace` calls instead.

### Property types

Each property needs the correct `type`:

| Type | Use for |
|------|---------|
| `text` | Single-line values |
| `multitext` | Arrays of values (author list, tags) |
| `date` | Date values (use `date` filter for formatting) |
| `checkbox` | Boolean true/false |
| `number` | Numeric values |

### Content format gotchas

- **YouTube dates:** `datePublished` is the video's original upload date, not the current date.
- **`selectorHtml` → markdown:** The `selectorHtml:body|markdown` combo requires the `markdown` filter after it.
- **Prompt variables need Interpreter enabled:** Without Interpreter on, `{{"summarize this"}}` renders as literal text.

### Platform limitations

**Twitter/X:** Post text extracted from page title via text filters. Works on individual post pages. Use highlights for full thread capture.

**Substack:** Full articles accessible via meta tags, but some content may be paywalled.

**Reddit:** May block content without authentication. Use selector variables for subreddit-specific fields.

---

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
| [references/12-platform-variables.md](references/12-platform-variables.md) | Known variable patterns for Medium, Substack, YouTube, GitHub, Reddit, Apple Podcasts, and more |
| [references/filter-reference.md](references/filter-reference.md) | Filter names, arguments, and syntax |
| [references/template-logic.md](references/template-logic.md) | Conditionals, loops, fallbacks, set |
| [references/gotchas.md](references/gotchas.md) | Common errors and solutions |
| [references/06-templates.md](references/06-templates.md) | Official docs on template settings, triggers, behavior |
| [references/07-variables.md](references/07-variables.md) | Official docs on all variable types |
| [references/08-filters.md](references/08-filters.md) | Official full filter reference |
| [references/09-logic.md](references/09-logic.md) | Official template logic reference |
| [references/10-troubleshoot.md](references/10-troubleshoot.md) | Official troubleshoot docs (Defuddle bypass, Linux/iOS issues) |
