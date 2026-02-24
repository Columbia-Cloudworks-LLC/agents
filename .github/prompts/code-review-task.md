---
name: code-review-task
description: Structured code review prompt — checks correctness, readability, security, and performance.
---

# Code Review Task

Use this prompt to request a structured code review. Provide the file or selection as context.

## Suggested usage

```
#prompt:code-review-task
#file:<path-to-file>
```

Or with a selection:

```
#prompt:code-review-task
Please review the following code: #selection
```

---

## Review instructions

You are performing a structured code review. Evaluate the provided code on the following criteria:

### 1. Correctness
- Does the code do what it claims to do?
- Are there off-by-one errors, incorrect conditionals, or unhandled edge cases?
- Are all error paths handled?

### 2. Readability
- Are variable and function names descriptive and consistent?
- Is the code adequately commented where logic is non-obvious?
- Is the code organized logically (single-responsibility, clear flow)?

### 3. Security
- Are there any injection vulnerabilities (SQL, command, path traversal)?
- Is input validated and sanitized before use?
- Are secrets or credentials ever hardcoded?
- Are permissions and access controls appropriate?

### 4. Performance
- Are there obvious inefficiencies (N+1 queries, unnecessary loops, redundant work)?
- Are expensive operations cached where appropriate?

### 5. Test coverage
- Does the code have adequate tests?
- Are edge cases covered?

---

## Output format

Return your review as:

```
## Code Review Summary

**File:** <filename>
**Reviewer:** GitHub Copilot

### Issues found

| # | Severity | Location | Description | Suggestion |
|---|----------|----------|-------------|------------|
| 1 | 🔴 High   | line X   | ...         | ...        |
| 2 | 🟡 Medium | line Y   | ...         | ...        |
| 3 | 🟢 Low    | line Z   | ...         | ...        |

### Overall assessment
<One paragraph summary with a recommended action>
```
