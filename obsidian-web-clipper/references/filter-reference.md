# Filter Reference

Applied with pipe syntax: `{{variable|filter}}`. Chainable: `{{title|lower|replace:" ":"-"}}`.

## Date

| Filter | Example | Output |
|--------|---------|--------|
| `date:"fmt"` | `{{published\|date:"YYYY-MM-DD"}}` | `2026-06-23` |
| `date_modify:"+N unit"` | `{{date\|date_modify:"+1 day"}}` | Tomorrow's date |

Format tokens: `YYYY`, `MM`, `DD`, `HH`, `mm`, `ss`.

## Text

| Filter | Effect |
|--------|--------|
| `lower` | lowercase |
| `upper` | UPPERCASE |
| `title` | Title Case |
| `kebab` | kebab-case-slug |
| `snake` | snake_case_slug |
| `safe_name` | Filesystem-safe: strips special chars, truncates |
| `trim` | Strip leading/trailing whitespace |
| `replace:"old":"new"` | Find and replace |

Note: `replace` requires quoted arguments. No regex capture groups supported.

## Format

| Filter | Effect | Example |
|--------|--------|---------|
| `wikilink` | `[[Value]]` | `{{author\|wikilink}}` |
| `wikilink:"alias"` | `[[Value\|alias]]` | `{{name\|wikilink:"Display"}}` |
| `link` | `[Value](url)` | `{{url\|link}}` |
| `image:"alt"` | `![alt](url)` | `{{cover\|image:"Cover"}}` |
| `blockquote` | `> Value` | `{{text\|blockquote}}` |
| `list` | Bullet list | `{{items\|list}}` |
| `join:", "` | Join array with delimiter | `{{tags\|join:", "}}` |

## Array

| Filter | Effect |
|--------|--------|
| `first` | First element |
| `last` | Last element |
| `slice:start,count` | Sub-array, zero-indexed |
| `unique` | Deduplicate |

## Filter Gotchas

- **Quotes required:** `replace:"old":"new"` — unquoted `replace:old:new` fails silently.
- **No regex capture groups:** `replace` is literal text, no `$1`/`$2`. Chain multiple `replace` calls.
- **date pipe chaining:** `date` must be last if chained — `{{published|trim|date:"YYYY-MM-DD"}}`. `date_modify` works the same way.
