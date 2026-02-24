# Refactor Prompt

> Copy this prompt into Copilot Chat or use `#prompt:refactor-task` if saved in `.github/prompts/`.

---

Please refactor the following code.

**Provide context:**
- File: `#file:<path>` or paste code below
- Refactoring goal: <describe what you want to achieve>
- Constraints: <what must not change, e.g., "API contracts must remain the same">

---

## Instructions

1. **Preserve behavior.** Do not change what the code does — only how it does it.
2. **Make minimal changes.** Change only what is necessary to achieve the stated goal.
3. **Explain each change.** Provide a change log at the end.
4. **Keep tests green.** If tests exist, the refactored code must still pass them.

### Common refactoring goals

| Goal | When to use |
|------|-------------|
| Extract function | Logic block is reused or too long |
| Rename for clarity | Variable/function names are ambiguous |
| Remove duplication | Same logic exists in multiple places |
| Simplify conditionals | Nested if/else can be replaced with guard clauses |
| Introduce constants | Magic numbers/strings should be named |
| Split module | File is too large and has multiple responsibilities |
| Improve error handling | Errors are silently swallowed or poorly reported |

---

## Output format

1. Refactored code block
2. Change log:

```
## Refactoring Change Log
- Extracted `validateInput()` from lines 30–45
- Renamed `d` → `durationMs`
- Replaced magic number `3600` with constant `SECONDS_PER_HOUR`
```
