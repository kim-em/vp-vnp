#!/usr/bin/env bash
# Usage: compare.sh <checker> <export dir>
# Runs `<checker> --compare` (con-leche or con-ron) on <export dir>/Challenge.ndjson and
# <export dir>/Solution.ndjson, and requires it to accept with exactly the theorems of
# comparator.json justified by the solution.
set -euo pipefail
checker="$1"
dir="$2"
log="$(mktemp)"
ulimit -c 0
set +e
"$checker" --jobs="$(nproc)" --compare -- "$dir/Challenge.ndjson" "$dir/Solution.ndjson" 2>&1 | tee "$log"
status="${PIPESTATUS[0]}"
set -e
if [ "$status" -ne 0 ]; then
  echo "::error::$(basename "$checker") exited with status $status"
  exit 1
fi
n="$(jq '.theorem_names | length' comparator.json)"
if ! grep -E ": accepted .* $n axioms justified by the solution .*\(--verified\)$" "$log"; then
  echo "::error::no 'accepted ... $n axioms justified by the solution' line"
  exit 1
fi
diff <(jq -r '.theorem_names[]' comparator.json | sort) \
  <(sed -n -E 's/^[^ ]+: theorem ([^ ]+) justified by the solution$/\1/p' "$log" | sort) || {
  echo "::error::the justified theorems are not exactly those of comparator.json"
  exit 1
}
