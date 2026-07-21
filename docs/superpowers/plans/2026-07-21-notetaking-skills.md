# Note-Taking Skill Family Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a six-skill, conversational, stateful PKM pipeline — clip → surface candidates → discuss into a literature note → optionally spin off a reference note → optionally connect into an evergreen note — implementing the Zettelkasten-inspired design worked out across this session's discussion.

**Architecture:** One skill bucket (`skills/notetaking/`, provisional name pending promotion decision) containing six skills that share a common runtime state namespace (`.agents/slipbox/`, created inside whichever vault a user installs the bucket into) and a vault-conventions config produced once by `setup-vault`. Skills are decoupled by that shared state, not by direct invocation of one another — `extract-idea` and `write-literature-note` can run in separate sessions because the candidate CSV persists between them.

**Tech Stack:** Markdown `SKILL.md` per the `agentskills.io` spec (this repo's standard — see `skills/AGENTS.md`), `disable-model-invocation` frontmatter extension (permitted: degrades gracefully on non-CC agents, unlike body-level `$ARGUMENTS`/`context: fork`/`allowed-tools` syntax, which is out of scope entirely), CSV for candidate state, Bash `grep`/`awk`/`sort` for querying — no database, no separate index file.

## Global Constraints

- Bucket: `skills/notetaking/` — provisional name, not yet confirmed for promotion status (`obsidian/`, `figma/`, `productivity/` are promoted; `misc/` is not).
- Skill names are provisional working names per this session's decision: `setup-vault`, `clip-resource`, `extract-idea`, `write-literature-note`, `write-reference-note`, `write-evergreen-note`.
- Standard `agentskills.io` frontmatter only (`name`, `description`); `disable-model-invocation: true` is the one permitted CC extension, used on all six skills (manual-trigger only, per this session's invocation-mode decision — every skill in this family fires by name, never autonomously).
- Runtime storage namespace inside a user's vault: `.agents/slipbox/`.
- Candidate log: **one CSV per Resource**, no shared index file. Path: `.agents/slipbox/candidates/<resource-slug>.csv`. Columns: `slug,status,timestamp,reason,literature_note`. All queries (single-resource, cross-resource backlog, time-sorted) run via `grep`/`grep -r`/`sort` against these files — never a merged index.
- Resource files are **frozen** the moment they're captured. No skill in this family ever edits a Resource file again — including `clip-resource` itself, once it has written one.
- Every phase-completion gate (Claim fixed, Take fixed, evergreen connection confirmed) requires **explicit user confirmation** — never inferred from conversational tone. This mirrors `productivity/grilling`'s own rule from the `mattpocock/skills` repo: *"Do not act on it until I confirm we have reached a shared understanding."*
- Reference-note creation is **manual-trigger only** — no automatic recurrence or duplicate-idea detection across sources. Deferred as future escalation, not designed around now.
- Literature-note filenames are derived from the **finished Claim text** (claim-style, not topic-style — e.g. `Passive Highlighting Creates the Illusion of Learning.md`, not `Illusion of Competence.md`), formatted per whatever casing convention `setup-vault` records. No author-name prefix. On filename collision: fail and ask the user rather than auto-disambiguating — an exact collision may itself be a meaning-collision worth surfacing.
- Dismissed candidates (surfaced but judged not worth pursuing) get their `status` recorded in the CSV; no `reason` text is written for them.
- Any generated prose passes a **humanizing hybrid**: check for `/humanizer` or `anthropic-skills:humanizer` in the environment; invoke it if present. If absent, fall back to a small built-in checklist tailored to short-form Claim/Take prose, derived independently from the same public "signs of AI writing" material humanizer itself cites — never a fork of humanizer's own file.
- Every skill in this family is **stateful** (writes to the filesystem, tracks progress across sessions) per the Matt Pocock stateless/stateful framework referenced in `skills/AGENTS.md`.
- **Write phase** (per skill): load the `humanizer` and `write-a-skill` skills; draft the skill's structure from `write-a-skill`'s guidance; filter all prose through `humanizer`.
- **Review phase** (per skill): audit through two lenses — (a) confirm the stateless/stateful call was made correctly and the state layer (here, `.agents/slipbox/`) holds up across sessions; (b) run the full `writing-great-skills` audit — completion criteria checkable and (where relevant) exhaustive, premature-completion risk assessed, leading words pulling their weight, no-ops removed, information hierarchy correct (inline vs. disclosed to a reference file).

---

### Task 0: Bucket scaffolding

**Files:**
- Create: `skills/notetaking/README.md`
- Create: `skills/notetaking/` (directory, holds the six skill subdirectories built in Tasks 1–6)

**Interfaces:**
- Produces: the bucket directory every later task writes its skill folder into.

- [ ] **Step 1: Create the bucket directory and a placeholder README**

```markdown
# notetaking

Skills for a Zettelkasten-inspired, conversational note-taking pipeline: clip a source, surface discussable ideas from it, discuss one into a literature note, optionally spin off a reference note, optionally connect notes into an evergreen note.

## Skills

- **setup-vault** (user-invoked) — one-time onboarding: discovers vault conventions and writing style.
- **clip-resource** (user-invoked) — fetches a URL and writes it as a frozen Resource, for users without a clipper tool.
- **extract-idea** (user-invoked) — surfaces discussion-worthy candidates from a clipped Resource.
- **write-literature-note** (user-invoked) — Socratic conversation from a candidate to a finished literature note.
- **write-reference-note** (user-invoked) — manually-triggered definitional note for a recurring term or source.
- **write-evergreen-note** (user-invoked) — connects existing notes into a new, purely-original idea.
```

(This README will be revised once each skill's actual frontmatter `description` exists — descriptions below are placeholders for the index only, not final copy.)

- [ ] **Step 2: Commit**

```bash
git add "skills/notetaking/README.md"
git commit -m "scaffold: add notetaking skill bucket"
```

---

### Task 1: `setup-vault`

**Files:**
- Create: `skills/notetaking/setup-vault/SKILL.md`

**Interfaces:**
- Produces: `.agents/slipbox/vault-conventions.md` (written into whichever vault the skill runs in, not into this repo) — every later skill in this family reads this file before writing anything. Its shape:
  - filename casing convention for literature/reference/evergreen notes
  - frontmatter fields in use (if any)
  - writing-style guidance: either a recorded stated preference (greenfield) or a pointer to an existing note corpus to sample from at runtime

**Write phase:**

- [ ] **Step 1: Load `humanizer` and `write-a-skill`, draft the skill body**

The skill's `SKILL.md` frontmatter:

```yaml
---
name: setup-vault
description: One-time onboarding for the notetaking skill family — discovers vault conventions (filenames, frontmatter, templates) and writing style before any other skill in this family runs. Run once per vault; re-run only to change conventions or style.
disable-model-invocation: true
---
```

Body must cover, as a sequence of steps (mirroring `setup-matt-pocock-skills`' own shape — explore, present, confirm, write):

1. **Explore** — check for `.obsidian/` (a `templates/` folder, Templater plugin config), root `AGENTS.md`/`CLAUDE.md` for already-stated conventions, and any existing literature/evergreen notes to use as a style corpus.
2. **Section A — Vault conventions.** Present findings, recommend a default when nothing exists, confirm with the user one section at a time (same "lead with the recommended answer" pattern as `setup-matt-pocock-skills`).
3. **Section B — Writing style.** If no note corpus exists yet (greenfield): interview the user directly ("any particular voice or tone — first person, terse, exploratory?") and record the stated answer as the generic default. If a corpus already exists: record its path/location for later skills to sample from at runtime instead of relying on the stated preference.
4. **Write** — produce `.agents/slipbox/vault-conventions.md` with both sections' results. Show the user a draft before writing; let them edit.
5. **Done** — tell the user setup is complete and which skills now depend on this file. Mention re-running is only needed to change conventions or restart.

Every generated section of prose in this skill's own conversational output (not the config file's factual content) passes through `humanizer` per the Global Constraints hybrid rule.

- [ ] **Step 2: Commit**

```bash
git add "skills/notetaking/setup-vault/SKILL.md"
git commit -m "feat: add setup-vault skill"
```

**Review phase:**

- [ ] **Step 3: Stateless/stateful check** — confirm this skill is correctly stateful (it writes `.agents/slipbox/vault-conventions.md`, read by every other skill in this family) and that a single config file is the right amount of state for what it needs to persist (no over-engineering into a database or multi-file scheme this session already ruled against for the candidate log).

- [ ] **Step 4: `writing-great-skills` audit** — check:
  - Completion criterion for "Section A confirmed" / "Section B confirmed" is checkable (explicit user confirmation, not "user seems satisfied").
  - No premature completion risk: the write step doesn't fire until both sections are confirmed.
  - Any leading words in use (e.g. "explore," "confirm," "recommend") are doing real work, not filler.
  - No-ops removed: nothing instructing the agent to do what it would already do by default.
  - Information hierarchy: exploration checklist and confirm-pattern can stay inline (every run needs them); anything genuinely reference-only (e.g. a long list of possible frontmatter field names) should be disclosed to a sibling file rather than inlined.

- [ ] **Step 5: Fix any issues found, commit if changed**

```bash
git add "skills/notetaking/setup-vault/SKILL.md"
git commit -m "refine: setup-vault review fixes"
```

---

### Task 2: `clip-resource`

**Files:**
- Create: `skills/notetaking/clip-resource/SKILL.md`

**Interfaces:**
- Consumes: `.agents/slipbox/vault-conventions.md` (from Task 1) for filename/frontmatter conventions.
- Produces: a Resource file in the vault — frozen the moment it's written, per the Global Constraints. `extract-idea` (Task 3) reads Resource files as its input; this skill never reads `.agents/slipbox/candidates/` and never participates in the candidate pipeline itself.

This is the skill that covers the no-clipper-tool case, mirroring what Obsidian Web Clipper does for users who don't have it installed.

**Write phase:**

- [ ] **Step 1: Load `humanizer` and `write-a-skill`, draft the skill body**

Frontmatter:

```yaml
---
name: clip-resource
description: Fetch a URL and write it as a frozen Resource, matching Obsidian Web Clipper's output shape — for users without a clipper tool. Fetchable content only; paywalled or login-gated pages are not handled by this skill.
disable-model-invocation: true
---
```

Body must specify:

1. **Input**: a URL (article or video link). No pasted-text or manual-paste fallback in this version — fetch-only, per this session's deferred-tech-debt decision on paywall/login-gated content.
2. **Fetch**: retrieve the page or video content directly.
3. **Transform**: produce a Resource file shaped like Web Clipper's own output, verbatim from the example examined this session — frontmatter (`type`, `link`, `author`, `published`, `tags`), a cleaned body (article rewrite, or a structured summary for video), entity-extraction sections (People/Tools/Resources/Definition) where applicable, and a full transcript for video content. **Explicitly excludes** any "Bud candidate" or "Further exploration" section — surfacing candidate ideas is `extract-idea`'s job (Task 3), never this skill's. Writing that content here would be the same failure mode `extract-idea`'s own design guards against: presenting conclusions before the Socratic stage has run.
4. **Write**: save the Resource file per `setup-vault`'s recorded conventions. Once written, it is frozen — this skill does not revisit or edit it, and neither does any other skill in this family.
5. **Failure mode, explicit and reported, not silently degraded**: if the fetch fails outright, or succeeds but returns only a paywall teaser or login wall, this skill does not attempt an extraction workaround — it reports the failure to the user plainly (what was fetched, why it looks incomplete) rather than writing a partial or garbled Resource file that would later confuse `extract-idea`.

- [ ] **Step 2: Commit**

```bash
git add "skills/notetaking/clip-resource/SKILL.md"
git commit -m "feat: add clip-resource skill"
```

**Review phase:**

- [ ] **Step 3: Stateless/stateful check** — confirm this skill is correctly stateful (writes a persistent Resource file to the vault) while correctly staying *outside* the `.agents/slipbox/` state layer — it produces vault content, not candidate-pipeline bookkeeping, and that boundary should be explicit in the skill body, not implicit.

- [ ] **Step 4: `writing-great-skills` audit** — check:
  - Completion criterion is checkable: either a correctly-shaped Resource file exists, or an explicit fetch-failure report was given — both are valid, non-silent outcomes (same "null result is valid" posture as `extract-idea`'s zero-candidates case).
  - No premature completion: the skill never fabricates or pads content when a fetch returns incomplete data (a paywall teaser) — confirm the wording makes this a hard stop, not a soft preference.
  - The "fetchable content only" limitation is stated as a positive instruction (report the failure plainly) rather than a bare negation ("don't try to extract paywalled content") — per the same framework guidance already applied in `write-reference-note`.
  - No duplication with `extract-idea`'s surfacing behavior — confirm this skill's body never drifts into producing candidate ideas or conclusions about the content.

- [ ] **Step 5: Fix any issues found, commit if changed**

```bash
git add "skills/notetaking/clip-resource/SKILL.md"
git commit -m "refine: clip-resource review fixes"
```

---

### Task 3: `extract-idea`

**Files:**
- Create: `skills/notetaking/extract-idea/SKILL.md`
- Create: `skills/notetaking/extract-idea/references/candidate-schema.md`

**Interfaces:**
- Consumes: `.agents/slipbox/vault-conventions.md` (from Task 1) — for any output-shape conventions relevant to how candidates get described. Consumes a Resource file, whether produced by `clip-resource` (Task 2) or an existing clipper tool (Web Clipper, Readwise) outside this skill family.
- Produces: `.agents/slipbox/candidates/<resource-slug>.csv`, columns `slug,status,timestamp,reason,literature_note`. `write-literature-note` (Task 4, run independently, possibly a different session) reads this file and filters `status = pending`.

**Note on schema sharing:** `npx skills add` installs at individual-skill granularity (confirmed against the `skills.sh` CLI and `vercel-labs/skills` docs — `-s/--skill` selects specific skills by name; there is no bucket-level install unit). A shared reference file living outside any skill's own folder (e.g. at `skills/notetaking/`) would not travel with an install of just one skill. The CSV schema is therefore **duplicated** into each consuming skill's own `references/` folder rather than disclosed to a shared bucket-level file — a deliberate exception to single-source-of-truth, justified because the schema is small (5 columns) and stable, and the cost of a broken cross-skill pointer on a partial install is worse than the maintenance cost of two copies.

**Write phase:**

- [ ] **Step 1: Load `humanizer` and `write-a-skill`, draft the skill body**

Frontmatter:

```yaml
---
name: extract-idea
description: Surface 5-10 discussion-worthy candidate ideas from a clipped Resource — explore, no structure committed yet. Does not write a literature note itself; that's write-literature-note's job, run separately.
disable-model-invocation: true
---
```

Body must specify:

1. **Input**: a path to an already-captured Resource file (frozen, never edited by this skill) — produced by either `clip-resource` (Task 2) or an external clipper tool.
2. **Surface pass**: an explore-not-exploit pass (same posture as the `writing-fragments` skill researched this session) — produce 5–10 candidate ideas, each as a `question + motivation`, explicitly **not** a finished claim or conclusion. The one concrete failure mode to guard against, verbatim from this session's own diagnosis of the original Web Clipper "Bud candidate" example: a candidate whose `reason` already states a conclusion (*"Knowledge is most useful when broken into atomic, standalone ideas..."*) is doing the thinking the later Socratic stage should be doing — reject that shape, keep candidates as open questions.
3. **Write**: append one row per candidate to `.agents/slipbox/candidates/<resource-slug>.csv` (create the file if it doesn't exist), `status: pending`, `timestamp` set to capture time, `reason` holding the question+motivation text, `literature_note` left blank.
4. **Dismissal at surface time**: if the surfacing pass itself judges a candidate not worth keeping, it is never written to the CSV at all — this is distinct from a candidate dismissed later during `write-literature-note`'s pick step (Task 4), which *is* written with `status: dismissed` and no `reason`.

Body must disclose the schema detail (not inline it) via a context pointer to the sibling reference file created in this same task:

```markdown
CSV schema: see [`references/candidate-schema.md`](references/candidate-schema.md).
```

`references/candidate-schema.md` content:

```markdown
# Candidate CSV Schema

One CSV file per Resource, at `.agents/slipbox/candidates/<resource-slug>.csv`.

| Column | Meaning |
|---|---|
| `slug` | Internal bookkeeping key. Never used as the literature note's filename. |
| `status` | `pending` \| `discussed` \| `dismissed` |
| `timestamp` | Set at extraction time, not updated later. |
| `reason` | The question + motivation surfaced for this candidate. Blank for candidates dismissed at pick time (never written for a dismissal). |
| `literature_note` | Path to the resulting note once `status` becomes `discussed`. Blank otherwise. |

No separate index file exists. Queries:
- Single Resource: `grep ',pending,' .agents/slipbox/candidates/<resource-slug>.csv`
- Cross-resource backlog: `grep -r ',pending,' .agents/slipbox/candidates/`
- Time-ordered: pipe either of the above through `sort` on the timestamp field.

This file is duplicated (not shared) with `write-literature-note`'s copy of the same schema — see that skill's own `references/candidate-schema.md` for why.
```

- [ ] **Step 2: Commit**

```bash
git add "skills/notetaking/extract-idea/SKILL.md" "skills/notetaking/extract-idea/references/candidate-schema.md"
git commit -m "feat: add extract-idea skill"
```

**Review phase:**

- [ ] **Step 3: Stateless/stateful check** — confirm this is correctly stateful (writes the per-Resource CSV) and that per-Resource sharding (not a single merged index) is preserved — this was a deliberate simplification reached this session specifically to avoid token-bloat from loading a growing shared file.

- [ ] **Step 4: `writing-great-skills` audit** — check:
  - Completion criterion for "surfacing is done" is checkable (N candidates written, or explicitly zero if nothing surfaced — a null result is valid, not an error).
  - The CSV schema is disclosed to `references/candidate-schema.md` via a context pointer, not inlined in `SKILL.md`'s body.
  - The duplication with `write-literature-note`'s copy of the same schema is a deliberate, documented exception (install-granularity constraint) — not an oversight. Confirm both copies actually match.

- [ ] **Step 5: Fix any issues found, commit if changed**

```bash
git add "skills/notetaking/extract-idea/SKILL.md"
git commit -m "refine: extract-idea review fixes"
```

---

### Task 4: `write-literature-note`

**Files:**
- Create: `skills/notetaking/write-literature-note/SKILL.md`
- Create: `skills/notetaking/write-literature-note/references/candidate-schema.md`

**Interfaces:**
- Consumes: `.agents/slipbox/candidates/<resource-slug>.csv` (from Task 3) — filtered to `status: pending`, either scoped to one Resource or across all resources depending on how the user invokes it. Also consumes `.agents/slipbox/vault-conventions.md` (Task 1) for filename casing and writing-style sampling.
- `references/candidate-schema.md` in this task is a **duplicate** of Task 3's file, not a shared pointer to it — see Task 3's "Note on schema sharing" for why (install-granularity constraint: `npx skills add` installs individual skills, not the bucket).
- Produces: the literature note file itself (path/casing per vault conventions, filename derived from the finished Claim), and updates the matching CSV row's `status` (`pending` → `discussed`, or `pending` → `dismissed` with no `reason` change) and `literature_note` (path to the written file).

**Write phase:**

- [ ] **Step 1: Load `humanizer` and `write-a-skill`, draft the skill body**

Frontmatter:

```yaml
---
name: write-literature-note
description: Conversational, Socratic discussion of one candidate idea — from a source's claim to a finished Claim/Take literature note. Reads candidates written earlier by extract-idea; can run in a separate session.
disable-model-invocation: true
---
```

Body must specify the full process, exactly as designed this session:

1. **Mode flag, asked upfront**: `full grill` or `claim-only`.
2. **List pending candidates**: filter the relevant CSV(s) to `status: pending` (`grep ',pending,'` for one Resource; `grep -r ',pending,'` across `.agents/slipbox/candidates/` for a cross-resource backlog; pipe through `sort` on the timestamp field for a time-ordered view). Present the list, user picks one.
3. **Phase A — Claim** (genuine sub-conversation, not one exchange): user paraphrases the source's claim in their own words; the AI pushes back if the paraphrase drifts from what the source actually argues ("are you sure that's what they're saying, not X?"); one question at a time, waiting for feedback before continuing (same cadence as `productivity/grilling`). Gate: **explicit user confirmation** the claim is fixed — never inferred. `claim-only` mode stops here.
4. **Phase B — Take** (same rigor, same explicit-confirmation gate; techniques below used as needed, not as a fixed checklist run once each):
   - *Challenge*: "when would this break down," "where would you disagree."
   - *Connect*: "does this remind you of anything you've read," climb the abstraction ladder — this is also where cross-source recurrence of an idea gets noticed by the user, not by any automatic mechanism.
   - *Distil*: AI proposes the reflection back based on the conversation; user corrects it ("almost... actually...").
   - Stopping condition: understanding changed, OR connected to an existing belief, OR a limitation/disagreement surfaced — and even then, only proceeds once the user **explicitly confirms** the take is fixed.
5. **Reference-note linking**: while discussing, if a term surfaces that already has a reference note (per `write-reference-note`, Task 5), the AI proposes linking it with a one-line stated reason ("linking to `design-systems` — same sense as this claim"); the user confirms or rejects each proposed link individually. Never a silent auto-link.
6. **Humanize**: run the hybrid humanizing pass (Global Constraints) on the finished Claim/Take prose.
7. **Write**: incrementally — append the Claim once Phase A is confirmed, append the Take once Phase B is confirmed (don't batch the whole file at the end); re-read the file from disk before each write, same discipline as the `writing-shape`/`writing-beats` skills researched this session. Filename derived from the finished Claim text, vault's own casing convention, **no author prefix**. On a filename collision: fail and ask the user to reword or confirm it's a genuine duplicate idea — never auto-disambiguate.
8. **Update the CSV row**: flip `status` to `discussed`, set `literature_note` to the written file's path. If the user instead dismisses the candidate at pick time (step 2) without discussing it, set `status: dismissed` and leave `reason` untouched (no reason is ever written for a dismissal — this differs from `extract-idea`'s own silent-drop dismissal, which never writes a row at all).

Body must disclose the schema via the same context-pointer pattern as `extract-idea`:

```markdown
CSV schema: see [`references/candidate-schema.md`](references/candidate-schema.md).
```

`references/candidate-schema.md` content is identical to `extract-idea`'s copy (see Task 3, Step 1) — write the same file verbatim into this skill's own `references/` folder.

- [ ] **Step 2: Commit**

```bash
git add "skills/notetaking/write-literature-note/SKILL.md" "skills/notetaking/write-literature-note/references/candidate-schema.md"
git commit -m "feat: add write-literature-note skill"
```

**Review phase:**

- [ ] **Step 3: Stateless/stateful check** — confirm the CSV read/write round-trip is correctly specified (reads `pending`, writes back `discussed`/`dismissed` + `literature_note` path) and that this skill's statefulness composes correctly with `extract-idea`'s — they must agree on the exact same CSV schema.

- [ ] **Step 4: `writing-great-skills` audit** — check:
  - The Claim-phase and Take-phase completion criteria are both checkable (explicit confirmation) — this is the skill most at risk of premature completion, since a conversational skill can drift toward "the AI feels satisfied" if the gate isn't worded as a hard stop.
  - Post-completion steps (Take, write, CSV update) stay out of view while Phase A is still open, so the agent isn't tempted to rush the Claim toward "close enough."
  - Leading words worth deliberately anchoring throughout: *fixed* (the gate condition), *grounded* (if reused from the evergreen design), *candidate* — check they're used consistently, not restated as synonyms.
  - The CSV schema copy matches Task 3's `extract-idea` copy exactly (deliberate duplication, install-granularity constraint — not a shared reference).

- [ ] **Step 5: Fix any issues found, commit if changed**

```bash
git add "skills/notetaking/write-literature-note/SKILL.md"
git commit -m "refine: write-literature-note review fixes"
```

---

### Task 5: `write-reference-note`

**Files:**
- Create: `skills/notetaking/write-reference-note/SKILL.md`

**Interfaces:**
- Consumes: `.agents/slipbox/vault-conventions.md` (Task 1) for filename/frontmatter conventions.
- Produces: the reference note file — definitional content about a term, linked back to whichever Resource(s) prompted it. No CSV interaction — this skill is manual-trigger only and doesn't participate in the candidate pipeline.

**Write phase:**

- [ ] **Step 1: Load `humanizer` and `write-a-skill`, draft the skill body**

Frontmatter:

```yaml
---
name: write-reference-note
description: Manually-triggered, definitional note for a term or source that recurs across your notes, or that you're simply curious about. Not tied to any single clip's outcome — grows over time as more resources touch it.
disable-model-invocation: true
---
```

Body must specify:

1. **Trigger**: purely manual — the user noticed a term recurring across notes (e.g. "Compass of Zettelkasten Thinking" appearing in two independent sources) or has standalone curiosity about something, with no clip involved at all. No automatic detection of recurrence exists in this skill family; this is a deliberate, deferred-for-now scope decision.
2. **Content shape**: a definition of the term/concept — "what is X" — not the user's own idea (that's `write-evergreen-note`'s job) and not primarily a citation record (that's incidental metadata, not the note's content). Explicitly source-anchored: the definition is always linked back to the resource(s) that fed it.
3. **Growth over time**: re-running this skill against an existing reference note updates/extends its definition as new resources touch the same term — the note is not a one-shot artifact.
4. **Humanize and write**: same hybrid humanizing pass as the other writing skills; filename/frontmatter per vault conventions.

- [ ] **Step 2: Commit**

```bash
git add "skills/notetaking/write-reference-note/SKILL.md"
git commit -m "feat: add write-reference-note skill"
```

**Review phase:**

- [ ] **Step 3: Stateless/stateful check** — confirm this skill is stateful in the sense that it can update an *existing* reference note (not just create new ones), and that "no CSV, no candidate-log participation" is the correct scope boundary versus `extract-idea`/`write-literature-note`.

- [ ] **Step 4: `writing-great-skills` audit** — check:
  - The "manual trigger only, no automatic detection" constraint is stated as a positive instruction (what the skill does: wait for the user to name a term) rather than a bare negation ("don't auto-detect recurrence") — per this framework's own guidance that prohibitions should be paired with the positive target, not stated alone.
  - No duplication with `write-literature-note`'s reference-linking behavior — that skill *proposes and links to* existing reference notes; this skill *creates or extends* them. Confirm the boundary is stated clearly in both files without restating each other's full logic.

- [ ] **Step 5: Fix any issues found, commit if changed**

```bash
git add "skills/notetaking/write-reference-note/SKILL.md"
git commit -m "refine: write-reference-note review fixes"
```

---

### Task 6: `write-evergreen-note`

**Files:**
- Create: `skills/notetaking/write-evergreen-note/SKILL.md`

**Interfaces:**
- Consumes: `.agents/slipbox/vault-conventions.md` (Task 1); the specific literature/reference/evergreen notes the user names at invocation time (read directly as vault files, not via the CSV — this skill doesn't touch `.agents/slipbox/candidates/`).
- Produces: the evergreen note file.

**Write phase:**

- [ ] **Step 1: Load `humanizer` and `write-a-skill`, draft the skill body**

Frontmatter:

```yaml
---
name: write-evergreen-note
description: Manually-triggered — connect two or more existing notes (literature, reference, or other evergreen) into a new, purely original idea, when you've noticed a connection between them worth developing.
disable-model-invocation: true
---
```

Body must specify:

1. **Trigger**: manual, the "connective aha" — the user has noticed a connection between two or more existing notes, either while writing something else or while browsing. No automatic scanning for connections exists in this skill family.
2. **Invocation input**: the user names the notes involved and/or states their hunch about the connection, however rough — the skill accepts whichever is given (just notes, just a hunch, or both) rather than requiring a fixed input shape.
3. **Conversation**: Socratic, grounded — can only lean on what the cited notes already established (the `writing-shape` skill's grounding discipline, researched this session: a block can't lean on an ungrounded concept). Same confirm-gated cadence as `write-literature-note`'s Claim/Take: one exchange at a time, AI sharpens the rough hunch, explicit user confirmation before proceeding.
4. **Gate**: user explicitly confirms the connection is real and worth keeping — never inferred.
5. **Purity rule**: the resulting note holds **only** the user's own idea. No author claim from a literature note may be reproduced directly inside the evergreen note — if the connection can't be stated without directly restating someone else's claim, the conversation isn't done yet.
6. **Humanize and write**: incremental append (same discipline as `write-literature-note`), claim-style title derived from the connection actually reached, vault conventions for filename/frontmatter.

- [ ] **Step 2: Commit**

```bash
git add "skills/notetaking/write-evergreen-note/SKILL.md"
git commit -m "feat: add write-evergreen-note skill"
```

**Review phase:**

- [ ] **Step 3: Stateless/stateful check** — confirm this skill correctly reads existing vault files directly (no CSV dependency) and that this is the right boundary — it never needs to know about candidate/pending state, only about already-written notes.

- [ ] **Step 4: `writing-great-skills` audit** — check:
  - The purity rule's completion criterion is checkable, not fuzzy ("does this note contain only my own words" is harder to verify mechanically than the Claim/Take gates — flag whether this needs a sharper test, e.g. "no sentence in this note is attributable to a single cited source's claim without transformation").
  - No premature completion: the gate requires explicit confirmation the connection is "real and worth keeping," same as Claim/Take — verify the wording resists an AI-inferred "this seems settled."
  - Leading word: *grounded* — check it's doing real anchoring work here, matching its use in the researched `writing-shape` skill, not just borrowed vocabulary.

- [ ] **Step 5: Fix any issues found, commit if changed**

```bash
git add "skills/notetaking/write-evergreen-note/SKILL.md"
git commit -m "refine: write-evergreen-note review fixes"
```

---

## Deferred / explicitly out of scope for this plan

- **Evergreen note process** was only lightly designed this session (connective-aha trigger, grounding discipline, purity rule) compared to the literature-note process's full Claim/Take mechanics — Task 6 may need a follow-up discussion pass before or during drafting if the grounded-conversation mechanics turn out to need the same depth Task 4 got.
- **Paywall/login-gate content extraction** for `clip-resource` (Task 2) was explicitly deferred as tech debt during design — that skill covers fetchable content only, and reports failure explicitly rather than attempting a workaround.
- **Automatic reference-note recurrence detection** and **automatic cross-source idea-collision detection** are both explicitly deferred — manual only, for now.
- **Invocation mode** (`disable-model-invocation: true` on all six) is applied here per this session's working decision, but was explicitly held pending final confirmation until after drafting and naming — both are now done; if this needs re-confirming before execution, do so before Task 1 begins.
- **Bucket promotion status** (`skills/notetaking/` vs. folding into `skills/obsidian/`, and promoted vs. non-promoted per `skills/AGENTS.md`) is unresolved — Task 0 uses the working name; renaming the directory later is a mechanical follow-up, not a plan change.
- A **router skill** (per `writing-great-skills`' own guidance: once several user-invoked skills exist, a router skill curing the resulting cognitive load becomes worth considering) is not part of this plan — flagged as a natural Task 7 once all six skills exist and naming has settled.
