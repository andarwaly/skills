# Interpreter Context (per-template)

The `context` field in a template JSON overrides the **Default interpreter context** (Advanced Settings) for that specific template. It controls what page data the LLM sees when processing prompt variables like `{{"summarize this"}}`.

## Empty string behavior

```json
"context": ""
```

Empty = fall through to the global default. If the global default is also empty, the full page HTML is used.

## Variable patterns

Set `context` to a variable expression that returns the page subset you want the LLM to process.

| Pattern | What the LLM receives | Best for |
|---|---|---|
| `{{content}}` | Extracted readable content (no nav/ads) | General purpose, most pages |
| `{{selectorHtml:article\|markdown\|trim}}` | First `<article>` element, as markdown | Blog posts, news articles |
| `{{selectorHtml:main\|markdown\|slice:0,5000\|trim}}` | `<main>` element, capped at ~5000 chars | Long pages with a main content region |
| `{{selector:.post-content\|strip_tags\|trim}}` | Text content of `.post-content` | Forums, comment sections |
| `{{content\|slice:0,2000}}` | First 2000 chars of extracted content | Very long pages, token-constrained models |
| `{{selectorHtml:.product-info\|strip_attr\|trim}}` | `.product-info` HTML, attributes stripped | Product/ecommerce pages |
| `""` (empty) | Global default, or full page HTML | When the default is good enough |

## Filters that pair well

Filters in `context` are applied **before** the LLM call, unlike filters on prompt variables which run after.

| Filter | Effect |
|---|---|
| `markdown` | HTML to Markdown conversion |
| `strip_tags` | Remove all HTML tags, keep text |
| `strip_attr` | Remove HTML attributes, keep structure |
| `remove_html` | Remove specific elements |
| `slice:0,N` | Truncate to N characters (token ceiling safety) |
| `trim` | Strip leading/trailing whitespace |

Chain them: `{{selectorHtml:article|markdown|slice:0,3000|trim}}`

## Page-type guidance

| Page type | Recommended context | Rationale |
|---|---|---|
| Blog post / news | `{{selectorHtml:article\|markdown\|trim}}` | Articles usually have a semantic `<article>` tag. Markdown reduces token count vs HTML. |
| Documentation | `{{selectorHtml:main,\ article,\ .content\|markdown\|slice:0,5000\|trim}}` | Doc sites use different container selectors. Fallback chain ensures a match. |
| Product / ecommerce | `{{selectorHtml:.product-info,\ .product,\ main\|strip_attr\|trim}}` | Needs structured data but not full-page boilerplate. |
| Forum / comments | `{{selector:.post-body,\ .comment-text\|strip_tags\|trim}}` | Text-heavy, low structure value. |
| Long-form (10k+ words) | `{{content\|slice:0,3000}}` or `{{selectorHtml:article\|slice:0,4000}}` | Hard token ceiling with some models (e.g. Ollama default 2048). Cap aggressively. |

## Tradeoffs

- **Too narrow** — LLM misses context needed to answer the prompt accurately.
- **Too broad** — slower, more tokens burned, cheaper models may lose signal in noise.
- **Wrong selector** — returns empty, LLM gets nothing. Always test selectors against the live page (see [page-inspection.md](page-inspection.md)).
- **HTML vs markdown** — HTML preserves structure but costs more tokens. `markdown` filter reduces token count at the cost of some structural fidelity. Prefer markdown for summarization prompts, HTML for extraction prompts that need table/list structure.

## Relationship to prompt variables

The `context` field and prompt variables (`{{"your prompt"}}`) are independent settings that compose:

- `context` = what the LLM sees
- `{{"prompt"}}` = what you ask it to produce from what it sees

Both must be set for interpreter to produce useful output. A narrow `context` with a broad prompt, or a broad `context` with a narrow prompt, both degrade results.
