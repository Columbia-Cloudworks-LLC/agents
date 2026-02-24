---
name: code-review
description: Structured code review skill that evaluates correctness, readability, security, and performance with clear severity ratings.
version: 1.0.0
author: Columbia Cloudworks
tags: [code-review, quality, security, readability, correctness, performance]
---

## Overview

This skill performs a structured, multi-dimensional code review. It evaluates code on four axes:

1. **Correctness** — Does the code work as intended?
2. **Readability** — Is the code easy to understand and maintain?
3. **Security** — Are there vulnerabilities or unsafe patterns?
4. **Performance** — Are there obvious inefficiencies?

Use this skill when asked to review a file, a pull request diff, or a code selection.

---

## Review process

### Step 1: Understand the intent
Before reviewing, determine:
- What is this code supposed to do?
- What language and framework is in use?
- What is the broader context (API endpoint, UI component, data pipeline, etc.)?

### Step 2: Correctness check
- Does the logic match the stated intent?
- Are there off-by-one errors, incorrect operators, or wrong data types?
- Are all error paths handled (null checks, exception handling, fallback values)?
- Are async operations correctly awaited? Are race conditions possible?
- Are external resources (files, connections) always closed/released?

### Step 3: Readability check
- Are names (variables, functions, classes) descriptive and unambiguous?
- Is there duplicated code that should be extracted into a shared helper?
- Are complex blocks explained with comments?
- Does the code follow a single-responsibility principle at the function level?
- Is the file organized logically (imports → types → helpers → main logic)?

### Step 4: Security check
- Is user input validated and sanitized before use?
- Are there SQL, command, path traversal, or template injection risks?
- Are secrets or credentials hardcoded anywhere?
- Are authentication and authorization checks present where required?
- Is sensitive data logged or returned in error responses?
- Are dependencies pinned to specific versions (supply chain)?

### Step 5: Performance check
- Are there N+1 query patterns (loop + database call)?
- Are expensive operations (parsing, compilation, network calls) repeated unnecessarily?
- Are large datasets loaded into memory when streaming would work?
- Are indexes or caches used where appropriate?

---

## Severity levels

| Severity | Icon | Meaning |
|----------|------|---------|
| Critical | 🔴 | Bug or vulnerability that must be fixed before merging |
| High | 🟠 | Serious issue that should be addressed |
| Medium | 🟡 | Issue that should be fixed but is not blocking |
| Low | 🟢 | Minor improvement suggestion |
| Info | ℹ️ | Observation or suggestion with no urgency |

---

## Output format

Always return a review in this format:

```markdown
## Code Review

**File:** <filename>
**Language:** <language>
**Reviewed by:** GitHub Copilot (code-review skill)

### Issues

| # | Severity | Line | Category | Description | Suggestion |
|---|----------|------|----------|-------------|------------|
| 1 | 🔴 Critical | 42 | Security | Raw SQL query with user input | Use parameterized queries |
| 2 | 🟡 Medium  | 17 | Readability | Variable named `x` is ambiguous | Rename to `userCount` |

### Strengths

- <What the code does well>

### Summary

<Overall assessment in 2–3 sentences. State whether the code is ready to merge, needs minor fixes, or requires significant rework.>
```

---

## Usage patterns

### Pattern 1: Review a file

> "Please use the code-review skill to review #file:src/auth.ts"

### Pattern 2: Review a selection

> "Review this function for security issues: #selection"

### Pattern 3: PR diff review

> "Review the changes in this diff for correctness and security: #git"

---

## Constraints

- Do not rewrite the code unless explicitly asked — only identify issues and suggest fixes.
- Focus on substantive issues. Do not nit-pick formatting if a linter already handles it.
- Always explain *why* something is an issue, not just *what* it is.
