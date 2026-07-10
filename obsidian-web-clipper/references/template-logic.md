# Template Logic

## Conditionals

```
{% if author %}By {{author}}{% endif %}
{% if status == "published" %}Live{% else %}Draft{% endif %}
{% if highlights %} {{highlights}} {% else %} No highlights {% endif %}
```

Uses `==` for string equality, `!=` for inequality. No `and`/`or` — nest conditionals instead.

## Loops

```
{% for tag in tags %}[[{{tag}}]]{% if not loop.last %}, {% endif %}{% endfor %}
{% for author in schema:@Article:author %}{{author.name}}{% if not loop.last %}, {% endif %}{% endfor %}
```

`loop` object fields:
- `loop.first` — true on first iteration
- `loop.last` — true on last iteration
- `loop.index` — 1-indexed position

## Fallbacks

`??` cascades through alternatives, stopping at the first non-empty value:

```
{{title ?? "Untitled"}}
{{author ?? schema:author ?? "Unknown"}}
{{meta:property:og:image ?? schema:image ?? image}}
```

Chain from strongest to weakest — schema → meta → selector → prompt → literal.
