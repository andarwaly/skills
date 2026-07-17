#!/bin/bash
# list-skills.sh — List all skills in the repo with their bucket and status

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Skills in andarwaly/skills"
echo "========================"

find "$REPO_DIR/skills" -name "SKILL.md" | sort | while read -r skill_md; do
    skill_dir="$(dirname "$skill_md")"
    skill_name="$(basename "$skill_dir")"
    bucket="$(basename "$(dirname "$skill_dir")")"
    name_line=$(head -5 "$skill_md" | grep "^name:" | sed 's/^name: *//' || echo "$skill_name")
    
    echo "  $bucket/$skill_name — $name_line"
done
