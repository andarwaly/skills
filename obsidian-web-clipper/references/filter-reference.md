# Filter Reference

Syntax: `{{variable|filter}}`. Chainable, applied left to right.

## Dates

| Filter | Example | Output |
|--------|---------|--------|
| `date:"fmt"` | `{{published\|date:"YYYY-MM-DD"}}` | `2026-06-23` |
| `date_modify:"+N unit"` | `{{date\|date_modify:"+1 day"}}` | Tomorrow |
| `duration:"fmt"` | `"PT1H30M"\|duration:"HH:mm:ss"` | `01:30:00` |

Format tokens: `YYYY`, `MM`, `DD`, `HH`, `mm`, `ss`. Duration tokens: `HH`, `H`, `mm`, `m`, `ss`, `s`. ISO 8601 or seconds input. `date` must be last when chained. `date_modify` before `date`.

## Text transforms

`lower` · `upper` · `title` · `capitalize` · `camel` · `pascal` · `snake` · `kebab` · `uncamel` (camelCase to words) · `trim` · `safe_name` (filesystem-safe) · `decode_uri` · `replace:"old":"new"` (supports `/pattern/flags` regex, no capture groups)

## Formatting

`wikilink:"alias"` → `[[Value\|alias]]` · `link:"text"` → `[text](url)` · `image:"alt"` → `![alt](url)` · `blockquote` → `> ` prefix · `callout:("type","title",fold)` · `list` / `list:numbered` / `list:task` · `table` (arrays/objects to markdown table) · `footnote` (arrays/objects to footnotes) · `fragment_link:"title"` (text fragment links)

## Numbers

`calc:"+10"` (supports `+`, `-`, `*`, `/`, `**`) · `length` (string, array, or object length) · `round:N` (decimals)

## HTML processing

`markdown` (HTML → Obsidian Markdown) · `strip_tags` · `strip_attr` · `remove_attr` · `remove_html:(".class")` · `strip_md` (remove markdown)

## Arrays

`first` · `last` · `nth:N` · `slice:start,count` · `unique` · `join:", "` · `split:" "` (string → array) · `merge` · `map:fn` (`item => ({text: item})`) · `template:"str"` (`"${text}"`) · `truncate:N`

## Gotchas

- **`date` must be last** when chained: `{{published\|trim\|date:"YYYY-MM-DD"}}`
- **`replace` quoting**: unquoted `replace:old:new` fails silently. Regex: `/pattern/flags`
- **No capture groups** in `replace`: chain multiple calls instead
- **`callout`** parameters: type (default `info`), title (default empty), fold (boolean or null)
- **`duration` auto-format**: `HH:mm:ss` over 1 hour, `mm:ss` under
- **`list:numbered-task`**: task list with numbers
- **`table` custom headers**: `table:("Col1","Col2")`

Full reference: [obsidianmd/obsidian-clipper/tree/main/docs](https://github.com/obsidianmd/obsidian-clipper/tree/main/docs)
