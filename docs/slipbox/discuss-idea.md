# discuss-idea

A conversational, Socratic discussion of one candidate idea — from a source's claim to a finished Claim/Take literature note. Reads candidates written earlier by `surface-ideas`, and can run in a completely separate session.

## When to use

Use this once you have candidates sitting in `.agents/slipbox/candidates/` from `surface-ideas` and are ready to actually think through one of them. This is the core of the slipbox family: not a one-shot generator, a real back-and-forth conversation with two gated phases.

## How it works

1. **Mode** — asked upfront: `full grill` (Claim and Take) or `claim-only` (Claim, then stop).
2. **Pick a candidate** — lists pending candidates (single-Resource, cross-resource backlog, or time-ordered), and you pick one.
3. **Phase A, the claim** — you paraphrase the source's claim in your own words; the skill pushes back if the paraphrase drifts from what the source actually argues. One question at a time. **The claim is fixed only once you explicitly confirm it** — a pause, a change of subject, or the conversation feeling settled is never treated as confirmation.
4. **Phase B, the take** (full grill mode only) — draws on Challenge ("when would this break down"), Connect ("does this remind you of anything you've read"), and Distil (proposing a reflection back for you to correct) as the conversation calls for them, not as a fixed sequence. Same explicit-confirmation gate as the claim.
5. **Reference-note linking** — if a term comes up that already has a reference note, the skill proposes linking it with a stated reason; you confirm or reject each one individually. Never a silent auto-link.
6. **Write** — appends the Claim once Phase A is fixed, appends the Take once Phase B is fixed, re-reading the file from disk before each write. Filename comes from the finished claim text, in claim-style rather than topic-style, using your vault's own casing convention. On a filename collision, it stops and asks rather than auto-disambiguating.
7. **Update the CSV row** — flips the candidate's status to `discussed` (or `dismissed`, if you dismissed it at the pick step instead).

## Usage

Invoke it by name:

> Let's discuss one of the surfaced ideas.

The skill lists what's pending and takes it from there.

## Installation

This skill ships as part of the `andarwaly/skills` collection:

```bash
npx skills add andarwaly/skills
```

## Reference

- [candidate-schema.md](../../skills/slipbox/discuss-idea/references/candidate-schema.md) — the CSV schema this skill reads and updates

See the [skill source](../../skills/slipbox/discuss-idea/) for the full agent-facing instructions.
