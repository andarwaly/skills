# skills/figma-agent/ — AGENTS.md

## Purpose

House Figma Agent Custom Skills — flat single-file `SKILL.md` documents pasted directly into Figma's built-in Custom Skills UI.

## Ownership

Andarwa Skills maintainer. Distinct from `skills/figma/`, which holds git-installable, plugin-oriented skills.

## Local Contracts

- Each skill is a single flat `skills/figma-agent/<skill-name>/SKILL.md` — no `references/`, `scripts/`, or `assets/`. Figma's Custom Skills format doesn't support them.
- Scope is Figma Agent's own native tool calls (`get_comments`, `evaluate_script`, Plugin API) only. A future variant driven by Composio or the Figma REST API needs its own bucket, not this one.
- Distribution is manual (paste into Figma's Custom Skills UI), not `npx skills add` — this bucket does not follow root AGENTS.md's Distribution section.
- Promoted-vs-non-promoted status is unresolved. Do not add this bucket to the root README, `docs/`, or `.claude-plugin/plugin.json` without a decision — see `discussion/user-flow-context/open-items.md` item 8.

## Work Guidance

(none beyond Local Contracts yet)

## Verification

(none yet)

## Child DOX Index

(none — leaf)
