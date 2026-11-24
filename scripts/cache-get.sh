#!/usr/bin/env bash
# `lake exe cache get`: fetch Mathlib's .olean files, then this project's, for the current
# revision (or the nearest ancestor with a published build). Afterwards `lake build --no-build`
# should report that everything is up to date.
set -euo pipefail
if [[ "$#" != 1 || "$1" != get ]]; then
  echo 'Usage: lake exe cache get' >&2
  exit 2
fi
cd "$(dirname -- "${BASH_SOURCE[0]}")/.."

# This package's `cache` executable shadows Mathlib's, so name Mathlib's explicitly.
lake exe mathlib/cache get

# The cache services are configured in lakefile.toml, which Lake reads as its system
# configuration when LAKE_CONFIG points at it. The artifact cache must be on, and must copy
# the downloaded files into .lake/build, for `lake build` to find them.
export LAKE_CONFIG="$PWD/lakefile.toml"
export LAKE_CACHE_DIR="$PWD/.lake/cache"
export LAKE_ARTIFACT_CACHE=true
export LAKE_RESTORE_ARTIFACTS=true
if ! lake cache get --package=vp-vnp; then
  echo 'No published build of this project was found for this revision or its ancestors;' >&2
  echo 'build it with `lake build`.' >&2
  exit 1
fi
lake build --no-build
