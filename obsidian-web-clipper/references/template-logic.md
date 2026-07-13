
# Template Logic

## Conditionals

```
{% if author %}By {{author}}{% endif %}
{% if status == "published" %}Live{% else %}Draft{% endif %}
{% if highlights %} {{highlights}} {% else %} No highlights {% endif %}
```

### Comparison operators

| Operator | Description |
|----------|-------------|
| `==` | Equal to |
| `!=` | Not equal to |
| `>` | Greater than |
| `<` | Less than |
| `>=` | Greater than or equal to |
| `<=` | Less than or equal to |
| `contains` | String contains substring, or array contains value |

### Logical operators

| Operator | Alternative | Description |
|----------|-------------|-------------|
| `and` | `&&` | Both conditions true |
| `or` | `\|\|` | At least one condition true |
| `not` | `!` | Negates a condition |

### Truthiness

`false`, `null`, `undefined`, empty string `""`, `0`, and empty arrays `[]` are falsy. Everything else is truthy.

## Loops

```
{% for tag in tags %}[[{{tag}}]]{% if not loop.last %}, {% endif %}{% endfor %}
{% for author in schema:@Article:author %}{{author.name}}{% if not loop.last %}, {% endif %}{% endfor %}
```

### Loop sources

- Schema arrays: `{% for item in schema:author %}`
- Selector results: `{% for comment in selector:.comment %}`
- Variables set earlier: `{% set items = selector:.item %}{% for item in items %}`

### Loop variables

| Variable | Description |
|----------|-------------|
| `loop.index` | Current iteration (1-indexed) |
| `loop.index0` | Current iteration (0-indexed) |
| `loop.first` | `true` if first iteration |
| `loop.last` | `true` if last iteration |
| `loop.length` | Total number of items |

### Accessing array items by index

```
{{items[0]}}
{{items[loop.index0]}}
{{data["my-key"]}}
```

## Assign a variable

```
{% set slug = title|lower|replace:" ":"-" %}
{% set items = selector:.list-item %}
```

## Fallbacks

`??` cascades through alternatives, stopping at the first non-empty value:

```
{{title ?? "Untitled"}}
{{author ?? schema:author ?? "Unknown"}}
```

Filters bind tighter than `??`: `{{title|upper ?? "UNTITLED"}}` applies `upper` to title first, then falls back.

## Evaluation order

1. Template logic (`{% if %}`, `{% for %}`, `{% set %}`) and `{{variables}}` evaluated first
2. Prompt variables (`{{"summarize this"}}`) sent to Interpreter after
