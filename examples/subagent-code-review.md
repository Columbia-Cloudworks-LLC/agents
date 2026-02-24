# Example: Using Subagents for Code Review and Security Audit

This example demonstrates how to use the `code-auditor` subagent for a deep security review, with the main Copilot agent implementing the resulting fixes.

---

## Scenario

You have a Node.js Express API that handles user authentication. Before shipping to production, you want a security audit of the authentication module.

**Files involved:**
- `src/middleware/auth.ts` — JWT validation middleware
- `src/routes/users.ts` — User registration and login routes
- `src/services/authService.ts` — Core authentication logic

---

## Step 1: Invoke the code-auditor subagent

In Copilot Chat:

```
Use the code-auditor subagent to perform a security audit.

Files to audit:
- #file:src/middleware/auth.ts
- #file:src/routes/users.ts
- #file:src/services/authService.ts

Context:
- Node.js 20, Express.js 4, PostgreSQL
- Public-facing REST API
- JWT-based authentication

Audit scope:
- Injection vulnerabilities (SQL, command)
- Authentication and authorization controls
- Sensitive data exposure (hardcoded secrets, logging PII)
- Input validation
```

---

## Step 2: Review the Audit Report

The code-auditor returns a structured Audit Report. Example output:

```markdown
## Audit Report

**Files audited:** src/middleware/auth.ts, src/routes/users.ts, src/services/authService.ts
**Language/framework:** Node.js 20, Express.js 4, PostgreSQL
**Audited by:** code-auditor subagent

### Findings

| ID | Severity | File | Line | Category | Title | Remediation |
|----|----------|------|------|----------|-------|-------------|
| A1 | 🔴 Critical | authService.ts | 34 | Injection | Raw SQL in login query | Use parameterized queries |
| A2 | 🟠 High | authService.ts | 12 | Secrets | JWT secret hardcoded | Move to process.env.JWT_SECRET |
| A3 | 🟡 Medium | routes/users.ts | 67 | Validation | Email not validated | Use a validation library (e.g., zod) |
| A4 | 🟢 Low | middleware/auth.ts | 23 | Logging | Token logged on failure | Remove token from error logs |

### Summary
The most critical issue is a SQL injection vulnerability in the login query (A1) that
is directly exploitable. The hardcoded JWT secret (A2) must also be addressed before
deployment. The other issues should be fixed but are lower urgency.
```

---

## Step 3: Implement fixes

Tell Copilot to fix the issues in priority order:

```
Please fix finding A1 from the audit report: the SQL injection in src/services/authService.ts line 34.
Use parameterized queries.
```

Copilot implements the fix. Review it, then continue:

```
Now fix A2: move the JWT secret to process.env.JWT_SECRET with a fallback error if it's not set.
```

And so on for each finding.

---

## Step 4: Verify

After all fixes are implemented:

```
Please review #file:src/services/authService.ts one more time to confirm the SQL injection
and hardcoded secret have been properly addressed.
```

Then run your test suite to verify no regressions.

---

## Key takeaway

The subagent pattern separates **analysis** (done by the code-auditor) from **implementation** (done by the main agent). This keeps each phase focused and allows you to review findings before applying changes.
