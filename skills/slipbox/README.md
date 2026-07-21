# slipbox

Skills for a Zettelkasten-inspired, conversational note-taking pipeline: clip a source, surface discussable ideas from it, discuss one into a literature note, optionally spin off a reference note, optionally connect notes into an evergreen note.

## Skills

All six are user-invoked — none fire automatically, run them by name.

- **[setup-vault](./setup-vault/)** — one-time onboarding: discovers vault conventions and writing style.
- **[clip-resource](./clip-resource/)** — fetches a URL and writes it as a frozen Resource, for users without a clipper tool.
- **[surface-ideas](./surface-ideas/)** — surfaces discussion-worthy candidates from a clipped Resource.
- **[discuss-idea](./discuss-idea/)** — Socratic conversation from a candidate to a finished literature note.
- **[write-reference-note](./write-reference-note/)** — manually-triggered definitional note for a recurring term or source.
- **[discuss-connection](./discuss-connection/)** — connects existing notes into a new, purely-original idea.
