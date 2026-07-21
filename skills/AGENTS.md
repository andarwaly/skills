# skills/ — AGENTS.md

## Purpose

Distribution home for every agent skill built by Andarwa Skills. Each subfolder is a bucket; each bucket subfolder is one skill.

## Ownership

Andarwa Skills maintainer. Skills here are for distribution only — never install them into local pi or global agent directories. They stay in this repo; consumers pull them with `npx skills add`.

## Local Contracts

- **Skill format**: follow the [agentskills.io](https://agentskills.io) spec. A skill is a directory with `SKILL.md`:

  ```yaml
  ---
  name: skill-name
  description: What it does and when to use it. Pack with trigger phrases.
  ---
  ```

  Optional: `license`, `metadata` (author, version). Optional dirs: `scripts/`, `references/`, `assets/`. Standard format only — skip Claude Code **body syntax** (`$ARGUMENTS`, `context: fork`, `allowed-tools`) unless shipping CC-only; those fail outright on other harnesses. Frontmatter extensions (e.g. `disable-model-invocation`) are fine even on non-CC-only skills — an unrecognized frontmatter key degrades gracefully everywhere and can hand richer context to any harness that does read it. The top 10 skills on skills.sh use zero body-syntax extensions.

- **Buckets**: `obsidian/`, `figma/`, `productivity/`, `slipbox/` are promoted (appear in the top-level README, `docs/`, and `.claude-plugin/plugin.json`). `misc/` is non-promoted. `figma-agent/` status is undecided — see its own `AGENTS.md`.

- **Bucket READMEs**: every bucket needs a README.md listing its skills with one-line descriptions linked to their SKILL.md. Promoted buckets format theirs using the User-invoked / Model-invoked grouping from the skill's own frontmatter convention.

- **Docs**: promoted bucket skills get a human-facing docs page at `docs/<bucket>/<skill-name>.md`.

- **Plugin manifests**: `.claude-plugin/plugin.json` lists every promoted skill by relative path. `version` must match `package.json`. `marketplace.json` publishes the collection.

- **Distribution**: publish to a public GitHub repo. Users install with `npx skills add owner/repo`. Skills.sh auto-indexes from CLI telemetry — no manual submission. Install count determines leaderboard rank.

## Work Guidance

Two phases per skill: write, then review. Do not skip the review pass.

**Write**: load `humanizer` and `write-a-skill`. Pull format findings from vault memory (top-10 patterns, skillsdirectory.com guidelines, description keyword density research). Draft the skill: structure from write-a-skill, prose filtered through humanizer, decisions grounded in the research.

**Review**: audit the draft through two lenses:
- **Matt Pocock's framework** — is this skill stateless or stateful? Did we make the right call? If stateful, does the workspace structure (lessons, records, glossary) hold up across sessions?
- **writing-great-skills** — run the full audit. Completion criteria checkable? Any premature completion risk? Leading words pulling their weight? No-ops deleted? Information hierarchy right (what's inline vs disclosed)?

**Skill design**: first question for every skill is stateless or stateful. Stateless: pure input to output, no filesystem writes. Stateful: saves to the filesystem, tracks progress across sessions, gets better over time. Neither is better — pick based on use case.

## Verification

Every skill should carry `evals/evals.json` — test cases with `prompt`, `expected_output`, optional `files`, and `assertions` (objective, checkable claims only; reserve subjective quality — writing style, "feels right" — for human review instead of an assertion).

- **Design**: start with 2-3 varied prompts (casual and precise phrasing), including at least one edge case. Add assertions after seeing a first run's output, not before.
- **Run**: execute each test case twice, with the skill and without (or against the previous version), in a clean context each time — no leftover state from skill development.
- **Grade**: PASS/FAIL per assertion with evidence (quote or reference the output). LLM judge for fuzzy assertions, a verification script for mechanical ones (valid JSON, file exists, row count).
- **Aggregate**: track the with/without delta — pass rate, time, tokens. A skill that costs more but meaningfully raises pass rate is worth it; one that doubles cost for a marginal gain isn't.
- **Iterate**: feed failed assertions, human feedback, and execution transcripts back into a `SKILL.md` revision. Generalize fixes rather than patching to the specific test case; prune instructions that don't move pass rate rather than stacking more rules.

Source: [agentskills.io/skill-creation/evaluating-skills](https://agentskills.io/skill-creation/evaluating-skills).

## Child DOX Index

- `figma-agent/AGENTS.md` — distinct distribution mechanism (Figma Custom Skills UI, not `npx skills add`) and unresolved promotion status
- `obsidian/`, `figma/`, `productivity/`, `misc/`, `slipbox/` — no child AGENTS.md yet; governed directly by this doc, no local rules beyond it
