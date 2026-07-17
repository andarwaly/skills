#!/bin/bash
# link-skills.sh — Symlink skills into local agent harness directories
# Run after adding, removing, or renaming a skill.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Find all SKILL.md files under skills/ (exclude deprecated and in-progress)
find "$REPO_DIR/skills" -name "SKILL.md" | while read -r skill_md; do
    skill_dir="$(dirname "$skill_md")"
    skill_name="$(basename "$skill_dir")"
    bucket="$(basename "$(dirname "$skill_dir")")"
    
    # Skip non-promoted buckets
    if [ "$bucket" = "deprecated" ] || [ "$bucket" = "in-progress" ] || [ "$bucket" = "misc" ]; then
        continue
    fi
    
    echo "[skip] $bucket/$skill_name — symlinking disabled, install via npx skills add"
done

echo "Done. To install skills, run: npx skills add andarwaly/skills"
