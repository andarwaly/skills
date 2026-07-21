---
name: setup-vault
description: One-time onboarding for the slipbox skill family — discovers vault conventions (filenames, frontmatter, templates) and writing style before any other skill in this family runs. Run once per vault; re-run only to change conventions or style.
disable-model-invocation: true
license: MIT
metadata:
  version: "1.0.0"
---

# Setup Vault

Every other skill in this family reads `.agents/slipbox/vault-conventions.md` before it writes anything. This skill produces that file through four steps: explore, confirm conventions, confirm style, write.

## 1. Explore

Check the vault for existing signal before asking the user anything:

- `.obsidian/` for a `templates/` folder and Templater plugin config (`.obsidian/plugins/templater-obsidian`), which show the vault's real template location and syntax.
- Root `AGENTS.md` or `CLAUDE.md` for conventions the user already wrote down.
- Any existing literature or evergreen notes (folders named `Literature`, `References`, `Evergreen`, or similar) to use as a writing-style corpus later.

**Done when:** you know, for each of the three checks above, whether it found something or came up empty.

## 2. Section A: vault conventions

Present what you found. For anything missing, recommend a default and lead with it, for example: "No filename convention found. I recommend kebab-case (`my-note-title.md`): sound right, or do you use something else?" Go one item at a time:

- Filename casing for literature, reference, and evergreen notes (kebab-case, Title Case, snake_case, or whatever the vault already does).
- Frontmatter fields in use, if any, and their types.
- Whether a Templater template governs note structure, and if so, its path.

**Done when:** the user has explicitly confirmed or corrected every item above. Do not infer confirmation from silence or from the user moving on to the next topic.

## 3. Section B: writing style

Check whether Step 1 found a note corpus.

- **Corpus exists:** record its path. Later skills sample from it directly at write time, so no style needs to be captured now.
- **Corpus is empty (greenfield):** interview the user directly. Ask about voice and tone: first person or third, terse or exploratory, technical or conversational. Record the stated answer as the default style for skills that don't have real notes to sample from yet.

**Done when:** the user has explicitly confirmed the recorded style statement, or confirmed the corpus path is correct.

## 4. Write

Draft `.agents/slipbox/vault-conventions.md` with both sections' confirmed results, and show the user the draft before writing it. Let them edit it. Only write the file after they approve the draft. Do not write on the strength of the per-section confirmations from Steps 2 and 3 alone, since the user may still want to adjust wording once they see it laid out together.

**Done when:** the file is written and matches the approved draft.

## 5. Done

Tell the user setup is complete, name the file you wrote, and note that `clip-resource`, `surface-ideas`, `discuss-idea`, `write-reference-note`, and `discuss-connection` all depend on it. Re-running this skill is only needed to change a convention or restart the writing style from scratch, not something to do routinely.
