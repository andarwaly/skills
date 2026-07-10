# Template JSON Reference

The Obsidian Web Clipper imports templates as JSON files. This reference documents every field, property type, trigger format, and behavior value.

## Root Structure

```json
{
  "schemaVersion": "0.1.0",
  "name": "My Template",
  "behavior": "create",
  "noteContentFormat": "# {{title}}\n\n{{content}}",
  "noteNameFormat": "{{title|safe_name}}",
  "path": "Clippings",
  "triggers": ["https://example.com/"],
  "properties": [
    { "name": "source", "value": "{{url}}", "type": "text" }
  ]
}
```

## Field Reference

### `schemaVersion`

Required. Always `"0.1.0"`.

### `name`

Required. Human-readable name shown in the template switcher and settings.

```
"Medium Article"
"YouTube Video"
```

### `behavior`

Required. Controls what happens when content is clipped.

| Value | Effect | `path` usage |
|-------|--------|-------------|
| `"create"` | Creates a new note | Folder to save in |
| `"append-specific"` | Appends to a specific existing note | Full file path of target note |
| `"append-daily"` | Appends to today's daily note | Ignored (uses daily note path) |

### `noteContentFormat`

Required. The note body content. Supports variables, filters, and template logic.

Newlines use `\n` inside the JSON string.

```json
"noteContentFormat": "# {{title}}\n\n{{content}}"
```

Full syntax: [variable-reference.md](variable-reference.md), [filter-reference.md](filter-reference.md), [template-logic.md](template-logic.md).

### `noteNameFormat`

Optional. File name pattern. Supports variables and filters.

| Pattern | Result |
|---------|--------|
| `"{{title\|safe_name}}"` | Page title, sanitized for file system |
| `"{{date}} - {{title\|safe_name}}"` | Date prefix |
| `"{{published\|date:\"YYYY\"}}/{{title\|safe_name}}"` | Year subfolder via slash |

### `path`

Optional. Vault location for the note.

| Behavior | `path` value | Example |
|----------|-------------|---------|
| `create` | Folder path | `"Resources/Articles"` |
| `append-specific` | Full file path | `"Databases/Recipes.md"` |

If omitted, the extension's default folder is used.

### `triggers`

Optional. Array of patterns that auto-select this template. Three types:

**Simple URL prefix**
```json
"triggers": [
  "https://medium.com/",
  "https://www.youtube.com/"
]
```
Matches any URL starting with the pattern.

**Regular expression**
```json
"triggers": [
  "/^https:\\/\\/[a-zA-Z0-9-]+\\.medium\\.com\\/.*$/"
]
```
Enclose in forward slashes. Escape special characters (`/`, `.`) with backslash. Supports JavaScript regex syntax.

**Schema.org matching**
```json
"triggers": [
  "schema:@Recipe",
  "schema:@Recipe.name",
  "schema:@Recipe.name=Cookie"
]
```
- `schema:@Recipe` — matches pages where the schema type is Recipe
- `schema:@Recipe.name` — matches when `@Recipe.name` is present
- `schema:@Recipe.name=Cookie` — matches when `@Recipe.name` equals "Cookie"

Triggers are evaluated in template list order. The first match wins. Drag templates to reorder in settings.

### `context`

Optional. Controls what page content the Interpreter (LLM) processes. Uses any variable type to scope the data.

```json
"context": "{{selectorHtml:article|markdown|trim}}"
```

Without `context`, Interpreter uses the full page HTML. Narrowing the context makes prompts faster and cheaper.

### `properties`

Optional. Array of frontmatter property definitions.

```json
"properties": [
  { "name": "source", "value": "{{url}}", "type": "text" },
  { "name": "author", "value": "{{author|wikilink}}", "type": "multitext" },
  { "name": "published", "value": "{{published}}", "type": "date" },
  { "name": "favorite", "value": "false", "type": "checkbox" },
  { "name": "rating", "value": "{{selector:.rating}}", "type": "number" }
]
```

#### Property Types

| Type | Description | Example value |
|------|-------------|---------------|
| `text` | Single line of text | `"{{title}}"`, `"{{url}}"` |
| `multitext` | Array of text values (tags, authors) | `"to-read, medium"`, `"{{author\|wikilink}}"` |
| `number` | Numeric value | `"{{selector:.count}}"`, `"5"` |
| `checkbox` | Boolean true/false | `"true"`, `"false"` |
| `date` | Date in YYYY-MM-DD format | `"{{published\|date:\"YYYY-MM-DD\"}}"` |
| `datetime` | Date and time | `"{{time\|date:\"YYYY-MM-DDTHH:mm\"}}"` |

#### Property Object Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Key name in YAML frontmatter |
| `value` | Yes | Value to populate. Supports all variable types. |
| `type` | Yes | One of the types above |

**Notes:**
- `multitext` values can be comma-separated strings; the clipper splits them into an array.
- `date` formatting uses the `date` filter: `{{published|date:"YYYY-MM-DD"}}`
- Property names with hyphens or spaces may render differently in YAML frontmatter.

## Variable Types

Full reference: [variable-reference.md](variable-reference.md).

| Type | Syntax | Source |
|------|--------|--------|
| Preset | `{{title}}`, `{{content}}`, `{{url}}`, `{{date}}` | Auto-extracted from page |
| Meta | `{{meta:name:author}}`, `{{meta:property:og:image}}` | HTML `<meta>` tags |
| Selector | `{{selector:.author}}`, `{{selector:img.hero?src}}` | CSS selector |
| Schema.org | `{{schema:@Article:author}}`, `{{schema:name}}` | JSON-LD structured data |
| Prompt | `{{"summarize this"}}` | LLM extraction (needs Interpreter) |
| Selector HTML | `{{selectorHtml:article\|markdown}}` | HTML → Markdown conversion |

## Filters

Full reference: [filter-reference.md](filter-reference.md).

Common filters:
- `{{title|safe_name}}` — filesystem-safe filename
- `{{author|wikilink}}` — `[[Author Name]]`
- `{{url|link}}` — `[url](url)`
- `{{date|date:"YYYY-MM-DD"}}` — date formatting
- `{{tags|join:", "}}` — array to string
- `{{content|markdown}}` — HTML to Markdown
- `{{text|replace:"old":"new"}}` — text replacement

## Template Logic

Full reference: [template-logic.md](template-logic.md).

**Conditionals:**
```twig
{% if author %}By {{author}}{% endif %}
{% if status == "published" %}Live{% else %}Draft{% endif %}
```

**Loops:**
```twig
{% for tag in tags %}[[{{tag}}]]{% if not loop.last %}, {% endif %}{% endfor %}
```

**Fallbacks:**
```twig
{{title ?? "Untitled"}}
{{author ?? schema:author ?? "Unknown"}}
```

**Variable assignment:**
```twig
{% set slug = title|lower|replace:" ":"-" %}
```

## Examples Gallery

Complete, working templates in [examples/](../examples/) demonstrating different configuration patterns:

| File | Demonstrates |
|------|-------------|
| [01-simple.json](../examples/01-simple.json) | Minimal structure — basic create, preset variables, no special features |
| [02-with-interpreter.json](../examples/02-with-interpreter.json) | LLM prompt variables (`{{"..."}}`) in `noteContentFormat` and property values |
| [03-with-triggers.json](../examples/03-with-triggers.json) | URL prefix + regex + schema.org triggers, selector variable for numeric field |
| [04-append.json](../examples/04-append.json) | `append-specific` behavior, schema.org trigger, appending to a single database note |
| [05-with-logic.json](../examples/05-with-logic.json) | Conditionals (`{% if %}`), loops (`{% for %}`), `{% set %}`, table formatting, `date` as last pipe |
| [06-with-context.json](../examples/06-with-context.json) | `context` field scoping Interpreter to a specific selector, HTML-to-markdown pipeline |

### Pattern guide

| If you need to... | Start from |
|-------------------|------------|
| Capture an article with frontmatter | `01-simple.json` |
| Add AI summaries or LLM extraction | `02-with-interpreter.json` |
| Match multiple URL patterns or schema types | `03-with-triggers.json` |
| Append to an existing note (recipe database, reading log) | `04-append.json` |
| Use conditionals, loops, and table formatting | `05-with-logic.json` |
| Scope LLM context to a section of the page | `06-with-context.json` |
