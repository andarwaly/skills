# Figma Agent

Custom Skills for Figma's built-in AI agent (Figma AI / Figma Agent), uploaded through the Figma Custom Skills UI as flat single-file `.md` documents (no `references/`, `scripts/`, or `assets/` — Figma's format doesn't support them).

Each skill here is a single flat `skills/figma-agent/<skill-name>/SKILL.md` — no `references/`, no progressive disclosure. This matches Figma's Custom Skills format exactly, so the file is pasted into the Figma UI as-is. (Progressive disclosure with bundled reference files belongs in `skills/figma/`, for the plugin-oriented, git-installable skills.)

**Scope:** built for Figma Agent's own native tool calls (`get_comments`, `evaluate_script`, Plugin API). A future variant driven by Composio or the Figma REST API — different auth, different node-access model — would need its own bucket, not this one.

## Skills

- [rename-design-frame](rename-design-frame/SKILL.md) — rename frames, sections, and subsections to follow the full-ancestor-chain naming convention.
- [organize-design-file](organize-design-file/SKILL.md) — lay out a Section's Core Flow / Edge Case / Error Case bands, apply band colors and typography, position and space frames.
- [wire-user-flow-connectors](wire-user-flow-connectors/SKILL.md) — clone and position connector arrows between frames per contextual-origin rules.
