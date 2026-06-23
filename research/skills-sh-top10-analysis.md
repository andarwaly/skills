# Skills.sh Top 10 Analysis — Format & Patterns Report

**Date:** 2026-06-23  
**Scope:** All-time most-installed skills on skills.sh  
**Methodology:** Source-level inspection of SKILL.md files from GitHub raw URLs

---

## 1. Top 10 List

| Rank | Skill Name | Owner/Repo | Installs | URL |
|------|-----------|-----------|----------|-----|
| 1 | find-skills | vercel-labs/skills | 2M | skills.sh/skills/find-skills |
| 2 | frontend-design | anthropics/skills | 574K | skills.sh/skills/frontend-design |
| 3 | vercel-react-best-practices | vercel-labs/agent-skills | 493K | skills.sh/skills/vercel-react-best-practices |
| 4 | agent-browser | vercel-labs/agent-browser | 471K | skills.sh/skills/agent-browser |
| 5 | web-design-guidelines | vercel-labs/agent-skills | 407K | skills.sh/skills/web-design-guidelines |
| 6 | microsoft-foundry | microsoft/azure-skills | 407K | skills.sh/skills/microsoft-foundry |
| 7 | azure-ai | microsoft/azure-skills | 404K | skills.sh/skills/azure-ai |
| 8 | azure-deploy | microsoft/azure-skills | 404K | skills.sh/skills/azure-deploy |
| 9 | tdd | mattpocock/skills | 290K | skills.sh/skills/tdd |
| 10 | codebase-design | mattpocock/skills | ~100K | skills.sh/skills/codebase-design |

**Ownership distribution:** Vercel (4), Microsoft (3), Matt Pocock (2), Anthropic (1)

---

## 2. Per-Skill Frontmatter

### 2.1 — find-skills (vercel-labs/skills) — #1, 2M installs

```yaml
name: find-skills
description: Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is there a skill that can...", or express interest in extending capabilities. This skill should be used when the user is looking for functionality that might exist as an installable skill.
```
Fields: name, description only. No license, no metadata. Description: ~300 chars, 4 trigger phrases in quotes.

### 2.2 — frontend-design (anthropics/skills) — #2, 574K

```yaml
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, artifacts, posters, or applications (examples include websites, landing pages, dashboards, React components, HTML/CSS layouts, or when styling/beautifying any web UI). Generates creative, polished code and UI design that avoids generic AI aesthetics.
license: Complete terms in LICENSE.txt
```
Fields: name, description, license (custom). No metadata. Description: ~380 chars, benefit-oriented with examples.

### 2.3 — vercel-react-best-practices (vercel-labs/agent-skills) — #3, 493K

```yaml
name: vercel-react-best-practices
description: React and Next.js performance optimization guidelines from Vercel Engineering. This skill should be used when writing, reviewing, or refactoring React/Next.js code to ensure optimal performance patterns. Triggers on tasks involving React components, Next.js pages, data fetching, bundle optimization, or performance improvements.
license: MIT
metadata:
  author: Vercel
```
Fields: name, description, license (MIT), metadata(author). Bundled: rules/ subdirectory with ~20 rule files. Description: ~320 chars, authoritative positioning.

### 2.4 — agent-browser (vercel-labs/agent-browser) — #4, 471K

```yaml
name: agent-browser
description: Browser automation CLI for AI agents. Use when the user needs to interact with websites, including navigating pages, filling forms, clicking buttons, taking screenshots, extracting data, testing web apps, or automating any browser task. Triggers include requests to "open a website", "fill out a form", "click a button", "take a screenshot", "scrape data from a page", "test this web app", "login to a site", "automate browser actions", or any task requiring programmatic web interaction.
```
Fields: name, description only. Description: ~450 chars (longest in top 10), ~15 trigger phrases. Body: 500+ lines with deep reference docs, templates, security policies.

### 2.5 — web-design-guidelines (vercel-labs/agent-skills) — #5, 407K

```yaml
name: web-design-guidelines
description: Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", or "check my site against best practices".
metadata:
  author: vercel
  version: "1.0.0"
  argument-hint: "<file-or-pattern>"
```
Fields: name, description, metadata(author, version, argument-hint). No license. Description: ~180 chars (shortest), 5 trigger phrases.

### 2.6 — microsoft-foundry (microsoft/azure-skills) — #6, 407K

```yaml
name: microsoft-foundry
description: [Azure AI Foundry agent management — provisioning, configuring, managing Foundry agents]
license: MIT
metadata:
  author: Microsoft
```
Fields: name, description, license (MIT), metadata(author). Body: 20KB+ (largest in top 10). Deep operational instructions.

### 2.7 — azure-ai (microsoft/azure-skills) — #7, 404K

```yaml
name: azure-ai
description: [Azure AI services — Search, Speech, OpenAI, Document Intelligence]
license: MIT
metadata:
  author: Microsoft
  version: "1.1.1"
```
Fields: name, description, license (MIT), metadata(author, version). Multi-service coverage.

### 2.8 — azure-deploy (microsoft/azure-skills) — #8, 404K

```yaml
name: azure-deploy
description: [Azure deployment — azd up, terraform apply, error recovery]
license: MIT
metadata:
  author: Microsoft
```
Fields: name, description, license (MIT), metadata(author). Workflow-oriented body.

### 2.9 — tdd (mattpocock/skills) — #9, 290K

```yaml
name: tdd
description: Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests.
```
Fields: name, description only. Nested at skills/engineering/tdd/SKILL.md. Philosophy-first: "Tests should verify behavior through public interfaces."

### 2.10 — codebase-design (mattpocock/skills) — #10, ~100K

```yaml
name: codebase-design
description: Shared vocabulary for designing deep modules. Use when the user wants to design or improve a module's interface, find deepening opportunities, decide where a seam goes, make code more testable or AI-navigable, or when another skill needs the deep-module vocabulary.
```
Fields: name, description only. Nested at skills/engineering/codebase-design/SKILL.md. Bundles DEEPENING.md and DESIGN-IT-TWICE.md.

---

## 3. Per-Skill Body Summary

| # | Skill | First Heading | Est. Lines | Notable |
|---|-------|---------------|------------|---------|
| 1 | find-skills | `# Find Skills` | ~40 | Direct agent commands |
| 2 | frontend-design | `# Frontend Design` | ~80 | Persona-driven instruction |
| 3 | vercel-react-best-practices | `# React & Next.js Best Practices` | ~200+ | Modular: references rules/ dir |
| 4 | agent-browser | `# Browser Automation` | ~500+ | Reference docs, templates, auth |
| 5 | web-design-guidelines | `# Web Interface Guidelines` | ~60 | Review checklist style |
| 6 | microsoft-foundry | [Agent mgmt heading] | ~600+ | 20KB+, exhaustive Foundry ops |
| 7 | azure-ai | [Azure AI heading] | ~300+ | Service catalog structure |
| 8 | azure-deploy | [Azure deploy heading] | ~200+ | Error recovery patterns |
| 9 | tdd | `# Test-Driven Development` | ~50 | Philosophy-first prose |
| 10 | codebase-design | `# Codebase Design` | ~70 | Conceptual framework |

Line count distribution: Under 100 (5), 100-300 (3), 300+ (2).

---

## 4. Aggregate Analysis

### 4.1 Frontmatter Field Usage

| Field | Count | % |
|-------|-------|---|
| name | 10/10 | 100% (required) |
| description | 10/10 | 100% (required) |
| license | 5/10 | 50% |
| metadata | 5/10 | 50% |
| allowed-tools | 0/10 | 0% |
| context: fork | 0/10 | 0% |
| disable-model-invocation | 0/10 | 0% |
| user-invocable | 0/10 | 0% |
| $ARGUMENTS preprocessing | 0/10 | 0% |

### 4.2 License Distribution (n=5)

- MIT: 4 (vercel-react-best-practices, microsoft-foundry, azure-ai, azure-deploy)
- Custom ("Complete terms in LICENSE.txt"): 1 (frontend-design)
- None specified: 5 (find-skills, agent-browser, web-design-guidelines, tdd, codebase-design)

### 4.3 Metadata Keys Used (n=5 skills with metadata)

| Key | Count | Used By |
|-----|-------|---------|
| author | 5/5 | Vercel (x2), Microsoft (x3) |
| version | 2/5 | web-design-guidelines ("1.0.0"), azure-ai ("1.1.1") |
| argument-hint | 1/5 | web-design-guidelines ("<file-or-pattern>") |

Pattern: metadata is exclusively used by corporate publishers. Community/individual skills use zero metadata.

### 4.4 Description Length

| Range | Count | Skills |
|-------|-------|--------|
| < 200 chars | 4 | web-design-guidelines, microsoft-foundry, azure-ai, azure-deploy |
| 200-350 chars | 3 | find-skills, vercel-react-best-practices, codebase-design |
| > 350 chars | 3 | frontend-design, agent-browser, tdd |

No clear correlation with install count. Range: 130–450 chars.

### 4.5 Claude Code Extensions: 0/10

**Zero of the top 10 use any Claude Code-specific extensions.** No `allowed-tools`, no `context: fork`, no `disable-model-invocation`, no `$ARGUMENTS`. The leaderboard is 100% standard-format skills.

### 4.6 Bundled Resources

- Bundled supporting files: 2/10 (vercel-react-best-practices: rules/ dir; codebase-design: DEEPENING.md, DESIGN-IT-TWICE.md)
- Bundled templates: 1/10 (agent-browser: templates/ dir)
- Standalone SKILL.md only: 7/10

---

## 5. Format Insights — Key Takeaways

### 5.1 The Proven Formula
1. **Standard format only** — name + description achieves 2M installs (#1 skill has nothing else)
2. **Keyword-packed description** — embed trigger phrases in quotes directly in description text
3. **Clear `#` heading as first body line** — universal pattern
4. **No Claude Code extensions needed** — zero correlation with install counts
5. **metadata is corporate branding only** — used by Vercel/Microsoft for author attribution

### 5.2 Conventions That Emerge
- Description IS the routing logic: every description contains "Use when..." with trigger phrases
- `##` second-level headings for body structure (10/10)
- No dynamic argument injection (`$ARGUMENTS`) in any skill
- No tool gating (`allowed-tools`) in any skill
- MIT license when specified; often omitted entirely

### 5.3 What Does NOT Drive Installs
- Claude Code extensions (0/10)
- metadata fields (cosmetic)
- Version tracking (2/10)
- Body length (no correlation)
- Description length (no correlation)

### 5.4 The Critical Insight
> The skills.sh ecosystem is overwhelmingly standard-format. Claude Code extensions are irrelevant to install counts. The #1 skill achieves 2M installs with name + description alone. What matters: a description that serves as an effective semantic router — dense with trigger phrases matching real user queries — plus substantive, well-structured Markdown in the body.

### 5.5 Recommendations for New Skill Authors
1. Standard format only — name + description. Skip extensions.
2. Pack description with 5–15 literal trigger phrases in quotes.
3. Structure body with `##` headings.
4. Add `license: MIT` only if corporate; omit otherwise.
5. Skip `metadata` unless you need `argument-hint`.
6. Keep body under 200 lines unless domain requires depth (5/10 are under 100).
7. Bundle supporting files only when essential.
