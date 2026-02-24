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
| `.cursor/` | Cursor hook scripts and `hooks.json` configuration |

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
| `#prompt:reflect` | Reflect on the conversation and identify skill improvements needed |

---

## Available skills

| Skill | Folder | Description |
|-------|--------|-------------|
| `cost-optimization` | `skills/cost-optimization/` | Cloud cost reduction: rightsizing, tagging, reserved instances, spending analysis |
| `docker-expert` | `skills/docker-expert/` | Multi-stage builds, image optimization, container security, Compose orchestration |
| `microsoft-code-reference` | `skills/microsoft-code-reference/` | Azure SDK / .NET API lookup and working code samples via Learn MCP |
| `microsoft-docs` | `skills/microsoft-docs/` | Official Microsoft documentation queries via Learn MCP |
| `microsoft-hyper-v` | `skills/microsoft-hyper-v/` | Hyper-V host and VM lifecycle automation with PowerShell |
| `microsoft-skill-creator` | `skills/microsoft-skill-creator/` | Generate new skills for Microsoft technologies using Learn MCP |
| `modern-javascript-patterns` | `skills/modern-javascript-patterns/` | ES6+ features, async/await, functional patterns, clean JS |
| `multi-cloud-architecture` | `skills/multi-cloud-architecture/` | Multi-cloud design patterns across AWS, Azure, and GCP |
| `nodejs-best-practices` | `skills/nodejs-best-practices/` | Node.js architecture, framework selection, async, security, port/process management |
| `powershell-5.1-expert` | `skills/powershell-5.1-expert/` | Legacy Windows PowerShell 5.1: WMI, ADSI, COM automation |
| `powershell-7-expert` | `skills/powershell-7-expert/` | Modern PowerShell Core: cross-platform, parallel processing, REST APIs |
| `powershell-master` | `skills/powershell-master/` | Full PowerShell expertise across all platforms and CI/CD pipelines |
| `powershell-ui-architect` | `skills/powershell-ui-architect/` | PowerShell GUIs and TUIs using WinForms, WPF, and console frameworks |
| `powershell-windows` | `skills/powershell-windows/` | Critical Windows PowerShell pitfalls, operator syntax, error handling |
| `reddit-api` | `skills/reddit-api/` | Reddit API integration via PRAW (Python) and Snoowrap (Node.js) |
| `semantic-html` | `skills/semantic-html/` | Semantic HTML, accessibility, and proper document structure |
| `terraform-module-library` | `skills/terraform-module-library/` | Reusable Terraform modules for AWS, Azure, and GCP |
| `web-design-reviewer` | `skills/web-design-reviewer/` | Visual inspection and source-level fixes for websites and SPAs |
| `windows-batch` | `skills/windows-batch/` | Windows batch (.bat/.cmd) scripting best practices |
