#!/usr/bin/env bash
# .cursor/hooks/stop.sh
#
# Hook: stop
# Runs when a Cursor agent session ends.
#
# Behavior:
#   1. Runs a final lint pass on all staged files
#   2. Prints a summary of all files changed in this session
#   3. Creates a git checkpoint commit if there are staged changes
#
# This provides an automatic "save point" at the end of every agent session,
# making it easy to review and revert agent changes if needed.

set -euo pipefail

CHECKPOINT_PREFIX="[cursor-checkpoint]"

echo "[stop] Cursor session ending — running stop hook."

# ──────────────────────────────────────────────
# Step 1: Final lint pass on staged files
# ──────────────────────────────────────────────
run_final_lint() {
  echo "[stop] Running final lint..."

  if command -v eslint &>/dev/null; then
    STAGED_JS=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(js|ts|jsx|tsx)$' || true)
    if [[ -n "$STAGED_JS" ]]; then
      echo "$STAGED_JS" | xargs eslint --quiet && echo "[stop] ESLint passed."
    fi
  fi

  if command -v ruff &>/dev/null; then
    STAGED_PY=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.py$' || true)
    if [[ -n "$STAGED_PY" ]]; then
      echo "$STAGED_PY" | xargs ruff check --quiet && echo "[stop] ruff passed."
    fi
  fi
}

# ──────────────────────────────────────────────
# Step 2: Print session change summary
# ──────────────────────────────────────────────
print_summary() {
  echo ""
  echo "[stop] ── Session change summary ──"

  if git rev-parse --git-dir &>/dev/null; then
    STAGED=$(git diff --cached --name-status 2>/dev/null || true)
    if [[ -n "$STAGED" ]]; then
      echo "[stop] Staged changes:"
      echo "$STAGED" | while IFS= read -r line; do
        echo "  $line"
      done
    else
      echo "[stop] No staged changes."
    fi

    UNSTAGED=$(git diff --name-status 2>/dev/null || true)
    if [[ -n "$UNSTAGED" ]]; then
      echo "[stop] Unstaged changes:"
      echo "$UNSTAGED" | while IFS= read -r line; do
        echo "  $line"
      done
    fi
  else
    echo "[stop] Not a git repo — skipping summary."
  fi
  echo "[stop] ────────────────────────────"
  echo ""
}

# ──────────────────────────────────────────────
# Step 3: Create a checkpoint commit
# ──────────────────────────────────────────────
create_checkpoint() {
  if ! git rev-parse --git-dir &>/dev/null; then
    echo "[stop] Not a git repo — skipping checkpoint commit."
    return 0
  fi

  STAGED=$(git diff --cached --name-only 2>/dev/null || true)
  if [[ -z "$STAGED" ]]; then
    echo "[stop] Nothing staged — no checkpoint commit needed."
    return 0
  fi

  TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  COMMIT_MSG="${CHECKPOINT_PREFIX} ${TIMESTAMP}"

  git commit -m "$COMMIT_MSG" --no-verify
  echo "[stop] Checkpoint commit created: $COMMIT_MSG"
  echo "[stop] To undo: git reset HEAD~1 --soft"
}

run_final_lint
print_summary
create_checkpoint

echo "[stop] Done."
exit 0
