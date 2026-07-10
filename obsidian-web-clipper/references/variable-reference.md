# Variable Reference

Full syntax for every variable type. All are wrapped in `{{ }}` and piped to filters.

## Preset

Auto-generated from page content. No configuration needed.

| Variable | Output |
|----------|--------|
| `{{title}}` | Page title |
| `{{content}}` | Main content (auto-extracted) |
| `{{url}}` | Page URL |
| `{{description}}` | Meta description |
| `{{image}}` | Page image |
| `{{author}}` | Author (standard markup only) |
| `{{published}}` | Publish date (standard markup only) |
| `{{date}}` | Current date at clip time |

`{{author}}` and `{{published}}` only work when the page uses standard `rel="author"` / `datetime` markup. For most platforms, use meta or schema instead.

## Meta

Extract from HTML `<meta>` tags. Two attributes: `property` (Open Graph) and `name`.

```
{{meta:property:og:title}}
{{meta:property:og:image}}
{{meta:property:og:description}}
{{meta:property:article:published_time}}
{{meta:name:author}}
{{meta:name:description}}
```

Always check what's actually on the page before relying on a meta tag — not all sites set them.

## Selector

Extract via CSS selectors. Four forms:

| Form | Extracts |
|------|----------|
| `{{selector:.class}}` | `textContent` of first match |
| `{{selector:tag.attr?attrname}}` | Attribute value of first match |
| `{{selector:.list a}}` | `textContent` of all matches (multitext) |
| `{{selectorHtml:.content\|markdown}}` | `innerHTML` of first match, converted to markdown |

Examples:
```
{{selector:.author-name}}
{{selector:img.hero?src}}
{{selector:.tag-list a}}
{{selectorHtml:article.main|markdown}}
```

## Schema.org

Extract from JSON-LD structured data in the page. Most reliable when present.

Full path:
```
{{schema:@Type:field}}
{{schema:@Article:author}}
{{schema:@Recipe:ingredients}}
{{schema:@NewsArticle:datePublished}}
{{schema:@VideoObject:uploadDate}}
```

Shorthand (finds any matching field regardless of type):
```
{{schema:author}}
{{schema:name}}
{{schema:image}}
```

Array access:
```
{{schema:@Type:arrayField[*].subfield}}
{{schema:@Article:author[*].name}}
```

**Check the schema type first.** Different platforms use different types:
- Medium: `@Article`
- Substack: `@NewsArticle`
- YouTube: `@VideoObject`
- Recipe sites: `@Recipe`

Using the wrong type silently produces empty output.

## Prompt

LLM-powered extraction. Requires **Interpreter** enabled in Web Clipper settings.

Wrap the prompt in quotes inside the braces:
```
{{"summarize this page in 3 bullet points"}}
{{"extract the recipe ingredients"}}
{{"what are the main arguments and counterarguments"}}
```

Prompt variables are always the last resort — use preset/meta/schema/selector first for structured data, prompt only for semantic extraction.
