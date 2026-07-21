---
name: write-reference-note
description: Manually-triggered, definitional note for a term or source that recurs across your notes, or that you're simply curious about. Not tied to any single clip's outcome — grows over time as more resources touch it.
disable-model-invocation: true
license: MIT
metadata:
  version: "1.0.0"
---

# Write Reference Note

This skill writes or extends a reference note: a definition of a term, answering "what is X." It does not read the candidate CSVs and does not touch `.agents/slipbox/candidates/` at all; there is no clip to react to and no row to update. `discuss-idea` proposes links to reference notes while discussing a claim, and the user confirms each one there. This skill is the other half: where a reference note actually gets created or extended, whether or not that conversation ever happened.

## 1. Wait for the user to name a term

There's no detector watching for recurrence. This skill starts only when the user brings a term to it directly, either because they noticed it showing up in two or more notes, or because they're just curious about it. Ask which term, if it isn't already obvious from context.

**Done when:** you have one named term to work from.

## 2. Check for an existing note

Look for a reference note already filed under this term, using the filename convention in `.agents/slipbox/vault-conventions.md`. Two paths from here:

- **No existing note:** proceed to Step 3 to build the definition from scratch.
- **Existing note:** read it in full, then proceed to Step 3 to extend it rather than replace it.

## 3. Build the definition

Ask the user which resource(s) prompted this term: the note they were reading, or their own recollection of where they've seen it before. Draft a definition of the term itself, in the user's own words, not the source's phrasing verbatim.

Two things this is not:

- **Not the user's own idea.** An argument, a take, a reaction the user wants to develop is `discuss-connection`'s job. If the conversation drifts into "here's what I think about X" rather than "here's what X is," note that this belongs in an evergreen note instead and keep this draft to the definition.
- **Not a citation record.** The source is there to anchor the definition, not to be the point of the note. A note that's mostly bibliographic detail with a thin definition attached has the emphasis backwards.

Every definition here traces back to at least one resource. Record which resource(s) fed it as you go, so the note carries that link when it's written.

**Done when:** the user has confirmed the definition reads correctly, and you know which resource(s) it draws from.

## 4. Humanize

Run the humanizer pass on the finished definition before writing it.

## 5. Write

**New note:** use the filename and frontmatter conventions in `.agents/slipbox/vault-conventions.md`. Write the definition with a link back to the resource(s) named in Step 3.

**Existing note:** re-read the file from disk immediately before writing, then extend it: add the new resource's link, and fold in anything the new source adds or complicates about the term. Don't overwrite what's already there wholesale; a reference note accumulates across resources over separate runs of this skill rather than getting finalized once.

**Done when:** the file on disk reflects the confirmed definition and every resource that has ever fed it, old and new.
