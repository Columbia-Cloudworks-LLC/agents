---
name: skills-index
description: Overview of all available Copilot Agent Skills in this repository with usage guidance.
---

# Skills Index

This prompt provides an overview of every skill available in `skills/`. Reference it to discover which skill to use for a given task.

## Available skills

| Skill | Folder | Best used when... |
|-------|--------|-------------------|
| Windows Batch | `skills/windows-batch/` | Working with `.bat` or `.cmd` files, legacy Windows automation |
| PowerShell | `skills/powershell/` | Writing or debugging PowerShell scripts on Windows or cross-platform |
| Code Review | `skills/code-review/` | Reviewing code for correctness, readability, security, and performance |
| Tests Generator | `skills/tests-generator/` | Generating unit or integration tests for existing code |
| Docs Writer | `skills/docs-writer/` | Writing or updating README, API docs, inline comments, or ADRs |

## How to use a skill

1. Open Copilot Chat.
2. Reference the skill's `SKILL.md` file directly, or simply describe your task — Copilot will select the relevant skill automatically.
3. To force a skill: `@workspace Please use the skills/code-review skill to review #file:src/app.ts`

## Adding a new skill

See [CONTRIBUTING.md](../../CONTRIBUTING.md#adding-a-new-skill) for instructions on creating a new skill folder and `SKILL.md`.
