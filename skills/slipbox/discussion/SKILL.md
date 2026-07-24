---
name: discussion
description: Internal Socratic conversation engine for the slipbox family, three modes (literature/reference/evergreen). Invoked by write-literature-note, write-reference-note, and write-evergreen-note with their own framing; never invoked directly by name.
disable-model-invocation: true
license: MIT
metadata:
  version: "1.0.0"
---

# Discussion

<!-- Context pointer for the human maintainer: the design rationale behind this skill's
     three-mode split, the invariant list, and the resume-file/placeholder-row mechanics
     lives in discussion/note-taking-skills/grill-decisions-2026-07-23.md. Nothing there
     is required reading at runtime — everything the agent needs to run a session is
     inline below. -->

This skill is never invoked by the user directly. `write-literature-note`, `write-reference-note`, and `write-evergreen-note` each call into it, naming their mode (`literature`, `reference`, or `evergreen`) and handing it whatever framing that mode needs (a source's claim, a term, a topic to think through). Everything in **Shared rules** applies to all three modes without exception. Each mode section below adds only what differs.

## Shared rules (all modes)

These hold regardless of which mode invoked this skill. Read this section once; it is not repeated per mode.

### One question at a time

Ask a single question, then wait for the user's answer before asking the next. Never dump two or more questions into one turn.

### INVARIANT #1: never draft the claim yourself

The agent never drafts the claim, definition, or connection. The whole assembly is built only from sentences the user actually typed. When the conversation calls for reflecting the emerging idea back ("distil" — see the evergreen section), that move quotes and lightly reshapes the user's own words for them to correct ("almost, actually…"). It never introduces phrasing of its own as if it were the content.

**Why this is a rule for an LLM specifically, not just good practice:** a human research assistant drafting on someone's behalf would still be putting the *user's* thinking into words, because the assistant has no other source of ideas to draw on. An LLM does — it can generate fluent, plausible-sounding claims from its training data that were never actually the user's thought, and the user may not notice the substitution because the phrasing reads as reasonable. The whole point of a slipbox is that every note traces back to the user's own thinking; a claim ghostwritten by the model breaks that traceability even when the words happen to be correct.

### Gate: explicit confirmation only

A claim, definition, or connection is fixed only when the user says something that explicitly confirms it — "yes, that's it," "fixed," or equivalent. Never infer the gate from a pause, a change of subject, or the conversation merely feeling settled.

**Why this needs stating explicitly:** an LLM has a strong prior toward treating a topic change or a lull as tacit agreement, because moving on is the conversationally smooth thing to do — a human assistant reads hesitation or silence far more skeptically by default. Left unstated, the model will round an ambiguous moment up to "confirmed" and write down something the user never actually signed off on.

### Anti-summary guard

If the user rubber-stamps a proposal without actually engaging with it, probe once more before treating the gate as passed. A claim, definition, or connection the user can't defend across one more exchange isn't fixed yet, no matter what they said.

### Mushy answers: keep grilling

A vague or hand-wavy answer is not raw material to polish into something coherent on the user's behalf. Flag the vagueness and ask again; don't fill it in.

### Resume-file discipline

**On start, before anything else:** list `.slipbox/discussions/` for files belonging to this mode and offer to resume one before offering to start new work.

**When to create the file:** only after the first substantive exchange — not after the first question is merely asked, but once the user has actually answered it. Write to `.slipbox/discussions/<slug>.md`:

```markdown
---
idea_slug: <slug>
mode: literature|reference|evergreen
phase: <mode-specific phase name>
resource: <resource slug(s), literature/reference modes only>
updated_at: <ISO8601>
---

## Draft (user's latest, verbatim)
...

## Open threads
- ...
```

`resource` carries whatever source(s) this session is grounding against (the one resource for literature mode, one or more for reference mode). It is what lets the calling skill resume a paused session without re-deriving that context from scratch — see each mode's own resume handling below. Evergreen mode omits it: the placeholder `evergreen` row it inserts already anchors the session by slug.

**Write it as an explicit step**, not an assumption: at each point this file needs creating or updating, actually do it — "write/update the resume file now." There is no default reason for an LLM to persist a file it wasn't told to persist; treat this as a required action in the flow, every time, not a background habit.

Bump `updated_at` at gate-relevant checkpoints (a phase fixed, a placeholder row inserted), not on every message.

**Lifecycle end:** the calling `write-*-note` skill deletes this file the moment it finishes writing the note and flips the corresponding row (`seeds` or `evergreen`). This skill never deletes it itself.

### Voice pass — three ordered sub-steps, run in this order, before any write

Run all three, in this order, immediately before writing the note (or the note section) to disk. None of these steps may introduce content beyond what the user confirmed.

1. **Fidelity** — re-read the user's confirmed sentences against the assembled note. Nothing may be added beyond what the user actually confirmed.
2. **Register** — load `.slipbox/style-profile.md` and sample 2-4 corpus notes of the same note type. Adjust connective tissue only (transitions, framing); confirmed claim/definition/Take sentences stay frozen, verbatim-first.
3. **Lint** — check the assembly's prose against `.slipbox/humanize-checklist.md`. Flag only a cluster of two or more signals together; never auto-rewrite — surface the flag and let the user decide. The user's own baseline habits, as recorded in the style profile, are never flagged even if they'd otherwise match a checklist signal.

---

## Mode: literature

Invoked by `write-literature-note`. Produces a Claim only, grounded against the one source the candidate came from.

**Grounding direction:** the *user* must stay grounded to what the source actually claims. The *agent's* job is to flag drift into the user's own opinion — "that sounds like your own take, not what the author argued — is that what you meant, or is this the author's position?"

**Technique — stress-test:** when the paraphrase drifts from the source, push back: "are you sure that's what they're saying, and not X?" This technique exists solely to check paraphrase fidelity. It is never used to generate or shape the user's opinion — that's the personal-take path below, or evergreen's job entirely.

**No `idea.db` retrieval in this mode.** Ground only against the one resource the candidate came from — nothing else is pulled in.

**Gate:** the Claim is fixed.

**After the gate, actively ask** — this is an invitation, not passive noticing — "does this claim raise an open question?"

- If yes: the user's own typed answer becomes a new `seeds` row: `type: raw`, `target_type: literature` or `reference` depending on what the user's answer is actually about, `origin: 'discussion'`, `status: 'to-discuss'`.
- If the user has none: skip, without pressure. Never manufacture a question to fill this slot.

**Personal-take drift mid-conversation:** if the stress-test surfaces a personal take and the user confirms it's genuinely their own view (not the author's), log it the same way — a new `seeds` row, `origin: 'discussion'`, same field rules as above.

**Reference-note linking:** if a term with an existing reference note comes up, propose linking it with a one-line reason. The user accepts or rejects each proposed link individually. Never link silently.

**Write:** a literature note, Claim only. Filename derived from the confirmed claim text, no author prefix.

**Filename collision:** stop and ask the user to reword the claim, or confirm this is a genuine duplicate. Never auto-disambiguate the filename.

---

## Mode: reference

Invoked by `write-reference-note`. Produces a definition, not a Claim — there is no Take-equivalent second phase in this mode.

**Grounding direction:** same shape as literature — the *user* stays grounded to the definition. The *agent* flags drift into "here's what I think about X" as belonging elsewhere (evergreen's job), not this note.

**Grounds against:** the raw resource(s) named for this term. Genuinely plural from the start is allowed — the user may name several resources touching the same term in one sitting.

**On extension** (a new resource added to an already-existing reference note): ground against *two* things — the new resource, and the existing note's current confirmed content, re-read fresh from disk immediately before this conversation starts (the note may have been edited, extended by a different resource, or otherwise changed since it was last looked at — a stale in-memory copy would silently ground the conversation against content that no longer matches the file). Do not re-read the term's entire historical resource list; the note's own accumulated text is the working summary of everything before it.

**No broad `idea.db` relevance search** in this mode (unlike evergreen). The existing-note lookup, if any, is a direct, exact match on the term — not a fuzzy or ranked query.

**Gate:** the definition reads correctly. (Not "the Claim is confirmed" — this mode has no second phase to gate.)

**Write:**

- **New term:** write fresh. Filename from the term as the user writes it.
- **Existing term:** fold in the new source's contribution. Append/extend only — never overwrite the note's existing content wholesale.

---

## Mode: evergreen

Invoked by `write-evergreen-note`. Produces a Take: a connection that states something none of the individually cited notes said on their own.

**Grounding direction is the inverse of the other two modes.** The *agent's* questions and reflections stay grounded to what's actually retrieved from `idea.db`. The *user's* answers are free — personal experience, memory, anything not written down anywhere — because that freedom is the entire point of this note type.

**Retrieval:** query `seeds` (`type = 'literature'`) and `evergreen` for relevance to whatever the user wants to think through, via `seeds_fts` (`MATCH` + `bm25()` ranking) — not exact or keyword matching.

**Techniques**, drawn on as the conversation calls for them, in no fixed order:

- **Connect/abstraction** — what else does this touch; climb the abstraction ladder.
- **Challenge** — when would this connection break down?
- **Compass prompts** — what competes with this (E)? where does it lead (S)?
- **Distil** — reflect the emerging connection back for the user to correct.

**Grounding rule:** every agent question or reflection must trace to something a retrieved note actually establishes. If sharpening the connection needs a claim no retrieved note contains, that's a signal the wrong notes were retrieved, or that a third note needs pulling in — never fill the gap from general knowledge.

**Purity rule** (a per-sentence test, applied before writing): is this sentence attributable to a single cited note's claim without transformation? If yes for any sentence in the draft, the conversation isn't done — keep sharpening until the connection states something none of the individual notes said on their own.

**Sign-off rubric** — shown to the user for explicit confirmation, distinct from both the confirmation gate above and the purity rule:

- The title is a complete claim.
- The note is standalone-comprehensible by a future version of the user with no memory of this conversation.
- It is about one thing, entirely.
- Every link has a stated reason.
- The note answers, or spawns, a "so what / what's next."

**Placeholder row:** inserted into `evergreen` the moment the resume file would first be created (same "after the first substantive exchange" trigger as the shared resume-file rule) — a provisional draft-prefixed slug (e.g. `draft-tool-shapes-cognition-atomic-ideas`), `note_path: NULL`, `status: 'discussing'`.

**Gate:** the Take is fixed.

**On write:**

- The placeholder row's slug renames to its final claim-style form, prefix stripped.
- `note_path` is filled.
- `status` becomes `'discussed'`.
- `iteration` stays at its current value (`1` for a new note).
- `links` rows are inserted for every cited note (`rel_type: 'cites'`) only now, at write time — never earlier in the conversation.

**Revisiting an already-discussed evergreen note:** `status` moves back to `discussing` while the note is being reworked, then back to `discussed` once the rewrite lands; `iteration` increments. Unlike reference notes, which are append-only, an evergreen rewrite **can replace** the note's existing content wholesale, not just add to it.
