---
name: organize-design-file
description: Lay out a Figma user-flow Section into its three bands (Core Flow, Edge Case, Error Case), positioning, coloring, and spacing frames per the flow-diagram convention. Use when scaffolding a new Section, arranging frames into a user flow, or asked to "organize this page", "set up the section", "arrange these frames into a flow", "lay out this user flow".
---

# Organize Design File

A Section is three fixed bands, stacked top to bottom, never interleaved: Core Flow, Edge Case, Error Case. Everything below exists to place frames correctly within that stack.

## The Bands

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

## Workflow

1. If frame/section names don't already match the naming chain, or two sibling frames share the same name, offer to run `/rename-design-frame` first, and wait for approval before invoking it. Never chain silently.
2. Classify each frame into its band (Core Flow / Edge Case / Error Case) based on what it represents. If a frame's band is genuinely unclear (e.g. it could plausibly be a Core Flow variant or an Edge Case), ask rather than guess: a wrong classification here misplaces the frame, mis-colors it, and produces a wrong name in `/rename-design-frame`.
3. Position Core Flow frames as a diagonal-cascade sequence per the rules above; position Edge/Error frames as flat, wrapped, clustered collections.
4. Create/assign Subsections for Edge Cases, Error Cases, and any nested Core Flow branches.
5. Apply band fill colors and section/frame typography per the tables above.
6. Once layout is complete, offer to run `/wire-user-flow-connectors` to draw connections between the now-positioned frames, and wait for approval.

**Completion criterion:** every frame in scope is assigned to the correct band, positioned per its band's rule, colored per its band, and every Edge/Error frame sits inside its named Subsection.
