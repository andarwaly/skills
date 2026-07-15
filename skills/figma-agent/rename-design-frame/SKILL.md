---
name: rename-design-frame
description: Rename Figma frames, sections, and subsections so every name traces back through its full ancestor chain. Use when frame or section names are inconsistent, missing, duplicated, or need to reflect their Core Flow / Edge Case / Error Case origin, or when asked to "clean up naming", "fix frame names", "standardize section names", "rename these frames", "find duplicate frame names".
---

# Rename Design Frame

A name is a traceable chain: Section, branch, condition, read left to right, nothing skipped. Every rule below exists to keep that chain unbroken and unambiguous out of context.

## The Chain

- Delimiter: ` - ` (space-hyphen-space), Title Case, no trailing punctuation.
- Always the full ancestor chain, never the bare leaf: `Project Detail - Filter - Role - Single`, not `Single`.
- No order-number prefix (`01 -`, `02 -`). Position already encodes sequence, so a number just goes stale the first time a step is inserted.
- Section and Subsection names: Title Case, no page-prefix inside the name itself (the page-level `- Page Name` prefix lives one level up, at the page, not the section).

## Edge Case / Error Case Naming

Naming-only distinction: the frame's chain names its originating branch and condition, but the frame still lives physically inside its Section's `Edge Cases` or `Error Cases` subsection (see `/organize-design-file` for the physical grouping).

```
<Section> - <OriginatingBranch> - Edge - <Condition>
<Section> - <OriginatingBranch> - Error - <Condition>
```

Example: an error in the "Create" flow of "Project" becomes `Project - Create - Error - Submission Failed`, and lives inside the `Error Cases` subsection under `Project`.

## Workflow

1. Read the target frame(s)/section(s) name and hierarchy via `evaluate_script` (`figma.currentPage.selection`, or a specified scope).
2. Check for duplicate names within the scope. Two siblings sharing one name is always wrong under the chain rule, since each frame's position in the hierarchy is unique, so a real duplicate means at least one name has lost the branch/condition segment that would disambiguate it. Flag every duplicate found, even if not otherwise asked to rename.
3. For each node, whether flagged as a duplicate or not, walk its ancestor chain (Section → branch → Edge/Error subsection if applicable) to determine the correct chain per the rules above.
4. Build the full rename list: current name → proposed name, for every affected node.
5. Present the list and wait for explicit approval. Never rename silently, even for a single node.
6. On approval, apply via `node.name = newName`.

**Completion criterion:** every node in the approved list has its new name applied, no node was renamed that wasn't in that list, and no duplicate names remain within the checked scope.
