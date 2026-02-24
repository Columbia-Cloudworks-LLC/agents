---
name: docs-writer
description: Skill for writing and maintaining technical documentation including READMEs, API docs, inline comments, and Architecture Decision Records (ADRs).
version: 1.0.0
author: Columbia Cloudworks
tags: [documentation, readme, api-docs, adr, comments, technical-writing]
---

## Overview

This skill generates and maintains technical documentation. It covers:

- **README files** — project overview, quickstart, configuration reference
- **API documentation** — endpoint or function-level docs (JSDoc, docstrings, XML docs)
- **Inline code comments** — explaining non-obvious logic
- **Architecture Decision Records (ADRs)** — recording why decisions were made
- **"How to use this repo" guides** — onboarding documentation

Use this skill when asked to **write**, **update**, or **review** documentation.

---

## Conventions and constraints

### Language and tone
- Use clear, direct language. Avoid passive voice where possible.
- Write for the target audience: be explicit about the assumed knowledge level.
- Use present tense ("returns a user object", not "will return").
- Prefer short sentences and bullet points over long paragraphs.

### README structure
A good README follows this order:
1. **Title and one-line description**
2. **Badges** (build status, license, version) — optional
3. **Table of contents** — for documents longer than ~500 words
4. **Overview / What it does** — 2–4 sentences
5. **Prerequisites** — what must be installed or configured
6. **Quickstart** — the fastest way to get running
7. **Configuration** — environment variables, config files
8. **Usage** — common use cases with examples
9. **API reference** — if applicable
10. **Contributing** — link to `CONTRIBUTING.md`
11. **License**

### API documentation
For functions and classes, include:
- **Purpose** — one sentence describing what it does
- **Parameters** — name, type, whether required, default value
- **Return value** — type and description
- **Exceptions/errors** — what can go wrong and under what conditions
- **Example** — minimal working usage

**TypeScript/JavaScript (JSDoc):**
```js
/**
 * Authenticates a user and returns a signed JWT.
 *
 * @param {string} email - The user's email address.
 * @param {string} password - The user's plaintext password.
 * @returns {Promise<string>} A signed JWT token valid for 24 hours.
 * @throws {AuthenticationError} When credentials are invalid.
 */
async function login(email, password) { ... }
```

**Python (Google-style docstring):**
```python
def authenticate(email: str, password: str) -> str:
    """Authenticate a user and return a signed JWT.

    Args:
        email: The user's email address.
        password: The user's plaintext password.

    Returns:
        A signed JWT token valid for 24 hours.

    Raises:
        AuthenticationError: When credentials are invalid.
    """
```

### Inline comments
- Comment *why*, not *what*. The code shows what; the comment explains why.
- Bad: `// increment i` above `i++`
- Good: `// Skip the first element — it's always the schema version header`
- Mark known issues or technical debt: `// TODO: replace with async version once lib v3 ships`

### Architecture Decision Records (ADRs)
Use this template for ADRs in `docs/decisions/`:

```markdown
# ADR-NNNN: <Short title>

**Date:** YYYY-MM-DD
**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-XXXX

## Context
What is the situation that motivated this decision?

## Decision
What was decided?

## Consequences
What are the positive and negative consequences of this decision?
```

---

## Usage patterns

### Pattern 1: Write a README for a project

> "Write a README for #codebase — it's a Node.js REST API for managing user accounts."

### Pattern 2: Add JSDoc to a file

> "Add JSDoc comments to all exported functions in #file:src/userService.ts"

### Pattern 3: Create an ADR

> "Write an ADR for the decision to use PostgreSQL instead of MongoDB for this project."

### Pattern 4: Update existing docs

> "Update the README's configuration section to reflect the new environment variables in #file:.env.example"

---

## Output format

- Return documentation in Markdown unless the language requires a specific format (JSDoc, docstrings).
- For inline comments, return only the modified function or block, not the entire file, unless it's small.
- For ADRs, return the complete ADR file ready to save as `docs/decisions/ADR-NNNN-title.md`.
