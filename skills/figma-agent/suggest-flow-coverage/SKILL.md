---
name: suggest-flow-coverage
description: Suggest which Core Flow, Edge Case, and Error Case frames a concept still needs, once a design-exploration option is chosen and it's time to build out the full user flow. Use when asked to "what flows do I need to prep", "check coverage for this concept", "what edge cases am I missing", "suggest error states for this flow", or when a picked Option is moving from exploration into a full Section.
---

# Suggest Flow Coverage

Coverage is never required, only suggested. Every item below is a prompt to consider, not a gate to pass. Invoked deliberately, once, when a concept is ready to move from Option mode into a full Flow-mode Section, never fired automatically by `/organize-design-file`.

## Detecting Components

Use Figma's built-in **Search Local Components** tool to find the actual component instances already in the frames being checked, rather than guessing component type from raw layer shape. Map each detected instance to one of the vocabulary categories below.

For structural questions the instance itself can answer (does this Table variant even have a create/remove action?), defer to Figma's built-in **Check Designs** tool rather than re-deriving that from scratch. If the user has already stated an exclusion ("skip remove cases, this table's read-only"), that always overrides whatever the variant would otherwise suggest.

## Coverage Vocabulary

Component names follow [component.gallery](https://component.gallery/components/)'s established taxonomy. Starting set, expand as new component types show up in real work:

| Component | Edge Cases to consider | Error Cases to consider |
|---|---|---|
| Table | Empty state (zero rows on first load); zero search/filter results; last item removed leaves empty state; pagination boundary (first/last page); long-text overflow/truncation | Load fails (network/server); search/filter/sort request fails |
| Form | All fields empty on load; max-length input reached; no permission to submit (disabled/hidden CTA) | Submission fails: validation (inline), duplicate entry, server error |
| Button | No-permission state (disabled or hidden, not clickable-then-blocked) | Action triggered by the button fails after click (e.g. an async action times out) |
| Dropdown menu | No options available for the current context; no-data-for-selection state | Options fail to load (async-populated dropdowns) |
| Modal | Opens with no data yet available (loading/empty state inside the modal); user dismisses/cancels mid-action and returns cleanly | Action inside the modal fails to submit/complete |

## Layering a PRD or Design Brief

When the user provides a PRD or design brief, treat it as additional context layered on top of the vocabulary table above, never as a replacement. A PRD surfaces product-specific business rules a generic checklist can't know (e.g. "only admins can remove a member"); the vocabulary table catches the structural cases a PRD rarely bothers to spell out (e.g. "what if the table is empty"). Run both together. If no PRD is provided, the vocabulary table alone is a complete, valid pass.

## Workflow

1. Identify the concept or Section being checked, and confirm it's ready to move from Option mode into Flow mode (see `/organize-design-file`).
2. Detect components in scope via Search Local Components; map each to a vocabulary category.
3. For each detected component, list its suggested Edge and Error cases, applying any user-stated exclusion and any Check Designs finding that rules an item out as inapplicable.
4. If a PRD or design brief was provided, layer its product-specific requirements alongside the vocabulary-derived list.
5. Present the combined suggestions grouped by component, framed as things to consider, not a checklist to complete, and note which frames (if any) already exist for each suggestion versus which are genuinely missing.

**Completion criterion:** every detected component in scope has its suggested Edge/Error coverage listed, cross-checked against what already exists in the file, with PRD-derived items layered in when a PRD was provided.
