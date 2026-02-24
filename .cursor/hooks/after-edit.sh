#!/usr/bin/env bash
# .cursor/hooks/after-edit.sh
#
# Hook: afterFileEdit
# Runs after a file is saved in Cursor.
#
# Arguments:
#   $1 - Absolute path to the file that was edited
#
# Behavior:
#   1. Detects the file type and runs an appropriate formatter
#   2. Runs a quick lint check if a linter is available
#   3. Stages the file in git (so the agent's changes are tracked)
#
# To disable any step, comment out the relevant section below.

set -euo pipefail

FILE="${1:-}"

if [[ -z "$FILE" ]]; then
  echo "[after-edit] No file provided, skipping." >&2
  exit 0
fi

if [[ ! -f "$FILE" ]]; then
  echo "[after-edit] File not found: $FILE" >&2
  exit 0
fi

EXT="${FILE##*.}"

echo "[after-edit] Processing: $FILE (.$EXT)"

# ──────────────────────────────────────────────
# Step 1: Format the file
# ──────────────────────────────────────────────
format_file() {
  case "$EXT" in
    js|ts|jsx|tsx|json|css|html|md)
      if command -v prettier &>/dev/null; then
        prettier --write --log-level warn "$FILE"
        echo "[after-edit] Formatted with prettier: $FILE"
      fi
      ;;
    py)
      if command -v black &>/dev/null; then
        black --quiet "$FILE"
        echo "[after-edit] Formatted with black: $FILE"
      fi
      ;;
    go)
      if command -v gofmt &>/dev/null; then
        gofmt -w "$FILE"
        echo "[after-edit] Formatted with gofmt: $FILE"
      fi
      ;;
    sh|bash)
      if command -v shfmt &>/dev/null; then
        shfmt -w "$FILE"
        echo "[after-edit] Formatted with shfmt: $FILE"
      fi
      ;;
    *)
      echo "[after-edit] No formatter configured for .$EXT, skipping format."
      ;;
  esac
}

# ──────────────────────────────────────────────
# Step 2: Quick lint
# ──────────────────────────────────────────────
lint_file() {
  case "$EXT" in
    js|ts|jsx|tsx)
      if command -v eslint &>/dev/null; then
        eslint --quiet "$FILE" && echo "[after-edit] ESLint passed: $FILE"
      fi
      ;;
    py)
      if command -v ruff &>/dev/null; then
        ruff check --quiet "$FILE" && echo "[after-edit] ruff passed: $FILE"
      fi
      ;;
    sh|bash)
      if command -v shellcheck &>/dev/null; then
        shellcheck "$FILE" && echo "[after-edit] shellcheck passed: $FILE"
      fi
      ;;
    *)
      echo "[after-edit] No linter configured for .$EXT, skipping lint."
      ;;
  esac
}

# ──────────────────────────────────────────────
# Step 3: Stage the file in git
# ──────────────────────────────────────────────
stage_file() {
  if git rev-parse --git-dir &>/dev/null; then
    git add "$FILE"
    echo "[after-edit] Staged: $FILE"
  else
    echo "[after-edit] Not a git repo, skipping stage."
  fi
}

format_file
lint_file
stage_file

echo "[after-edit] Done."
exit 0
