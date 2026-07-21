# setup-vault

One-time onboarding for the slipbox skill family: discovers your vault's filename, frontmatter, and template conventions, plus your writing style, before any other slipbox skill runs.

## When to use

Run this once, before using any other slipbox skill for the first time. Every other skill in the family reads the config file it produces — `clip-resource`, `surface-ideas`, `discuss-idea`, `write-reference-note`, and `discuss-connection` all depend on it for filenames, frontmatter, and voice.

Re-run it later only to change a recorded convention, or to restart the writing-style capture from scratch. It isn't something to run routinely.

## How it works

The skill runs four steps in sequence, each ending on an explicit confirmation rather than an inferred one:

1. **Explore** — checks `.obsidian/` for a `templates/` folder or Templater config, checks root `AGENTS.md`/`CLAUDE.md` for conventions already written down, and checks for an existing note corpus to sample writing style from later.
2. **Vault conventions** — presents what it found, recommends a default for anything missing, and confirms filename casing, frontmatter fields, and template usage one item at a time.
3. **Writing style** — if a note corpus already exists, records its location for later skills to sample from directly. If the vault is greenfield, interviews you about voice and tone instead.
4. **Write** — drafts the config file, shows it to you, and only writes it once you approve.

Confirmation is never inferred from silence, a pause, or the conversation moving on — every section requires you to explicitly say yes or correct it.

## Usage

Invoke it by name; it doesn't fire on its own:

> Run setup-vault.

It writes `.agents/slipbox/vault-conventions.md` inside your vault (not in this repo), and every other slipbox skill reads that file at runtime.

## Installation

This skill ships as part of the `andarwaly/skills` collection:

```bash
npx skills add andarwaly/skills
```

See the [skill source](../../skills/slipbox/setup-vault/) for the full agent-facing instructions.
