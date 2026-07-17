# DOX framework

- DOX is highly performant AGENTS.md hierarchy installed here
- Agent must follow DOX instructions across any edits

## Core Contract

- AGENTS.md files are binding work contracts for their subtrees
- Work products, source materials, instructions, records, assets, and durable docs must stay understandable from the nearest applicable AGENTS.md plus every parent AGENTS.md above it

## Read Before Editing

1. Read the root AGENTS.md
2. Identify every file or folder you expect to touch
3. Walk from the repository root to each target path
4. Read every AGENTS.md found along each route
5. If a parent AGENTS.md lists a child AGENTS.md whose scope contains the path, read that child and continue from there
6. Use the nearest AGENTS.md as the local contract and parent docs for repo-wide rules
7. If docs conflict, the closer doc controls local work details, but no child doc may weaken DOX

Do not rely on memory. Re-read the applicable DOX chain in the current session before editing.

## Update After Editing

Every meaningful change requires a DOX pass before the task is done.

Update the closest owning AGENTS.md when a change affects:

- purpose, scope, ownership, or responsibilities
- durable structure, contracts, workflows, or operating rules
- required inputs, outputs, permissions, constraints, side effects, or artifacts
- user preferences about behavior, communication, process, organization, or quality
- AGENTS.md creation, deletion, move, rename, or index contents

Update parent docs when parent-level structure, ownership, workflow, or child index changes. Update child docs when parent changes alter local rules. Remove stale or contradictory text immediately. Small edits that do not change behavior or contracts may leave docs unchanged, but the DOX pass still must happen.

## Hierarchy

- Root AGENTS.md is the DOX rail: project-wide instructions, global preferences, durable workflow rules, and the top-level Child DOX Index
- Child AGENTS.md files own domain-specific instructions and their own Child DOX Index
- Each parent explains what its direct children cover and what stays owned by the parent
- The closer a doc is to the work, the more specific and practical it must be

## Child Doc Shape

- Create a child AGENTS.md when a folder becomes a durable boundary with its own purpose, rules, responsibilities, workflow, materials, or quality standards
- Work Guidance must reflect the current standards of the project or user instructions; if there are no specific standards or instructions yet, leave it empty
- Verification must reflect an existing check; if no verification framework exists yet, leave it empty and update it when one exists

Default section order:
- Purpose
- Ownership
- Local Contracts
- Work Guidance
- Verification
- Child DOX Index

## Style

- Keep docs concise, current, and operational
- Document stable contracts, not diary entries
- Put broad rules in parent docs and concrete details in child docs
- Prefer direct bullets with explicit names
- Do not duplicate rules across many files unless each scope needs a local version
- Delete stale notes instead of explaining history
- Trim obvious statements, repeated rules, misplaced detail, and warnings for risks that no longer exist

## Closeout

1. Re-check changed paths against the DOX chain
2. Update nearest owning docs and any affected parents or children
3. Refresh every affected Child DOX Index
4. Remove stale or contradictory text
5. Run existing verification when relevant
6. Report any docs intentionally left unchanged and why

## Project

Andarwa Skills — Skill Factory. Build curated agent skill packages. Repo: `andarwaly/andarwaly-skills`. Distribute via skills.sh. Free.

### Directory Structure

```
skills/                 # skill buckets — see skills/AGENTS.md
.agents/                # ADRs and maintainer docs
discussion/             # Research and decision context, grouped by topic (gitignored)
.out-of-scope/          # Explicitly excluded scope decisions
docs/                   # Human-facing docs per promoted bucket
scripts/                # Development scripts
```

Skill format, bucket rules (promoted/non-promoted), writing workflow, docs, plugin manifests, and distribution are owned by `skills/AGENTS.md` — read it before touching anything under `skills/`.

### Research

Findings live in `discussion/`, grouped into topic subfolders. Capture to vault with `raw_clip`, then distill to Wiki on explicit instruction.

## User Preferences

- AI commits use `Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>` (set 2026-07-17; supersedes the prior `Aldric <noreply@andarwaly.dev>` convention).

## Child DOX Index

- `skills/AGENTS.md` — skill format, bucket rules, writing workflow, docs, plugin manifests, distribution (has its own Child DOX Index, incl. `skills/figma-agent/AGENTS.md`)
- `discussion/AGENTS.md` — research and decision-context capture, grouped by topic (gitignored, local-only)
- `docs/`, `scripts/`, `.agents/`, `.out-of-scope/` — no child AGENTS.md yet; governed directly by this root doc, no local rules beyond it
