# Example: Cursor Hooks Workflow

This example demonstrates how the Cursor hooks in `.cursor/` integrate into a typical development workflow.

---

## What the hooks do

| Hook | Trigger | Actions |
|------|---------|---------|
| `afterFileEdit` | Every time a file is saved in Cursor | Format → Lint → Stage in git |
| `stop` | When a Cursor agent session ends | Final lint → Print summary → Checkpoint commit |

---

## Setup

### Option A: Use hooks from this repo in your project

Copy (or symlink) the `.cursor/` directory into your project:

```bash
# Copy
cp -r .cursor /your-project/.cursor

# Or symlink (keeps in sync with this repo)
ln -s /path/to/agents/.cursor /your-project/.cursor
```

### Option B: Install hooks globally

Place the hooks in a shared location and symlink per project:

```bash
mkdir -p ~/.cursor-hooks
cp .cursor/hooks/after-edit.sh ~/.cursor-hooks/
cp .cursor/hooks/stop.sh ~/.cursor-hooks/

# In each project:
mkdir -p .cursor/hooks
ln -s ~/.cursor-hooks/after-edit.sh .cursor/hooks/after-edit.sh
ln -s ~/.cursor-hooks/stop.sh .cursor/hooks/stop.sh
```

---

## Walkthrough: afterFileEdit hook

**Scenario:** You're using Cursor to refactor a TypeScript file.

1. Cursor edits `src/services/userService.ts` and saves it.
2. `.cursor/hooks/after-edit.sh src/services/userService.ts` is automatically executed.
3. The script:
   - Detects the `.ts` extension
   - Runs `prettier --write` on the file (if installed)
   - Runs `eslint --quiet` on the file (if installed)
   - Runs `git add src/services/userService.ts`
4. The file is now formatted, linted, and staged — ready for review.

**Console output:**
```
[after-edit] Processing: src/services/userService.ts (.ts)
[after-edit] Formatted with prettier: src/services/userService.ts
[after-edit] ESLint passed: src/services/userService.ts
[after-edit] Staged: src/services/userService.ts
[after-edit] Done.
```

---

## Walkthrough: stop hook

**Scenario:** Your Cursor agent session finishes after making several changes.

1. The Cursor session ends (or you explicitly stop the agent).
2. `.cursor/hooks/stop.sh` is automatically executed.
3. The script:
   - Runs a final lint pass on all staged `.ts` files
   - Prints a summary of all staged and unstaged changes
   - Creates a git checkpoint commit: `[cursor-checkpoint] 2026-02-24T09:30:00Z`

**Console output:**
```
[stop] Cursor session ending — running stop hook.
[stop] Running final lint...
[stop] ESLint passed.

[stop] ── Session change summary ──
[stop] Staged changes:
  M  src/services/userService.ts
  M  src/routes/users.ts
  A  src/services/userService.test.ts
[stop] ────────────────────────────

[stop] Checkpoint commit created: [cursor-checkpoint] 2026-02-24T09:30:00Z
[stop] To undo: git reset HEAD~1 --soft
[stop] Done.
```

You now have a recoverable git checkpoint of everything the agent changed in this session.

---

## Customizing the hooks

### Add a new formatter

Edit `.cursor/hooks/after-edit.sh` and add a case for your file extension:

```bash
rs)
  if command -v rustfmt &>/dev/null; then
    rustfmt "$FILE"
    echo "[after-edit] Formatted with rustfmt: $FILE"
  fi
  ;;
```

### Disable the checkpoint commit

Comment out the `create_checkpoint` call at the bottom of `.cursor/hooks/stop.sh`:

```bash
run_final_lint
print_summary
# create_checkpoint  # disabled
```

### Add a new hook event

1. Add the script to `.cursor/hooks/my-hook.sh`
2. Register it in `.cursor/hooks.json`:

```json
"beforeFileEdit": {
  "description": "Runs before a file is edited.",
  "command": ".cursor/hooks/my-hook.sh",
  "args": ["${file}"],
  "timeout": 10,
  "continueOnError": true
}
```
