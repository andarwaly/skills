---
name: clip-resource
description: Fetch a URL and write it as a frozen Resource, matching Obsidian Web Clipper's output shape — for users without a clipper tool. Fetchable content only; paywalled or login-gated pages are not handled by this skill.
disable-model-invocation: true
---

# Clip Resource

For the case where the user has no Web Clipper, no Readwise, nothing installed: this skill fetches a URL directly and writes a Resource file that looks like Web Clipper's own output. It never touches `.agents/slipbox/` — that's the candidate pipeline's territory, and this skill produces vault content, not pipeline bookkeeping. `extract-idea` reads the Resource file later; this skill's job ends once it's written.

## 1. Take the URL

Ask for a single URL: an article or a video link. There is no paste-the-text fallback. If the user hands you raw text instead of a link, tell them this skill only takes URLs and ask for one.

## 2. Fetch

Retrieve the page or video content directly. Note what you actually got back: full content, a truncated snippet, or nothing.

## 3. Transform

Shape what you fetched into Web Clipper's format:

- Frontmatter: `type`, `link`, `author`, `published`, `tags`.
- Body: a cleaned rewrite of the article, or a structured summary for video.
- Entity sections where the content supports them: People, Tools, Resources, Definition.
- For video, the full transcript.

Stop there. Do not add a "Bud candidate" section, a "Further exploration" section, or any other line that names an idea worth pursuing or a conclusion about what the content means. Reading the material and forming an opinion on it is `extract-idea`'s Socratic stage, run later and separately. A Resource file that already contains a take skips that stage instead of feeding it.

## 4. Write

Save the file using the filename and frontmatter conventions recorded in `.agents/slipbox/vault-conventions.md` by `setup-vault`. Once written, treat the file as frozen: this skill does not reopen it to edit, append, or correct it, and no other skill in this family does either. If the fetch or transform needs a fix, redo the clip and write a fresh file rather than patching the old one.

## 5. Report the outcome

Two valid endings, both explicit:

- **Success**: the Resource file exists at its path, shaped per Step 3. Tell the user where it landed.
- **Fetch failure**: the fetch returned an error, or returned content but it's a paywall teaser, a login wall, or otherwise not the real article or video. Report plainly what came back and why it looks incomplete, and stop there — do not write a partial Resource file, and do not attempt to work around the paywall or login gate. A clear failure report is a complete, correct run of this skill; a half-written Resource file is not.
