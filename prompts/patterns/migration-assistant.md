# Migration Assistant Prompt

> Use this prompt to plan and execute a migration. Works well in combination with the `migration-assistant` subagent.

---

I need to migrate the following code from one technology/version to another.

**Provide context:**
- Current state: <current framework, language version, or pattern>
- Target state: <target framework, language version, or pattern>
- Scope: `#codebase` or `#file:<path>`
- Constraints: <what must not change, e.g., "public API must remain stable">

---

## Migration instructions

Use the `migration-assistant` subagent to:

1. **Assess scope** — how many files are affected and what patterns need to change
2. **Identify breaking changes** — differences between current and target state
3. **Produce a step-by-step plan** — ordered steps with before/after examples
4. **Recommend tooling** — automated codemods, linters, or scripts that can help
5. **Identify risks** — what could go wrong and how to mitigate it

---

## Execution approach

Once the plan is ready:

1. Review and approve the plan before any code changes.
2. Execute one step at a time.
3. Run tests after each step.
4. Commit after each verified step.
5. Do not proceed to the next step if tests fail.

---

## Output format

```
## Migration Plan: <current> → <target>

### Summary
<Scope, estimated effort, key risks>

### Steps
1. <Step 1: description + before/after example>
2. <Step 2: ...>

### Verification
<How to confirm the migration is complete and correct>
```
