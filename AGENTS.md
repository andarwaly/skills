# Skill Factory

Build curated agent skill packages. Repo: `andarwaly/andarwaly-skills`. Distribute via skills.sh. Free.

## Project Structure

```
skills/          # Skill packages, one folder per skill with SKILL.md
research/        # Market research, top-10 analysis, competitor notes
```

Skills in `skills/` are for distribution only. Never install them into local pi or global agent directories. They stay here.

## Skill Format

Follow the [agentskills.io](https://agentskills.io) spec. A skill is a directory with `SKILL.md`:

```yaml
---
name: skill-name
description: What it does and when to use it. Pack with trigger phrases.
---
```

Optional: `license`, `metadata` (author, version). Optional dirs: `scripts/`, `references/`, `assets/`.

Use standard format only: name plus description. Skip Claude Code extensions (`$ARGUMENTS`, `context: fork`, `allowed-tools`) unless you are shipping CC-only. The top 10 skills on skills.sh use zero extensions.

## Writing Skills

Two phases: write, then review. Do not skip the review pass.

### Write
Load `humanizer` and `write-a-skill`. Pull format findings from vault memory (top-10 patterns, skillsdirectory.com guidelines, description keyword density research). Draft the skill: structure from write-a-skill, prose filtered through humanizer, decisions grounded in the research.

### Review
Audit the draft through two lenses:
- **Matt Pocock's framework** — is this skill stateless or stateful? Did we make the right call? If stateful, does the workspace structure (lessons, records, glossary) hold up across sessions?
- **writing-great-skills** — run the full audit. Completion criteria checkable? Any premature completion risk? Leading words pulling their weight? No-ops deleted? Information hierarchy right (what's inline vs disclosed)?

## Skill Design

First question for every skill: stateless or stateful?

Stateless skills are pure input to output. No filesystem writes. Example: `grill me` grills you about a topic and stops. Stateful skills save to the filesystem, track progress across sessions, and get better over time. Example: `teach` creates a workspace with lesson files, learning records, and a glossary.

Neither is better. Pick based on use case.

## Distribution

Publish to a public GitHub repo. Users install with `npx skills add owner/repo`. Skills.sh auto-indexes from CLI telemetry. No manual submission. Install count determines leaderboard rank.

## Research

Findings live in `research/`. Capture to vault with `raw_clip`, then distill to Wiki on explicit instruction.

## Commit Attribution

AI commits include:
```
Co-Authored-By: Aldric <noreply@andarwaly.dev>
```

## Memory

Project hub: `Memory/2026-06-23-skill-factory-project-hub.md`. Update as scope grows.
