#!/usr/bin/env bash
set -Eeuo pipefail

# Keep the historical entry point, but delegate to the single maintained
# implementation so flags and failure handling cannot drift between scripts.
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
exec python3 "$BASE_DIR/scripts/build.py" "$@"
