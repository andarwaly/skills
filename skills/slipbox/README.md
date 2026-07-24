# slipbox

Skills for a Zettelkasten-inspired, conversational note-taking pipeline: clip a source, surface discussable ideas from it, discuss one into a literature note, optionally spin off a reference note, optionally connect notes into an evergreen note.

## Skills

Six are user-invoked; `discussion` is internal (invoked only by the three `write-*-note` skills, never directly).

- **[setup-slipbox](./setup-slipbox/)** — one-time onboarding: discovers vault conventions, writing style, clip preferences; initializes `idea.db`.
- **[clip-resource](./clip-resource/)** — fetches a URL and writes it as a frozen Resource, for users without a clipper tool.
- **[surface-ideas](./surface-ideas/)** — surfaces discussion-worthy candidates and recurring reference terms from a clipped Resource.
- **[write-literature-note](./write-literature-note/)** — Socratic discussion from a candidate idea to a finished, Claim-only literature note.
- **[write-reference-note](./write-reference-note/)** — definitional note for a recurring term or source, grown over multiple resources.
- **[write-evergreen-note](./write-evergreen-note/)** — connects existing notes into a new, purely-original idea.
- **[discussion](./discussion/)** *(internal)* — the shared Socratic conversation engine the three `write-*-note` skills each invoke with their own framing.
