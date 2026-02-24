---
name: refactor-task
description: Refactoring prompt — restructures code for clarity, maintainability, and correctness without changing behavior.
---

# Refactor Task

Use this prompt to request a focused refactoring of a file or code selection. Always provide context.

## Suggested usage

```
#prompt:refactor-task
#file:<path-to-file>
Goal: <describe the refactoring goal, e.g. "extract the authentication logic into a separate module">
```

---

## Refactoring instructions

You are performing a targeted refactoring. Follow these rules:

1. **Preserve behavior.** Do not change what the code does — only how it does it.
2. **Make minimal changes.** Change as little as possible to achieve the stated goal.
3. **One concern per change.** Tackle one refactoring objective at a time.
4. **Explain each change.** For every non-trivial modification, add a brief inline comment or note.
5. **Keep tests green.** If tests exist, ensure the refactored code still passes them.

### Common refactoring goals

| Goal | Description |
|------|-------------|
| Extract function/method | Move a block of logic into a named function |
| Rename for clarity | Give variables, functions, or classes better names |
| Remove duplication | Consolidate repeated logic into a shared helper |
| Simplify conditionals | Replace nested if/else with guard clauses or early returns |
| Introduce constants | Replace magic numbers/strings with named constants |
| Split large file | Break a monolithic file into smaller, focused modules |
| Improve error handling | Replace silent failures with explicit error propagation |

---

## Output format

Return:

1. The refactored code block (full file or relevant section).
2. A short **Change log** listing each change made:

```
## Refactoring Change Log

- **Extracted** `validateUser()` from lines 45–67 into a standalone function
- **Renamed** `x` → `userCount` for clarity
- **Replaced** magic number `86400` with constant `SECONDS_PER_DAY`
```
