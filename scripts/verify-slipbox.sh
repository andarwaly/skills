#!/usr/bin/env bash
# Regression check for the slipbox skill family. Run after every task.
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

FAIL=0

echo "== idea.db schema smoke test =="
bash scripts/smoke-test-idea-db.sh || FAIL=1

echo "== SKILL.md frontmatter presence =="
for dir in skills/slipbox/*/; do
  skill="$dir/SKILL.md"
  name=$(basename "$dir")
  if [ ! -f "$skill" ]; then
    echo "FAIL: $skill missing"; FAIL=1; continue
  fi
  fm=$(awk '/^---$/{c++; next} c==1' "$skill")
  if ! echo "$fm" | grep -q '^name:'; then echo "FAIL: $name missing 'name:' in frontmatter"; FAIL=1; fi
  if ! echo "$fm" | grep -q '^description:'; then echo "FAIL: $name missing 'description:' in frontmatter"; FAIL=1; fi
done

echo "== evals.json validity (user-facing skills only, not 'discussion') =="
for dir in skills/slipbox/*/; do
  name=$(basename "$dir")
  [ "$name" == "discussion" ] && continue
  evals="$dir/evals/evals.json"
  if [ ! -f "$evals" ]; then
    echo "FAIL: $evals missing"; FAIL=1; continue
  fi
  if ! python3 -m json.tool < "$evals" > /dev/null 2>&1; then
    echo "FAIL: $evals is not valid JSON"; FAIL=1
  fi
done

echo "== plugin.json / bucket README consistency =="
if [ -f .claude-plugin/plugin.json ] && [ -f skills/slipbox/README.md ]; then
  plugin_slipbox=$(jq -r '.skills[] | select(startswith("./skills/slipbox/")) | ltrimstr("./skills/slipbox/")' .claude-plugin/plugin.json | sort)
  readme_slipbox=$(grep -oE '\[[a-z0-9-]+\]\(\./[a-z0-9-]+/\)' skills/slipbox/README.md | sed -E 's/.*\(\.\/([a-z0-9-]+)\/\)/\1/' | sort)
  if [ "$plugin_slipbox" != "$readme_slipbox" ]; then
    echo "FAIL: plugin.json slipbox skills and skills/slipbox/README.md skill list disagree"
    echo "  plugin.json: $(echo "$plugin_slipbox" | tr '\n' ' ')"
    echo "  README.md:   $(echo "$readme_slipbox" | tr '\n' ' ')"
    FAIL=1
  fi
fi

if [ "$FAIL" == "1" ]; then
  echo ""
  echo "verify-slipbox: FAILED"
  exit 1
fi
echo ""
echo "verify-slipbox: OK"
