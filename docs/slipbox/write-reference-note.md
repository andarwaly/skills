# write-reference-note

A manually-triggered, definitional note for a term or source that recurs across your notes, or that you're simply curious about. Grows over time as more resources touch the same term — not tied to any single clip's outcome.

## When to use

Use this when you notice a term showing up across two or more of your notes and want a real definition of it, or when you're just curious about something and want to look it up properly. There's no automatic recurrence detection anywhere in this skill family — this skill starts only when you bring a term to it directly.

## How it works

1. **Wait for a named term** — you name the term; the skill doesn't watch for it.
2. **Check for an existing note** — if one already exists under this term, it reads it in full and extends it rather than replacing it.
3. **Build the definition** — asks which resource(s) prompted the term, then drafts a definition in your own words. Two things it deliberately isn't: your own idea or reaction (that's `discuss-connection`'s job), and a citation record (the source anchors the definition, it isn't the point of the note).
4. **Write** — for a new note, writes the definition with a link back to its source(s). For an existing note, re-reads it from disk and extends it — adding the new source's link and folding in whatever the new source adds, without overwriting what's already there.

## Usage

Invoke it by name with the term:

> Write a reference note for "Design Systems."

`discuss-idea` proposes links to reference notes while discussing a claim, and you confirm each one there — this is the other half, where a reference note actually gets created or extended.

## Installation

This skill ships as part of the `andarwaly/skills` collection:

```bash
npx skills add andarwaly/skills
```

See the [skill source](../../skills/slipbox/write-reference-note/) for the full agent-facing instructions.
