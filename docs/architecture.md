# Architecture: Agent Skills, Subagents, Prompts, and Hooks

This document explains the architecture of this repository in depth — how the components interplay and how to adapt them for your own projects.

---

## Overview

This repository provides four categories of agentic building blocks:

```
┌──────────────────────────────────────────────────────────────┐
│                    User / Developer                          │
└───────────────────────────┬──────────────────────────────────┘
                            │ asks / instructs
                            ▼
┌──────────────────────────────────────────────────────────────┐
│              Main Agent (GitHub Copilot / Cursor)            │
│                                                              │
│  Reads:  .github/copilot-instructions.md   (always)          │
│  Reads:  skills/<name>/SKILL.md            (when relevant)   │
│  Uses:   .github/prompts/*.md              (#prompt:)        │
│  Delegates: subagents/<name>/AGENT.md      (heavy tasks)     │
└──────────┬────────────────────────────────────┬──────────────┘
           │ implements                          │ delegates
           ▼                                     ▼
┌──────────────────────┐            ┌────────────────────────┐
│   Your codebase      │            │   Subagent              │
│   (edited files)     │            │   (analysis/planning)   │
└──────────────────────┘            │   Returns summary       │
                                    └────────────────────────┘
           │
           │ triggers on save / session end
           ▼
┌──────────────────────────────────────────────────────────────┐
│                  Cursor Hooks                                │
│   afterFileEdit → format → lint → git stage                  │
│   stop          → final lint → summary → checkpoint commit   │
└──────────────────────────────────────────────────────────────┘
```

---

## Component 1: Copilot Skills (`skills/`)

### What they are

A **skill** is a directory containing a `SKILL.md` file with YAML frontmatter and a body describing:
- What the skill does
- What conventions and constraints to follow
- Concrete usage patterns and examples

### How Copilot loads them

Copilot selects skills based on the `name` and `description` in the YAML frontmatter. When a skill is relevant to the current task, Copilot injects the `SKILL.md` body into its context window. This gives Copilot specialized knowledge for that task.

### Design principles

- **Single responsibility.** Each skill covers one domain (e.g., "Windows Batch scripting").
- **Self-contained.** The `SKILL.md` body should be understandable on its own, without needing other files.
- **Actionable.** Skills should contain concrete patterns, examples, and constraints — not vague advice.
- **Composable.** Multiple skills can be active simultaneously (e.g., code-review + tests-generator).

### When to create a new skill

Create a new skill when:
- You have a domain with specific conventions that Copilot should follow consistently
- The domain has common pitfalls that need to be explicitly flagged
- You find yourself repeating the same instructions to Copilot across sessions

---

## Component 2: Subagents (`subagents/`)

### What they are

A **subagent** is a specialized assistant described by an `AGENT.md` file. It handles tasks that are too complex, context-heavy, or analytical for the main agent to perform inline.

Subagents follow a **delegation model**:
1. Main agent receives a complex task
2. Main agent delegates analysis to subagent
3. Subagent performs deep analysis and returns a structured report
4. Main agent implements changes based on the report

### Why use subagents?

- **Context management.** Complex analysis consumes large amounts of context. Delegating to a subagent keeps the main agent's context clean for implementation.
- **Specialization.** Each subagent has deep expertise in its domain.
- **Separation of concerns.** Analysis and implementation are separated, making each easier to review and verify.

### Subagent contract

Every subagent defines:
- **Role** — what it specializes in
- **Inputs** — what the main agent must provide
- **Outputs** — the structure of the report it returns
- **Delegation pattern** — when and how to invoke it
- **Constraints** — what it will and will not do

### Current subagents

| Subagent | Role |
|----------|------|
| `code-auditor` | Security and correctness auditing |
| `log-analyzer` | Log parsing and root-cause analysis |
| `migration-assistant` | Migration planning and execution |

---

## Component 3: Prompt Library (`prompts/` and `.github/prompts/`)

### Two prompt locations

| Location | Purpose | How to use |
|----------|---------|------------|
| `.github/prompts/` | Repository-level prompts | Reference with `#prompt:<name>` in Copilot Chat |
| `prompts/` | Reusable library | Copy-paste into chat or other tools |

### Prompt categories

| Directory | Content |
|-----------|---------|
| `prompts/system/` | System-level instructions for the AI persona |
| `prompts/tasks/` | Task-specific prompts (code review, test gen, refactor) |
| `prompts/patterns/` | Workflow patterns (rubber duck, legacy explainer, migration) |

### How `.github/copilot-instructions.md` works

This file is automatically injected into every Copilot Chat session in the workspace. It provides:
- Repository structure overview
- Coding standards
- Behavioral guidelines for Copilot in this project
- Guidance on when to use skills and subagents

Think of it as the "system prompt" for Copilot in this workspace.

---

## Component 4: Cursor Hooks (`.cursor/`)

### What they are

Cursor hooks are scripts that run automatically on IDE events. They automate quality-of-life tasks that would otherwise require manual steps after each agent edit.

### Hook lifecycle

```
Developer opens Cursor
        │
        ▼
Cursor agent edits a file
        │
        ▼
afterFileEdit hook fires
  → format file
  → lint file
  → git stage file
        │
        ▼
Cursor agent session ends
        │
        ▼
stop hook fires
  → final lint pass
  → print change summary
  → create checkpoint commit
```

### Design principles

- **Non-blocking.** Hooks use `continueOnError: true` so a failing hook never blocks the editor.
- **Idempotent.** Hooks can safely run multiple times on the same file.
- **Transparent.** All hook actions are logged with a `[after-edit]` or `[stop]` prefix.
- **Optional tooling.** Hooks check for tool availability with `command -v` before running — they gracefully skip steps when a tool isn't installed.

---

## Adapting this architecture to your own repo

### Minimal adoption (10 minutes)

1. Copy `.github/copilot-instructions.md` into your project and edit it for your stack.
2. Copy the skill(s) most relevant to your work into `skills/`.
3. Start using `#prompt:code-review-task` in Copilot Chat.

### Full adoption (1–2 hours)

1. Copy the entire repository structure.
2. Customize `skills/` — add skills for your specific frameworks and conventions.
3. Customize `.github/copilot-instructions.md` for your project.
4. Set up `.cursor/` hooks with the formatters and linters your project uses.
5. Add project-specific subagents in `subagents/`.

### Sharing across a team

- Commit the `skills/`, `subagents/`, `.github/`, and `.cursor/` directories to your project repo.
- Every team member who opens the project in VS Code or Cursor gets the same skills, prompts, and hooks automatically.
- Use the `CONTRIBUTING.md` pattern to let team members propose new skills and prompts via pull requests.
