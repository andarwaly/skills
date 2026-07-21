# discuss-connection

Manually-triggered: connect two or more existing notes (literature, reference, or other evergreen) into a new, purely original idea, once you've noticed a connection between them worth developing.

## When to use

Use this when you've had a "connective aha" — you've noticed that two or more of your existing notes relate in a way worth developing into something new, whether that struck you while writing something else or while browsing your vault. There's no automatic scanning for connections anywhere in this skill family; it starts only when you bring one here.

## How it works

1. **Wait for the connective aha** — nothing scans for this on its own.
2. **Take what you give it** — named notes, a rough hunch, or both. If you name notes without a hunch, it reads them and starts the conversation from what's actually in them. If you state a hunch without naming notes, it asks which notes it's about first.
3. **Sharpen the connection, grounded** — a real sub-conversation, one exchange at a time, never a fully-formed connection dropped for you to rubber-stamp. Every question and reflection has to trace to something the cited notes actually establish — if sharpening the hunch needs a claim none of them contain, that's a sign to cite a different or additional note, not to fill the gap from general knowledge.
4. **Gate: confirm the connection is real** — fixed only once you explicitly say so; never inferred from a pause or the conversation feeling settled.
5. **Purity rule** — the finished note holds only your own idea. Every sentence is tested: is it attributable to a single cited note's claim without transformation? If a sentence merely restates one source's claim in different words, it's not ready yet.
6. **Write** — incremental, re-reading the file from disk before each write. Title comes from the connection actually reached, same claim-style convention `discuss-idea` uses, not from the cited notes' own titles. Links back to every note that fed the connection. On a filename collision, it stops and asks rather than auto-disambiguating.

## Usage

Invoke it by name, with whatever you have — notes, a hunch, or both:

> I think this literature note connects to that reference note — help me work out how.

## Installation

This skill ships as part of the `andarwaly/skills` collection:

```bash
npx skills add andarwaly/skills
```

See the [skill source](../../skills/slipbox/discuss-connection/) for the full agent-facing instructions.
