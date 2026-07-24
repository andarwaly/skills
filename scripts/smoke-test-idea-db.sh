#!/usr/bin/env bash
# Applies skills/slipbox/setup-slipbox/assets/schema.sql to a throwaway DB
# and checks the expected tables/views/triggers/indexes exist.
set -euo pipefail

SCHEMA="skills/slipbox/setup-slipbox/assets/schema.sql"
if [ ! -f "$SCHEMA" ]; then
  echo "SKIP: $SCHEMA not created yet"
  exit 0
fi

TMPDB="$(mktemp -t idea-db-smoketest).db"
trap 'rm -f "$TMPDB"' EXIT

sqlite3 "$TMPDB" < "$SCHEMA"

EXPECTED_TABLES="seeds evergreen links"
EXPECTED_VIEWS="stale_seeds"
EXPECTED_TRIGGERS="trg_seeds_updated_at trg_evergreen_updated_at"
EXPECTED_INDEXES="idx_seeds_resource idx_seeds_target_status idx_evergreen_status idx_links_source idx_links_target"

FAIL=0

for t in $EXPECTED_TABLES; do
  n=$(sqlite3 "$TMPDB" "SELECT count(*) FROM sqlite_master WHERE type='table' AND name='$t';")
  if [ "$n" != "1" ]; then echo "FAIL: table $t missing"; FAIL=1; fi
done

for v in $EXPECTED_VIEWS; do
  n=$(sqlite3 "$TMPDB" "SELECT count(*) FROM sqlite_master WHERE type='view' AND name='$v';")
  if [ "$n" != "1" ]; then echo "FAIL: view $v missing"; FAIL=1; fi
done

for tr in $EXPECTED_TRIGGERS; do
  n=$(sqlite3 "$TMPDB" "SELECT count(*) FROM sqlite_master WHERE type='trigger' AND name='$tr';")
  if [ "$n" != "1" ]; then echo "FAIL: trigger $tr missing"; FAIL=1; fi
done

for idx in $EXPECTED_INDEXES; do
  n=$(sqlite3 "$TMPDB" "SELECT count(*) FROM sqlite_master WHERE type='index' AND name='$idx';")
  if [ "$n" != "1" ]; then echo "FAIL: index $idx missing"; FAIL=1; fi
done

# Round-trip: insert a raw seed row, flip it to literature, confirm it's still one row.
sqlite3 "$TMPDB" "INSERT INTO seeds (slug, resource, type, target_type, status, origin, reason) VALUES ('smoketest-seed', 'smoketest-resource', 'raw', 'literature', 'to-discuss', 'surface', 'smoke test reason');"
sqlite3 "$TMPDB" "UPDATE seeds SET type='literature', status='discussed', note_path='literature/smoketest.md', slug='smoketest-final' WHERE slug='smoketest-seed';"
n=$(sqlite3 "$TMPDB" "SELECT count(*) FROM seeds WHERE slug='smoketest-final';")
if [ "$n" != "1" ]; then echo "FAIL: raw->literature rename-in-place round-trip broke"; FAIL=1; fi
n=$(sqlite3 "$TMPDB" "SELECT count(*) FROM seeds;")
if [ "$n" != "1" ]; then echo "FAIL: expected exactly 1 row after rename-in-place, got $n"; FAIL=1; fi

# Trigger check: updated_at must change on UPDATE.
before=$(sqlite3 "$TMPDB" "SELECT updated_at FROM seeds WHERE slug='smoketest-final';")
sleep 1
sqlite3 "$TMPDB" "UPDATE seeds SET status='dismissed' WHERE slug='smoketest-final';"
after=$(sqlite3 "$TMPDB" "SELECT updated_at FROM seeds WHERE slug='smoketest-final';")
if [ "$before" == "$after" ]; then echo "FAIL: trg_seeds_updated_at did not bump updated_at"; FAIL=1; fi

if [ "$FAIL" == "1" ]; then
  echo "smoke-test-idea-db: FAILED"
  exit 1
fi
echo "smoke-test-idea-db: OK"
