---
name: discuss-connection
description: Manually-triggered — connect two or more existing notes (literature, reference, or other evergreen) into a new, purely original idea, when you've noticed a connection between them worth developing.
disable-model-invocation: true
license: MIT
metadata:
  version: "1.0.0"
---

# Discuss Connection

This skill turns a connective aha into a new note that holds only the user's own idea, never a source's claim restated. There is no detector watching for connections; it starts only when the user brings one here.

## 1. Wait for the connective aha

No automatic scanning exists anywhere in this skill family. This starts only when the user has noticed a connection between two or more existing notes, whether while writing something else or while browsing the vault, and brings it here themselves.

## 2. Take what the user gives you

Accept whatever the user opens with: named notes, a rough hunch about how they connect, or both. Don't require a fixed shape.

- **Notes named, no hunch yet:** read the notes, then start the conversation in Step 3 from what's actually in them.
- **Hunch stated, notes not named:** ask which notes it's about before going further; the conversation in Step 3 has nothing to stay grounded against otherwise.
- **Both given:** read the notes and start from the hunch directly.

**Done when:** you have at least one named note and some starting hunch, however rough, to work from.

## 3. Sharpen the connection, grounded

A real sub-conversation, one exchange at a time: ask a question, wait for the user's answer, then ask the next. Never dump a fully-formed connection and ask the user to approve it.

Stay grounded: every question and every reflection you offer back has to trace to something the cited notes actually establish. If sharpening the hunch requires leaning on a claim none of the named notes contain, that's a sign the wrong notes are cited, or a third note needs pulling in, not a gap to fill from general knowledge.

## 4. Gate: confirm the connection is real

The connection is fixed only once the user says something that explicitly confirms it, for instance "yes, that's it," "that's the connection," or an equivalent direct statement — never inferred from a pause, a change of subject, or the conversation feeling settled. Keep discussing until the user actually says so.

## 5. Purity rule

The finished note holds only the user's own idea. Test each sentence before it goes in: is it attributable to a single cited note's claim without transformation? If a sentence merely restates one source's claim in different words, that sentence is not ready — the conversation in Step 3 isn't done yet. Keep sharpening until the connection can be stated as something none of the individual notes said on their own.

## 6. Humanize and write

Run the humanizer pass on the finished note before writing it.

Write incrementally: append to the file as the note develops rather than writing it all in one shot. Re-read the note file from disk immediately before each write.

Derive the title from the connection actually reached, in the same claim-style convention `discuss-idea` uses for its Claim, not from the cited notes' titles. Use the filename and frontmatter conventions in `.agents/slipbox/vault-conventions.md`, and link back to every note that fed the connection.

**On a filename collision:** stop and ask the user to reword the title or confirm this is a genuine duplicate idea. Never auto-disambiguate the filename yourself.

**Done when:** the file on disk reflects the confirmed connection, links every note that fed it, and no sentence in it merely restates one of those notes' claims un-transformed.
