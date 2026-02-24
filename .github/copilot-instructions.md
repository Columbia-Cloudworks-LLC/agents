# GitHub Copilot — Repository Instructions

These instructions are automatically injected into every Copilot Chat session in this workspace. They describe project structure, coding standards, and how Copilot should behave.

---

## Project purpose

This repository is a library of **agent skills**, **subagents**, **prompt templates**, and **Cursor hooks** designed to extend GitHub Copilot (VS Code) and Cursor IDE with reusable, composable agentic building blocks.

---

## Repository structure

| Path | Content |
|------|---------|
| `skills/<name>/SKILL.md` | Copilot Agent Skill definitions |
| `subagents/<name>/AGENT.md` | Subagent role descriptions and delegation patterns |
| `prompts/` | Reusable prompt library (system, tasks, patterns) |
| `.github/prompts/` | Chat-referenceable prompts (`#prompt:<name>`) |
| `.cursor/` | Cursor hook configuration and scripts |
| `examples/` | End-to-end usage scenarios |
| `docs/` | Architecture and deep-dive documentation |

---

## Coding standards and conventions

1. **All content is plain text / Markdown.** No binaries, no compiled artifacts.
2. **Small and composable files.** Each file should have a single, clear purpose. Prefer many small files over one large file.
3. **YAML frontmatter** is required in every `SKILL.md` and `AGENT.md`. Include at minimum `name` and `description`.
4. **Consistent naming:** use lowercase hyphenated folder and file names (e.g., `code-review`, `log-analyzer`).
5. **English only.** Use clear, concise language with practical examples. Avoid jargon where possible.
6. **No secrets.** Never include API keys, tokens, passwords, or any credentials in any file.

---

## How Copilot should behave in this repo

- **Make minimal, surgical changes.** Prefer targeted edits over large rewrites.
- **Explain your reasoning.** When generating or modifying a skill/subagent/prompt, briefly explain what you changed and why.
- **Respect existing structure.** Follow the folder naming conventions and frontmatter schema already established.
- **Reference context selectors where helpful:** use `#file`, `#selection`, `#codebase`, or `#git` in prompts to encourage users to provide precise context.
- **When generating tests,** follow the conventions in `skills/tests-generator/SKILL.md`.
- **When writing documentation,** follow the conventions in `skills/docs-writer/SKILL.md`.

---

## Delegating to subagents

When a task is complex or context-heavy, instruct Copilot to delegate to the appropriate subagent:

- **Security auditing** → `subagents/code-auditor`
- **Log analysis and root-cause investigation** → `subagents/log-analyzer`
- **Migration planning and execution** → `subagents/migration-assistant`

The subagent performs the heavy analysis and returns a structured summary; the main agent then implements changes based on that summary.

---

## Useful `#prompt:` references

| Prompt | Use case |
|--------|---------|
| `#prompt:code-review-task` | Structured code review |
| `#prompt:refactor-task` | Refactoring with explanation |
| `#prompt:test-generation-task` | Generating tests for a file or selection |
| `#prompt:skills-index` | Overview of all available skills |
