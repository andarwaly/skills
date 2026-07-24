<div align="center">

# Andarwa Skills

*Curated [agent skill](https://agentskills.io) packages for AI coding assistants*

[![skills.sh](https://img.shields.io/badge/skills.sh-andarwaly%2Fskills-blue?style=flat-square)](https://skills.sh)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

[Installation](#installation) • [Updating](#updating) • [Skills](#skills) • [Usage](#usage) • [Writing skills](#writing-skills)

</div>

Free, well-crafted skill packages distributed through [skills.sh](https://skills.sh). Every skill here follows the [agentskills.io](https://agentskills.io) specification directly: minimal frontmatter, no Claude-Code-only body syntax (`$ARGUMENTS`, `context: fork`, `allowed-tools`), progressive disclosure into reference files instead of one giant instruction blob. Frontmatter extensions like `disable-model-invocation` are used where they fit — they degrade gracefully on any harness that doesn't read them.

## Installation

```bash
npx skills add andarwaly/skills
```

This registers the collection with your skills.sh CLI. Skills auto-index from CLI telemetry, so nothing needs manual submission.

Once the collection has more than one skill, install just one by pointing at its subpath instead of the whole repo:

```bash
npx skills add https://github.com/andarwaly/skills/tree/main/skills/<bucket>/<skill-name>
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

The install picker (`npx skills add`) shows every skill below under one flat "Andarwa Skills" group — the CLI has no supported way to split a single repo into multiple named groups. The two buckets below are a docs-only distinction.

### Obsidian

| Skill | Version | Description |
|---|---|---|
| [obsidian-web-clipper](./skills/obsidian/obsidian-web-clipper) | 1.0.0 | Build Web Clipper templates, inspect pages for variables, debug extraction failures |

### Slipbox

| Skill | Version | Description |
|---|---|---|
| [setup-slipbox](./skills/slipbox/setup-slipbox) | 1.0.0 | One-time onboarding — discovers vault conventions, writing style, and clip preferences; initializes idea.db |
| [clip-resource](./skills/slipbox/clip-resource) | 1.0.0 | Fetch a URL and write it as a frozen Resource, for users without a clipper tool |
| [surface-ideas](./skills/slipbox/surface-ideas) | 1.0.0 | Surface 5-10 discussion-worthy candidate ideas and recurring reference terms from a clipped Resource |
| [write-literature-note](./skills/slipbox/write-literature-note) | 1.0.0 | Socratic discussion from a candidate idea to a finished, Claim-only literature note |
| [write-reference-note](./skills/slipbox/write-reference-note) | 1.0.0 | Definitional note for a recurring term or source, grown over multiple resources |
| [write-evergreen-note](./skills/slipbox/write-evergreen-note) | 1.0.0 | Connect two or more existing notes into a new, purely original idea |

## Usage

Each skill is a directory with a `SKILL.md` at its root. When a request matches its trigger phrases, your agent loads the skill automatically, no manual invocation needed unless the skill says otherwise.

For example, once `obsidian-web-clipper` is installed, asking your agent to *"build a Web Clipper template for Substack"* is enough to run its full workflow: gathering context from your vault, wiring the template, and delivering an importable `.json`. See the [skill's own README](./skills/obsidian/obsidian-web-clipper) for details.

## Writing skills

Two phases, and the second one isn't optional.

1. **Write**: draft using the agentskills.io standard format. No Claude-Code-only body syntax. Pack the description with literal trigger phrases, not workflow summaries.
2. **Review**: audit against writing-great-skills criteria. Completion criteria must be checkable, leading words must pull their weight, no-ops get deleted.

See [AGENTS.md](./AGENTS.md) for the full factory workflow.
