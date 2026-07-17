# Andarwa Skills — Domain Language

## Language

**Skill**:
An agent skill package — a directory with SKILL.md following agentskills.io spec. Installed via skills.sh.

**Bucket**:
A category directory under skills/ that groups related skills by domain (e.g. obsidian, figma, productivity).

**Promoted bucket**:
A bucket whose skills are listed in the top-level README, have docs/ pages, and ship in the Claude Code plugin.

**SKILL.md**:
The root file of a skill. Contains YAML frontmatter (name, description) and the skill's instructions.

**Agent**:
The AI coding assistant that loads and runs skills (Claude Code, Codex, pi, etc.).

## Relationships

- A Skill lives in a Bucket.
- A Promoted bucket ships its skills in the plugin.
- A Skill's SKILL.md defines its triggers and behavior.

## Flagged ambiguities

- "Skill" can mean either the package or just the SKILL.md instructions — resolved: the skill is the directory; the instructions are the SKILL.md.
- "Plugin" can mean Claude Code plugin or an Obsidian plugin — resolved: qualify as "Claude Code plugin" or "Obsidian plugin" in context.
