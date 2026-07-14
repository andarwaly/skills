<div align="center">

# Andarwa Skills

*Curated [agent skill](https://agentskills.io) packages for AI coding assistants*

[![skills.sh](https://img.shields.io/badge/skills.sh-andarwaly%2Fskills-blue?style=flat-square)](https://skills.sh)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

[Installation](#installation) • [Updating](#updating) • [Skills](#skills) • [Usage](#usage) • [Writing skills](#writing-skills)

</div>

Free, well-crafted skill packages distributed through [skills.sh](https://skills.sh). Every skill here follows the [agentskills.io](https://agentskills.io) specification directly: minimal frontmatter, no Claude Code extensions, progressive disclosure into reference files instead of one giant instruction blob.

## Installation

```bash
npx skills add andarwaly/skills
```

This registers the collection with your skills.sh CLI. Skills auto-index from CLI telemetry, so nothing needs manual submission.

Once the collection has more than one skill, install just one by pointing at its subpath instead of the whole repo:

```bash
npx skills add https://github.com/andarwaly/skills/tree/main/<skill-name>
```

> [!TIP]
> Run `skills list` after adding the repo to see what's available.

## Updating

```bash
npx skills update
```

Pulls the latest version of every installed skill from this collection. To update just one:

```bash
npx skills update obsidian-web-clipper
```

Updates are pull-based, there's no background auto-update; run this whenever you want the current version.

## Skills

| Skill | Version | Description |
|---|---|---|
| [obsidian-web-clipper](./obsidian-web-clipper) | 1.0.0 | Build Web Clipper templates, inspect pages for variables, debug extraction failures |

More in progress, grouped by domain as they land: a POE2 build planner, a skill-factory router.

## Usage

Each skill is a directory with a `SKILL.md` at its root. When a request matches its trigger phrases, your agent loads the skill automatically, no manual invocation needed unless the skill says otherwise.

For example, once `obsidian-web-clipper` is installed, asking your agent to *"build a Web Clipper template for Substack"* is enough to run its full workflow: gathering context from your vault, wiring the template, and delivering an importable `.json`. See the [skill's own README](./obsidian-web-clipper) for details.

## Writing skills

Two phases, and the second one isn't optional.

1. **Write**: draft using the agentskills.io standard format. No Claude Code extensions. Pack the description with literal trigger phrases, not workflow summaries.
2. **Review**: audit against writing-great-skills criteria. Completion criteria must be checkable, leading words must pull their weight, no-ops get deleted.

See [AGENTS.md](./AGENTS.md) for the full factory workflow.
