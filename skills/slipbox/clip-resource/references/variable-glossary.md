# clip-resource variable glossary

Two variable forms, matching Obsidian Web Clipper's own convention (no new syntax invented).

## Fact variables — bare `{{variable}}`

Resolved via the extraction ladder (schema.org JSON-LD -> `<meta>` tags -> LLM-read fallback),
hidden behind the name. A template author writes `{{author}}` once; which rung of the ladder
actually supplied the value is the agent's concern, not the template's.

Common to all four types: `{{title}}`, `{{url}}`, `{{clipped_date}}`, `{{domain}}`, `{{content}}`
(body, per-type treatment).

- Article/News: `{{author}}`, `{{published}}`, `{{description}}` — News adds `{{publisher}}`.
- Social/Forum: `{{author}}` (display-name-first, handle fallback), `{{published}}`,
  `{{root_post}}`, `{{continuation}}` (the author's own thread replies).
- Video: `{{author}}` (channel), `{{published}}`, `{{transcript}}`, `{{video_id}}`.

## Synthesis instructions — quoted `{{"instruction"}}`

Freeform natural-language instruction, executed inline by the agent running this skill — no
separate Interpreter service, no toggle, no API key, since the skill itself is the LLM.

Example: `{{"rewrite the transcript, as an article"}}`.

## Not supported (yet)

- CSS-selector-style variables (`{{selector:...}}`) — no DOM access without a browser.
  Flagged as a future addition once a headless-browser capability exists in this environment.
- Template logic (`{% if %}`, `{% for %}`) — the agent has judgment already; a rules-engine
  layer here would be redundant.
