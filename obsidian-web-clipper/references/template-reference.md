# Template Reference

Schema fields, variable types, and template logic for Obsidian Web Clipper.

## Schema

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `schemaVersion` | Yes | string | Always `"0.1.0"` |
| `name` | Yes | string | Display name in template switcher |
| `behavior` | Yes | string | `"create"` (new note), `"append-specific"` (appends to file at `path`), `"append-daily"` (daily note) |
| `noteContentFormat` | Yes | string | Note body with variables, filters, logic. Use `\n` for newlines |
| `noteNameFormat` | No | string | File name pattern. Supports variables and filters |
| `path` | No | string | Folder (`create`) or full file path (`append-specific`) |
| `triggers` | No | string[] | URL prefixes, regex (`/pattern/`), or schema.org (`schema:@Type`, `schema:@Type.key=value`) |
| `context` | No | string | Scopes Interpreter input, e.g. `{{selectorHtml:article\|markdown\|trim}}` |
| `properties` | No | array | Frontmatter property definitions |

### Properties

```json
{ "name": "key", "value": "{{variable}}", "type": "text" }
```

**Types:** `text`, `multitext` (comma-separated → array), `number`, `checkbox`, `date`, `datetime`

## Variables

| Type | Syntax | Source |
|------|--------|--------|
| Preset | `{{title}}`, `{{content}}`, `{{url}}`, `{{date}}`, `{{author}}`, `{{published}}`, `{{description}}`, `{{image}}`, `{{domain}}`, `{{favicon}}`, `{{highlights}}`, `{{words}}`, `{{time}}`, `{{selection}}` | Auto-extracted |
| Meta | `{{meta:name:author}}`, `{{meta:property:og:image}}` | HTML `<meta>` tags |
| Selector | `{{selector:.author}}`, `{{selector:img.hero?src}}`, `{{selectorHtml:article\|markdown}}` | CSS selectors |
| Schema.org | `{{schema:@Article:author}}`, `{{schema:name}}`, `{{schema:author[*].name}}` | JSON-LD structured data |
| Prompt | `{{"summarize this"}}` | LLM extraction (needs Interpreter enabled) |

## Logic

### Conditionals

```twig
{% if author %}By {{author}}{% endif %}
{% if status == "published" %}Live{% elseif status == "draft" %}Draft{% else %}Unknown{% endif %}
```

**Operators:** `==`, `!=`, `>`, `<`, `>=`, `<=`, `contains` (string substring or array membership)

**Logical:** `and` / `&&`, `or` / `||`, `not` / `!`

**Truthiness:** `false`, `null`, `undefined`, `""`, `0`, `[]` are falsy. Everything else truthy.

```twig
{% if author and published %}Both present{% endif %}
{% if (premium or featured) and published %}Active premium/featured content{% endif %}
```

### Loops

```twig
{% for tag in tags %}{{tag}}{% if not loop.last %}, {% endif %}{% endfor %}
{% for item in schema:author %}{{item.name}}{% endfor %}
{% for comment in selector:.comment %}...{% endfor %}
```

**Sources:** Schema arrays, selector results, variables set with `{% set %}`.

**Loop variables:** `loop.index` (1-indexed), `loop.index0` (0-indexed), `loop.first`, `loop.last`, `loop.length`. Backwards compat: `item_index`.

**Array access:** `{{items[0]}}`, `{{data["my-key"]}}`, `{{timestamps[loop.index0]}}`

### Variable assignment

```twig
{% set slug = title|lower|replace:" ":"-" %}
{% set items = selector:.list-item %}
```

### Fallbacks

`{{title ?? "Untitled"}}` uses the first non-empty value. Filters bind before `??`.

### Filters

Full reference in [filter-reference.md](filter-reference.md).

### Evaluation order

1. Template logic + `{{variables}}` evaluated first
2. Prompt variables sent to Interpreter after (results not available for conditionals)

## Live docs

- Full filter/variable docs: [github.com/obsidianmd/obsidian-clipper](https://github.com/obsidianmd/obsidian-clipper)
- Official help: [obsidian.md/help/web-clipper](https://obsidian.md/help/web-clipper)
