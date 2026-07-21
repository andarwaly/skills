---
name: discuss-idea
description: Conversational, Socratic discussion of one candidate idea — from a source's claim to a finished Claim/Take literature note. Reads candidates written earlier by surface-ideas; can run in a separate session.
disable-model-invocation: true
license: MIT
metadata:
  version: "1.0.0"
---

# Discuss Idea

This skill turns one candidate from `surface-ideas` into a literature note through a real discussion, not a one-shot proposal the user rubber-stamps. Two phases, Claim then Take, each ends only when the user says so.

## 1. Mode

Ask upfront: `full grill` (Claim and Take) or `claim-only` (Claim, then stop). Record the answer; it decides whether Phase B runs at all.

## 2. Pick a candidate

Filter the relevant CSV(s) to `status: pending`:

- One Resource: `grep ',pending,' .agents/slipbox/candidates/<resource-slug>.csv`
- Cross-resource backlog: `grep -r ',pending,' .agents/slipbox/candidates/`
- Time-ordered: pipe either through `sort` on the timestamp field.

Present the pending candidates and let the user pick one. If the user instead dismisses a candidate here without discussing it, skip straight to the dismissal path in Step 8.

**Done when:** one candidate is picked, or the user has dismissed it at this step.

## 3. Phase A: the claim

A real sub-conversation, not one exchange. The user paraphrases the source's claim in their own words. If the paraphrase drifts from what the source actually argues, push back: "are you sure that's what they're saying, and not X?" Ask one question at a time, and wait for the user's answer before asking the next.

**Gate:** the claim is fixed only once the user says something that explicitly confirms it: "yes, that's it," "fixed," or equivalent. A pause, a change of subject, or the conversation feeling settled is not confirmation; keep discussing until the user actually says so. In `claim-only` mode, stop here once the claim is fixed. Do not move into Phase B, reference-note linking, or writing.

## 4. Phase B: the take

Runs only in `full grill` mode, and only once the claim is fixed. Same rigor, same explicit-confirmation gate. Draw on these techniques as the conversation calls for them, in whatever order fits, not as a fixed checklist run once each:

- **Challenge**: when would this break down, where would the user disagree.
- **Connect**: does this remind the user of anything else they've read; climb the abstraction ladder. This is also where the user, not any automatic mechanism, notices an idea recurring across sources.
- **Distil**: propose the reflection back based on the conversation; let the user correct it ("almost, actually...").

A take is ready to propose as fixed once understanding changed, or connected to something the user already believes, or a limitation or disagreement surfaced. Even then, the take is fixed only once the user explicitly confirms it, never inferred from tone or momentum.

## 5. Reference-note linking

While discussing either phase, if a term comes up that already has a reference note, propose linking it with a one-line reason ("linking to `design-systems`, same sense as this claim"). The user confirms or rejects each proposed link individually. Never link silently.

## 6. Humanize

Run the humanizer pass on the finished Claim and Take prose before writing either one.

## 7. Write

Write incrementally, not all at once: append the Claim once Phase A is fixed, append the Take once Phase B is fixed. Re-read the note file from disk immediately before each write. Use the filename and frontmatter conventions in `.agents/slipbox/vault-conventions.md`: derive the filename from the finished claim text, in the vault's own casing convention, with no author prefix, and apply that file's frontmatter fields to the written note.

**On a filename collision:** stop and ask the user to reword the claim or confirm this is a genuine duplicate idea. Never auto-disambiguate the filename yourself.

**Done when:** every phase that ran (Claim only, or Claim and Take) has its own file write, in order, each against a freshly re-read file.

## 8. Update the CSV row

Once the note is written, flip that row's `status` to `discussed` and set `literature_note` to the file's path.

If the user dismissed the candidate back in Step 2 instead of discussing it, set `status` to `dismissed` and leave `reason` untouched: it already holds the question and motivation `surface-ideas` wrote at extraction time, so there's nothing to add or blank. This differs from `surface-ideas`'s own dismissals, which are dropped before ever becoming a row.

CSV schema: see [`references/candidate-schema.md`](references/candidate-schema.md).
