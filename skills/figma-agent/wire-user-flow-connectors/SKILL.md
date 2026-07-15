---
name: wire-user-flow-connectors
description: Draw connector arrows between Figma frames to represent a user flow, cloning from an existing connector template and positioning per contextual-origin rules. Use when connecting screens in a user flow diagram, wiring frames together, or asked to "connect these screens", "add flow arrows", "wire up the flow", "draw connectors between these frames".
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

- **Contextual origin**: start from the specific UI element that triggers the transition (a button, dropdown, row, tab), not generically from the frame edge. A magnet on the parent frame carries no information about *what* triggers the flow.
- **Staggered spacing**: when multiple connectors exit the same source, use `{ endpointNodeId, position: { x, y } }` with distinct coordinates instead of a shared `magnet`, so lines never stack on top of each other.
- **Accessible-parent fallback**: when the trigger element is nested too deep to attach directly (inside a component instance), attach to the nearest accessible ancestor and use `position` coordinates calculated relative to it.
- **Magnets for simple sequences**: plain left-to-right, one-connector-per-edge steps within a row can use `magnet: "RIGHT"` → `magnet: "LEFT"`; reserve position-based endpoints for anything branching.
- **Cross-section links** originate only from Core Flow band frames (never Edge or Error, see `/organize-design-file`), and get the connector's `.name` and `.text.characters` set to describe the trigger (e.g. "via project name click") so the link stays traceable.

## Labels and Style

Both `.name` and `.text.characters` control the visible label. Set both together or they'll diverge. Clone inherits stroke, cap, and dash style from the template; restyle only if the user asks for a different treatment (e.g. dashed for a non-default route).

## Workflow

1. Confirm target frames are already positioned (run or defer to `/organize-design-file` first if not).
2. Find the template connector; stop and ask if none exists.
3. For each connection: clone, reassign both endpoints per the positioning rules, set label if applicable.
4. Present the full list of connections made before finalizing if more than a handful were created in one pass.

**Completion criterion:** every requested connection has a cloned connector with both `connectorStart` and `connectorEnd` reassigned away from the template's original endpoints, and every cross-section link is labeled.
