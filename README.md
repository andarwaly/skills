<div align="center">

# Andarwa Skills

Curated [agent skill](https://agentskills.io) packages for AI coding assistants.

[![skills.sh](https://img.shields.io/badge/skills.sh-andarwaly%2Fskills-blue?style=flat-square)](https://skills.sh)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

</div>

A collection of well-crafted, stateless and stateful skill packages distributed free through [skills.sh](https://skills.sh). Each skill follows the [agentskills.io](https://agentskills.io) specification — minimal frontmatter, no Claude Code extensions, progressive disclosure.

## Skills

| Skill | Description | Type |
|---|---|---|
| [obsidian-web-clipper](./obsidian-web-clipper) | Build Web Clipper templates, inspect pages for variables, debug extraction failures | Stateless |

More coming: POE2 Build Planner, Skill Factory Router.

## Installation

```bash
npx skills add andarwaly/skills
```

This registers the `andarwaly/skills` repository with your skills.sh CLI. Skills auto-index from CLI telemetry — no manual submission needed.

> [!TIP]
> Run `skills list` to see all available skills after adding the repo.

## Usage

Each skill is a directory with a `SKILL.md` at its root. When your coding assistant encounters a trigger phrase matching a skill's description, it loads the skill's instructions automatically.

To use the `obsidian-web-clipper` skill:

1. Ask your agent to create an Obsidian Web Clipper template for a website
2. The agent follows the skill's three-phase workflow: template creation, page inspection, troubleshooting
3. You get a `.json` template file ready to import into Obsidian Web Clipper

## Project structure

```
skills/          # Skill packages, one folder per skill with SKILL.md
research/        # Market research, top-10 analysis, competitor notes
```

Skills in `skills/` are for distribution only — never installed locally. They live here and ship via skills.sh.

## Writing skills

Two phases: write, then review. Never skip the review pass.

1. **Write** — Draft using the agentskills.io standard format. No Claude Code extensions. Pack the description with literal trigger phrases.
2. **Review** — Audit through two lenses: stateless vs stateful design, and writing-great-skills criteria. Completion criteria must be checkable. Leading words must pull their weight. No-ops must be deleted.

See [AGENTS.md](./AGENTS.md) for the full factory workflow.

## Design philosophy

The first question for every skill: **stateless or stateful?**

- **Stateless** — pure input to output. No filesystem writes. Example: a skill that generates a one-time JSON template.
- **Stateful** — saves to the filesystem, tracks progress across sessions, gets better over time. Example: a build planner that creates workspace files.

Neither is better. Pick based on use case.

## License

MIT
