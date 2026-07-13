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

Note: `replace` requires quoted arguments. Supports regex with `/pattern/flags` syntax: `{{text|replace:"/[aeiou]/g":"*"}}`. No capture groups — chain multiple `replace` calls instead.

| `camel` | camelCase |
| `pascal` | PascalCase |
| `uncamel` | camelCase/PascalCase to space-separated words |
| `capitalize` | Capitalize first character |
| `decode_uri` | Decode URI-encoded string |

## Numbers

| Filter | Effect | Example |
|--------|--------|---------|
| `calc:"+10"` | Arithmetic (`+`, `-`, `*`, `/`, `**`) | `{{words\|calc:"/238"\|round}}` |
| `length` | String/array/object length | `{{tags\|length}}` |
| `round` | Round to integer or N decimals | `{{number\|round:2}}` |

## Duration

Converts ISO 8601 (`PT1H30M`) or plain seconds to formatted time.

| Filter | Example | Output |
|--------|---------|--------|
| `duration` | (no args) | auto: `HH:mm:ss` over 1h, `mm:ss` under |
| `duration:"HH:mm:ss"` | `"PT1H30M"\|duration:"HH:mm:ss"` | `01:30:00` |
| `duration:"H:mm:ss"` | `"3665"\|duration:"H:mm:ss"` | `1:01:05` |

## Format

| Filter | Effect | Example |
|--------|--------|---------|
| `wikilink` | `[[Value]]` | `{{author\|wikilink}}` |
| `wikilink:"alias"` | `[[Value\|alias]]` | `{{name\|wikilink:"Display"}}` |
| `link` | `[Value](url)` | `{{url\|link}}` |
| `image:"alt"` | `![alt](url)` | `{{cover\|image:"Cover"}}` |
| `blockquote` | `> Value` | `{{text\|blockquote}}` |
| `callout` | Obsidian callout | `{{text\|callout:"warning"}}` |
| `list` | Bullet list | `{{items\|list}}` |
| `list:numbered` | Numbered list | `{{items\|list:numbered}}` |
| `list:task` | Task list | `{{items\|list:task}}` |
| `table` | Array of objects → markdown table | `{{items\|table}}` |
| `footnote` | Array/object → markdown footnotes | `{{items\|footnote}}` |

## HTML processing

| Filter | Effect |
|--------|--------|
| `markdown` | HTML string → Obsidian Flavored Markdown |
| `strip_tags` | Remove all HTML tags |
| `strip_attr` | Remove all HTML attributes |
| `remove_attr` | Remove specified attributes only |
| `remove_html` | Remove specified tags |
| `strip_md` | Remove markdown formatting |

## Array

| Filter | Effect |
|--------|--------|
| `first` | First element |
| `last` | Last element |
| `nth:N` | Nth element (0-indexed) |
| `slice:start,count` | Sub-array, zero-indexed |
| `unique` | Deduplicate |
| `join:", "` | Join array with delimiter |
| `split:" "` | Split string into array |
| `merge` | Merge arrays |
| `map:fn` | Transform each item |
| `template:"str"` | Template string from objects |
| `truncate:N` | Truncate to N characters |

## Filter Gotchas

- **`date` must be last** when chained: `{{published\|trim\|date:"YYYY-MM-DD"}}`
- **`replace` quoting:** unquoted `replace:old:new` fails silently. Use `replace:"old":"new"`.
- **Regex in `replace`:** use `/pattern/flags` syntax. No capture group references.
- **`date_modify` before `date`:** modify then format.
