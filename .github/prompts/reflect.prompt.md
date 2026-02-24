---
name: reflect
description: Reflect on the conversation and identify skill improvements needed
---

## Step 1 — Inventory skills used

List every skill loaded during this conversation (by name and file path from `AGENTS.md`). For each one, state:
- **Triggered correctly?** Was the activation appropriate, or did it fire when it shouldn't have (or fail to fire when it should have)?
- **Accurate?** Did the skill's guidance produce correct, working output, or did it lead to errors, corrections, or contradictions?
- **Complete?** Was anything missing that caused extra tool calls, web searches, or backtracking?

## Step 2 — Identify missing skills

Were there tasks where no skill applied but a skill *should* exist? Name the gap and the domain it would cover (e.g., "no skill for Hyper-V networking — would have avoided 2 incorrect attempts").

## Step 3 — Classify issues found

For each problem identified in Steps 1–2, assign one category:

| Category | Meaning |
|---|---|
| **Wrong** | Skill contained incorrect information that caused a bad output |
| **Missing pattern** | A pattern/pitfall not in the skill that the conversation revealed |
| **Incomplete coverage** | Topic exists in the skill but lacks enough detail to avoid errors |
| **Bad trigger** | Skill description doesn't match when it should fire |
| **New skill needed** | No skill exists; enough domain knowledge was gathered to create one |

## Step 4 — Propose changes

For each issue, state:
- **Skill file:** `c:\Users\viral\OneDrive\Documents\WindowsPowerShell\.github\skills\<skill-name>\SKILL.md`
- **Section to change:** Exact heading or location in the file
- **Proposed edit:** The exact text/table/rule to add, remove, or replace (show a before/after if modifying existing content)
- **Why:** One sentence justifying the change based on what happened in this conversation

Do **not** edit any files. Present the full proposal and wait for explicit approval before making any changes.
