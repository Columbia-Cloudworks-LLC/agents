# Code Review Prompt

> Copy this prompt into Copilot Chat or use `#prompt:code-review-task` if saved in `.github/prompts/`.

---

Please perform a structured code review of the following code.

**Provide context:**
- File: `#file:<path>` or paste code below
- Language/framework: <language>
- What this code does: <brief description>

---

## Review criteria

Evaluate the code on:

### Correctness
- Does the logic match the intent?
- Are error paths handled?
- Are there race conditions or resource leaks?

### Readability
- Are names descriptive?
- Is the code well-organized?
- Are complex sections documented?

### Security
- Is user input validated?
- Are there injection risks?
- Are secrets ever hardcoded?

### Performance
- Are there obvious inefficiencies?
- Is memory used appropriately?

---

## Output format

```
## Code Review

| # | Severity | Line | Category | Issue | Suggestion |
|---|----------|------|----------|-------|------------|

### Summary
<Overall assessment and recommendation>
```
