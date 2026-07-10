# Gotchas & Common Errors

## JSON Structure

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

**Old field names don't work.** Use the current names:

| Old (broken) | New (correct) |
|-------------|---------------|
| `noteName` | `noteNameFormat` |
| `noteLocation` | `path` |
| `content` | `noteContentFormat` |

## Filter Syntax

**Quoted filter arguments.** Every argument must be quoted:

Wrong: `{{title|replace:old:new}}`

Correct: `{{title|replace:"old":"new"}}`

**No regex capture in `replace`.** `$1`, `$2` are not supported. Chain multiple simple `replace` calls or use prompt extraction instead.

## Property Types

The `type` field on each property controls how Obsidian interprets the value:

| `type` | Use for | Example value |
|--------|---------|---------------|
| `text` | Single string | `"note"`, a URL |
| `multitext` | List/array | `["tag1", "tag2"]` |
| `date` | Date only (YYYY-MM-DD) | `"2026-06-23"` |
| `datetime` | Date and time | `"2026-06-23T14:30:00"` |
| `checkbox` | Boolean | `"true"` or `"false"` |

A date string in a `"text"` property won't be treated as a date by Obsidian. Use `"date"` or `"datetime"`.

## Schema Type Mismatches

Different platforms use different schema.org types. Using the wrong one silently produces empty output.

Verify the type on the actual page before writing `{{schema:@Type:field}}`:

- Check `document.querySelector('script[type="application/ld+json"]')?.textContent` in the browser console
- Look for `"@type"` in the JSON-LD

## Highlights vs Content

When the user highlights text on the page before clipping:
- `{{highlights}}` — the selected text
- `{{content}}` — the full auto-extracted content (does NOT switch to highlights)

To handle both:
```
{% if highlights %}
{{highlights|template:"- ${text}\n"|join:"\n"}}
{% else %}
{{content}}
{% endif %}
```

## Escape Sequences

In JSON, nested quotes must be escaped:

```json
"{{published|date:\"YYYY-MM-DD\"}}"          // filter arg in variable
"{{\"key idea of the page\"}}"               // prompt variable
```

Deep nesting (prompt inside a property value): `\\\"`:
```json
"{{\\\"write a summary\\\"}}"
```

The rule: count how many JSON string boundaries the quote crosses. Each boundary adds one `\`.

## Platform-Specific

**Threads (threads.com):**
- `og:description` only captures ~77 characters (first post preview)
- `og:image` only shows first image
- Full thread needs: login → highlight all posts → clip

**Reddit:**
- May block content without authentication
- Use selector variables for subreddit-specific fields

**Twitter/X:**
- Preview only without login
- Use highlights for full thread capture
