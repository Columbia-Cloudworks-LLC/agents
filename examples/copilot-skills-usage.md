# Example: Using Copilot Skills and Prompts in VS Code

This example walks through common workflows using the skills and prompts in this repository with GitHub Copilot in VS Code.

---

## Prerequisites

- VS Code with the GitHub Copilot extension installed and signed in
- This repository cloned locally (or the `.github/` and `skills/` directories copied into your project)

---

## Workflow 1: Review code with the code-review skill

1. Open a file you want reviewed, e.g., `src/auth.ts`
2. Open Copilot Chat (`Ctrl+Alt+I` / `Cmd+Alt+I`)
3. Type:
   ```
   @workspace Please use the skills/code-review skill to review #file:src/auth.ts
   ```
4. Copilot reads `skills/code-review/SKILL.md` and applies the structured review criteria.
5. You receive a formatted table of issues with severity ratings and suggestions.

**Alternative — using a prompt file:**
```
#prompt:code-review-task
#file:src/auth.ts
Language: TypeScript, Express.js
What this code does: Handles user login and JWT issuance
```

---

## Workflow 2: Generate tests for a function

1. Open the source file, e.g., `src/services/userService.ts`
2. Highlight the function you want tested (optional)
3. In Copilot Chat:
   ```
   #prompt:test-generation-task
   #file:src/services/userService.ts
   ```
4. Copilot generates a complete Jest test file following the project's existing conventions.
5. Save the output as `src/services/userService.test.ts`

---

## Workflow 3: Explain a legacy Windows batch script

1. Open the batch file, e.g., `scripts/deploy.bat`
2. In Copilot Chat:
   ```
   @workspace Please use the skills/windows-batch skill to explain #file:scripts/deploy.bat
   ```
3. Copilot reads the Windows Batch skill, walks through the script, and explains each section.
4. You can then ask: "Refactor this script to use modern NT-style best practices."

---

## Workflow 4: Invoke the code-auditor subagent

1. In Copilot Chat:
   ```
   Use the code-auditor subagent to audit #file:src/api/users.ts for security vulnerabilities.
   Context: public-facing REST API, Node.js + Express + PostgreSQL.
   Focus on: injection, authentication, and sensitive data exposure.
   ```
2. Copilot delegates the analysis to the code-auditor (as described in `subagents/code-auditor/AGENT.md`).
3. The subagent returns a structured Audit Report.
4. Tell Copilot: "Fix the Critical and High severity issues from the audit report."

---

## Workflow 5: Refactor a file

1. Open the file to refactor, e.g., `src/controllers/orderController.ts`
2. In Copilot Chat:
   ```
   #prompt:refactor-task
   #file:src/controllers/orderController.ts
   Goal: Extract the validation logic into a separate validateOrder() function
   Constraints: Do not change the function signatures or return types
   ```
3. Copilot returns the refactored code and a change log.

---

## Tips

- Use `#file:` to reference any file in your workspace.
- Use `#selection` to reference the currently highlighted code.
- Use `#codebase` to give Copilot broad context about the whole project.
- Use `#git` to reference recent git changes.
- Combine selectors: `#prompt:code-review-task #file:src/auth.ts #git`
