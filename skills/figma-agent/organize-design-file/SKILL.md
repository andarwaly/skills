---
name: organize-design-file
description: Lay out a Figma page, either as a user-flow Section with its three bands (Core Flow, Edge Case, Error Case) or as grouped design-exploration options. Use when scaffolding a new Section, arranging frames into a user flow, organizing scattered exploration variants, or asked to "organize this page", "set up the section", "arrange these frames into a flow", "lay out this user flow", "group these design options".
---

# Organize Design File

Two modes, chosen by what the frames actually represent, never mixed within one Section:

- **Flow mode**: a completed or in-progress user flow. Three fixed bands, stacked top to bottom, never interleaved: Core Flow, Edge Case, Error Case.
- **Option mode**: design-exploration variants of one feature or screen, no flow between them, just parallel alternatives (A, B, C...) sitting side by side.

Determine the mode before doing anything else: if the frames represent steps a user takes and outcomes that follow, it's Flow mode; if they represent different takes on the same screen with no sequence between them, it's Option mode. If genuinely unclear, ask.

## Flow Mode: The Bands

- **Core Flow** (top): a sequence, not a row. Left→right = step order. A fork/branch off a step cascades diagonally down-and-right, offset **+300px** from the origin frame's left edge, one new row per branch depth. The Section's overall width is set by the Core Flow band alone; nothing else widens it.
- **Edge Case** (middle): a flat collection, not sequenced. Frames wrap to a new row once they hit the width the Core Flow band already set. Order within the band carries no meaning; group frames from the same originating branch close together instead (see Frame Spacing below).
- **Error Case** (bottom): same flat-collection treatment as Edge Case.

Cross-section links (a Core Flow step's success state leading into a different Section) originate only from Core Flow band frames, never Edge or Error, since those aren't completed, shareable success states.

## Frame Spacing

The two 300px entries below are unrelated conventions that happen to share a number: one is a Core Flow branch offset, the other is a flat-band frame gap. Don't conflate them.

| Gap | Value | When |
|---|---|---|
| Section boundary padding | 240px | Section edge to first frame/header, all sides |
| Header → first frame row | 360px | Below Title/Subtitle, before the first frame-title label |
| Inter-band gap | 240px | Core Flow → Edge Case, Edge Case → Error Case |
| Core Flow branch offset | 300px | Diagonal-cascade horizontal offset, per branch depth (see The Bands above) |
| Flat-band frame-to-frame, same context | 300px | Two Edge/Error frames from the same originating branch |
| Flat-band frame-to-frame, different context | 600px | Two adjacent Edge/Error frames from different originating branches; the doubled gap signals the cluster break |

## Subsections

A Subsection is a named Figma `SECTION` nested inside the parent Section, used for `Edge Cases`, `Error Cases`, and nested Core Flow branches (e.g. a row-level action only reachable from within a parent view). It groups frames physically; the frame's own name still carries the full ancestor chain (see `/rename-design-frame`).

## Color

Band-differentiated fill, not per-Section: a fixed three-color OKLCH triad, same lightness/chroma, hue is the only variable, kept darker than the canvas (`#1E1E1E`) so frames read as what pops, not the section bounds:

| Band | OKLCH | Hex (approx.) |
|---|---|---|
| Core Flow | `oklch(0.14 0.02 240)` | `#0D1216` |
| Edge Case | `oklch(0.14 0.03 320)` | `#180F17` |
| Error Case | `oklch(0.14 0.035 25)` | `#1B0D08` |

## Typography

All text white.

| Layer | Font | Size |
|---|---|---|
| Section Title | Kalam Bold, Capitalize | 160px |
| Subtitle | Inter Regular | 96px |
| Frame label (`#<Frame Name>`) | Kalam Bold, Capitalize, −2.25px tracking | 72px |

Frame label sits 160px above its frame's top edge, left-aligned to the frame, width matched to the frame's own width (wraps on narrow/mobile frames; expected, not an error).

## Option Mode

Exploration work is typically scattered with no Sections at all, duplicated-and-edited frames sitting near each other by coincidence of how the work happened, not by any reliable grouping. Never infer groupings from physical proximity alone, confirm with the user first.

**Two entry paths:**

- **Explicit**: the user selects or names the frames and states what feature/screen they're variants of. Use that grouping directly.
- **Discovery**: the user asks to organize the whole page with nothing pointed out. Scan every top-level frame via `evaluate_script`, cluster candidates by similarity (matching layer structure, component instances, near-identical dimensions/content suggest one frame duplicated into variants), then present the proposed groups in plain language (e.g. "I see what looks like 3 variants of Cycle List, 2 of Overview, does this match?") and wait for confirmation before creating anything.

**Structure**, once a grouping is confirmed:

- One Subsection per feature/screen being explored. A feature with many variants can share one Subsection (e.g. `Employee - Cycle List B & C`) or get its own (e.g. `Employee - Cycle List A`); either is fine, group by what reads clearly, not by a fixed count.
- Frames inside are named `<Section> - <Feature> - <OptionLetter>` (e.g. `360 - Cycle List - A`), chaining to `/rename-design-frame` for the actual rename.
- Frames sit flat, side by side, no cascade, no sequence. Use the same 300px frame-to-frame gap as Flow mode's same-context spacing.
- No band colors and no Title/Subtitle header are required; apply them only if the user asks for the same visual treatment as a Flow-mode Section.
- Never offer `/wire-user-flow-connectors` in Option mode. Design options aren't a flow and have nothing to connect.

## Workflow

1. Determine the mode (Flow or Option) per the rule at the top of this file. Ask if unclear.
2. If frame/section names don't already match the naming chain, or two sibling frames share the same name, offer to run `/rename-design-frame` first, and wait for approval before invoking it. Never chain silently.
3. **Flow mode:** classify each frame into its band (Core Flow / Edge Case / Error Case) based on what it represents. If a frame's band is genuinely unclear (e.g. it could plausibly be a Core Flow variant or an Edge Case), ask rather than guess: a wrong classification here misplaces the frame, mis-colors it, and produces a wrong name in `/rename-design-frame`. **Option mode:** confirm the frame grouping per the entry paths above before proceeding.
4. **Flow mode:** position Core Flow frames as a diagonal-cascade sequence per the rules above; position Edge/Error frames as flat, wrapped, clustered collections. **Option mode:** position each group's frames flat, side by side.
5. **Flow mode:** create/assign Subsections for Edge Cases, Error Cases, and any nested Core Flow branches. **Option mode:** create/assign one Subsection per confirmed feature group.
6. **Flow mode only:** apply band fill colors and section/frame typography per the tables above.
7. **Flow mode only:** once layout is complete, offer to run `/wire-user-flow-connectors` to draw connections between the now-positioned frames, and wait for approval.

**Completion criterion:** every frame in scope is assigned to the correct band or option group, positioned per its mode's rule, and (Flow mode) colored per its band with every Edge/Error frame inside its named Subsection, or (Option mode) grouped inside its confirmed, named Subsection.
