---
name: surface-ideas
description: Surface 5-10 discussion-worthy candidate ideas from a clipped Resource — explore, no structure committed yet. Does not write a literature note itself; that's discuss-idea's job, run separately.
disable-model-invocation: true
---

# Extract Idea

This skill takes a Resource file and surfaces candidate ideas from it. It does not decide which candidate is worth writing up, and it does not write the literature note itself: that's a separate skill, run separately, possibly in a different session.

## 1. Take the Resource

Ask for the path to an already-captured Resource file: one written by `clip-resource`, or dropped in by an external tool such as Obsidian Web Clipper or Readwise. Either source is fine. Treat the file as frozen: read it, never edit it.

## 2. Surface pass

Read the Resource and surface 5-10 candidates. This is an explore pass, not an exploit pass: the goal is a spread of open questions worth discussing, not a shortlist of answers.

Each candidate is a question plus the motivation for asking it. Neither half is a conclusion. A candidate that already states what the idea means, or what follows from it, has skipped past exploration into the discussion that's supposed to happen later, in `discuss-idea`. Watch for this shape and reject it:

> Reason: "Knowledge is most useful when broken into atomic, standalone ideas that can be freely recombined."

That's a finished claim, not a question. It reads like this instead:

> Question: What would it mean to treat a note as a single reusable idea rather than a container for everything related to a topic?
> Motivation: The source argues for atomic notes but never says what breaks when a note holds more than one idea, which is worth pressure-testing.

If a draft candidate reads like the first example, rewrite it as a question before it goes anywhere near the CSV.

**Done when:** you have 5-10 candidates in question-plus-motivation form, none of them a conclusion. Fewer than 5 is fine if the Resource genuinely doesn't support more; don't pad the count with weak candidates.

## 3. Dismiss at surface time

Some candidates that come up during the pass aren't worth keeping at all: too thin, too redundant with another candidate, or not really a question. Drop these before writing anything. A candidate dismissed here leaves no trace in the CSV. That's different from a candidate dismissed later, during `discuss-idea`'s pick step, which does get a row, with `status: dismissed` and `reason` left exactly as it was written at extraction time.

## 4. Write

Append one row per surviving candidate to `.agents/slipbox/candidates/<resource-slug>.csv`, creating the file if it doesn't exist. Each row: `status: pending`, `timestamp` set to now, `reason` holding the question and motivation from Step 2, `literature_note` left blank.

CSV schema: see [`references/candidate-schema.md`](references/candidate-schema.md).

**Done when:** every surviving candidate is a row in the CSV, or, if none survived Step 3, zero rows were written. A null result is a complete run, not a failure; report the count either way.
