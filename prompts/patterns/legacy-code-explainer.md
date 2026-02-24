# Legacy Code Explainer Prompt

> Use this prompt to understand unfamiliar or legacy code before making changes.
> Always provide the file or selection for context.

---

Please explain the following legacy code to me.

**Context:**
- File: `#file:<path>` or paste code below
- Language/era: <e.g., "Python 2.7", "VBScript", "Windows batch 2005">
- What I know about it: <any context you have, or "nothing">

---

## Explanation instructions

Please provide:

### 1. High-level summary
What does this code do, in plain English? (2–4 sentences)

### 2. Section-by-section walkthrough
Walk through the code top-to-bottom, explaining each meaningful block.

### 3. Key patterns and idioms
Identify any language-specific patterns, idioms, or anti-patterns that a modern developer might not recognize. Explain what they do and whether they have modern equivalents.

### 4. Risks and gotchas
Identify any behavior that might be surprising, dangerous, or fragile:
- Implicit assumptions
- Global state modifications
- Platform dependencies
- Known pitfalls in the language version

### 5. Recommended approach for modification
If I need to modify this code, what should I be careful about? What parts are safe to change vs. risky to touch?
