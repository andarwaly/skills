---
name: wire-user-flow-connectors
description: Draw connector arrows between Figma frames to represent a user flow, cloning from an existing connector template and positioning per the sequential, element-triggered, or branch-cascade attachment rules. Use when connecting screens in a user flow diagram, wiring frames together, or asked to "connect these screens", "add flow arrows", "wire up the flow", "draw connectors between these frames", "connect this branch to the flow".
---

# Wire User Flow Connectors

Figma Design files cannot create a connector from scratch. Every new arrow starts from **the template**: find an existing `CONNECTOR` node, clone it, then re-point both ends. Everything below governs where those ends land.

## Find the Template

Search first for a `SECTION` named **`Flow Guideline`**: it holds the connector template(s) and any project-specific convention notes. Look there before searching the rest of the file.

```js
let template = null;
for (const page of figma.root.children) {
  const guideline = page.findOne(n => n.type === "SECTION" && n.name === "Flow Guideline");
  if (guideline) {
    template = guideline.findOne(n => n.type === "CONNECTOR");
    if (template) break;
  }
}
if (!template) {
  // Flow Guideline not found or empty, fall back to any connector in the file
  for (const page of figma.root.children) {
    const found = page.findOne(n => n.type === "CONNECTOR");
    if (found) { template = found; break; }
  }
}
```

If no template exists anywhere in the file, stop and tell the user. Do not proceed without one.

## Clone and Re-attach

```js
const clone = template.clone();
clone.connectorStart = { endpointNodeId: nodeA.id, magnet: "AUTO" };
clone.connectorEnd = { endpointNodeId: nodeB.id, magnet: "AUTO" };
```

A clone inherits its template's endpoints. Both `connectorStart` and `connectorEnd` must be explicitly reassigned, or the clone overlaps the original invisibly.

## Positioning Rules

Three distinct connector purposes, each with its own attachment rule. Identify which one applies before wiring, a rule from the wrong case is the most common way a connector ends up floating disconnected from the frames it's meant to link.

**1. Sequential**: plain left-to-right steps within one row (e.g. `Edit → Edit - Changed → Edit - Updated`). One connector per frame edge, so a shared magnet is unambiguous:

- `magnet: "RIGHT"` on the origin, `magnet: "LEFT"` on the target.

**2. Element-triggered**: one specific UI element causes the transition (a button click opens a modal, a dropdown selection changes state). There is a real, singular trigger, so attach there, not to the frame's generic edge:

- **Contextual origin**: start from the specific element that triggers the transition (a button, dropdown, row, tab). A magnet on the parent frame carries no information about *what* triggers the flow.
- **Accessible-parent fallback**: when the trigger element is nested too deep to attach directly (inside a component instance), attach to the nearest accessible ancestor and use `position` coordinates calculated relative to it.

**3. Branch-cascade**: a whole row forks off another row (`organize-design-file`'s diagonal-cascade branches). There is no single triggering element for an entire row, it's a structural relationship between two rows, not one user action, so element-hunting is the wrong move here. Attach frame-to-frame instead:

- **Specific forking frame, not always the row's first frame**: identify the exact frame within the parent row that this branch forks from, per the diagonal-cascade rule (a fork originates from the step directly above-left of it, which may be mid-row, not necessarily that row's first frame). Attach the connector's start there, `magnet: "RIGHT"` (or `"AUTO"` if the fork lands below rather than beside it).
- **Target is the branch row's first frame**, `magnet: "LEFT"`.
- **Fan-out staggering**: when one origin frame is the fork point for *multiple* branch rows (a single Section origin commonly forks into several branches at once), a shared `magnet: "RIGHT"` stacks every connector at the same point. Use `{ endpointNodeId, position: { x, y } }` on the origin instead, with a distinct `y` per branch, so each line visibly departs from a different point along the origin's edge.
- This rule applies recursively: a nested branch (a row-level action only reachable from within a parent row, e.g. a "more menu" action) is wired the same way, from its specific originating frame to its own branch row's first frame, regardless of nesting depth.

## Shared Rule

- **Cross-section links** originate only from Core Flow band frames (never Edge or Error, see `/organize-design-file`), and get the connector's `.name` and `.text.characters` set to describe the trigger (e.g. "via project name click") so the link stays traceable.

## Labels and Style

Both `.name` and `.text.characters` control the visible label. Set both together or they'll diverge. Clone inherits stroke, cap, and dash style from the template; restyle only if the user asks for a different treatment (e.g. dashed for a non-default route).

## Workflow

1. Confirm target frames are already positioned (run or defer to `/organize-design-file` first if not).
2. Find the template connector; stop and ask if none exists.
3. For each connection: clone, reassign both endpoints per the positioning rules, set label if applicable.
4. Present the full list of connections made before finalizing if more than a handful were created in one pass.

**Completion criterion:** every requested connection has a cloned connector with both `connectorStart` and `connectorEnd` reassigned away from the template's original endpoints, and every cross-section link is labeled.
