# agents

> A repository of agent skills, subagents, hooks, and prompts designed for use in **VS Code with GitHub Copilot** and **Cursor IDE**.

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## What's in this repo?

| Directory | Purpose |
|-----------|---------|
| `skills/` | Copilot Agent Skills — tool-like, task-specific behaviors loaded via `SKILL.md` |
| `subagents/` | Specialized sub-agents that handle heavy analysis and return summaries |
| `prompts/` | Reusable prompt templates organized by theme (system, tasks, patterns) |
| `.github/prompts/` | Repository-level prompts referenceable with `#prompt:` in Copilot Chat |
| `.github/copilot-instructions.md` | Repository-level coding standards injected into every Copilot session |
| `.cursor/` | Cursor IDE hook configuration and hook scripts |
| `examples/` | End-to-end usage scenarios |
| `docs/` | Architecture documentation |

---

## Quickstart: VS Code + GitHub Copilot

### 1. Clone or fork this repository

```bash
git clone https://github.com/Columbia-Cloudworks-LLC/agents.git
```

### 2. Open the repo in VS Code with the GitHub Copilot extension installed

Copilot automatically reads `.github/copilot-instructions.md` and applies it to every chat session in this workspace.

### 3. Use skills in Copilot Chat

Skills live in `skills/<skill-name>/SKILL.md`. Copilot selects and injects the relevant `SKILL.md` into its context based on the skill's name and description.

Reference a skill explicitly in chat:

```
@workspace /skills/code-review — please review #selection
```

### 4. Reference prompt files

Prompt files in `.github/prompts/` can be referenced by name in Copilot Chat:

```
#prompt:code-review-task  Please review the following code: #file:src/api.js
```

### 5. Invoke subagents

Subagents (in `subagents/`) are specialized helpers for heavy, context-intensive tasks. Tell Copilot to use one:

```
Use the code-auditor subagent to audit #file:src/auth.ts for security issues, then summarize the findings.
```

---

## Quickstart: Cursor IDE

### 1. Copy or symlink `.cursor/` into your project

```bash
cp -r .cursor /your-project/.cursor
# or
ln -s /path/to/agents/.cursor /your-project/.cursor
```

### 2. Hooks activate automatically

Cursor reads `.cursor/hooks.json` and runs the defined scripts on events like `afterFileEdit` and `stop`. See [`.cursor/hooks.json`](.cursor/hooks.json) and [`.cursor/hooks/`](.cursor/hooks/) for details.

---

## What are skills?

A **skill** is a folder under `skills/` that contains a `SKILL.md` file. When Copilot determines a skill is relevant to the current task, it injects the `SKILL.md` contents into its context window.

Each `SKILL.md` has YAML frontmatter (`name`, `description`) followed by a body that describes what the skill does, conventions to follow, and example usage patterns.

**Available skills:**

| Skill | Description |
|-------|-------------|
| [`skills/windows-batch/`](skills/windows-batch/) | Windows `.bat`/`.cmd` scripting patterns and best practices |
| [`skills/powershell/`](skills/powershell/) | PowerShell automation and scripting |
| [`skills/code-review/`](skills/code-review/) | Structured code review with correctness, readability, security checks |
| [`skills/tests-generator/`](skills/tests-generator/) | Generating tests for existing code |
| [`skills/docs-writer/`](skills/docs-writer/) | Writing and maintaining documentation |

---

## What are subagents?

A **subagent** is a specialized assistant described by an `AGENT.md` file under `subagents/`. The main Copilot agent delegates heavy or context-intensive tasks to a subagent, then uses the returned summary to implement changes.

**Available subagents:**

| Subagent | Role |
|----------|------|
| [`subagents/code-auditor/`](subagents/code-auditor/) | Deep security and correctness auditing |
| [`subagents/log-analyzer/`](subagents/log-analyzer/) | Log parsing, error pattern detection, root-cause analysis |
| [`subagents/migration-assistant/`](subagents/migration-assistant/) | Code migration planning and execution |

---

## What are Cursor hooks?

Cursor hooks run scripts automatically on IDE events. This repo ships hooks for:

- **`afterFileEdit`** — format files, run quick lints, or stage changes after every save
- **`stop`** — summarize session changes, run a final lint pass, or commit a checkpoint

See [`.cursor/hooks.json`](.cursor/hooks.json) and [`.cursor/hooks/`](.cursor/hooks/).

---

## Repository structure

```
agents/
├── .github/
│   ├── copilot-instructions.md      # Repo-wide Copilot coding standards
│   └── prompts/
│       ├── skills-index.md
│       ├── code-review-task.md
│       ├── refactor-task.md
│       └── test-generation-task.md
├── skills/
│   ├── windows-batch/SKILL.md
│   ├── powershell/SKILL.md
│   ├── code-review/SKILL.md
│   ├── tests-generator/SKILL.md
│   └── docs-writer/SKILL.md
├── subagents/
│   ├── code-auditor/AGENT.md
│   ├── log-analyzer/AGENT.md
│   └── migration-assistant/AGENT.md
├── prompts/
│   ├── system/developer-system.md
│   ├── tasks/
│   │   ├── code-review.md
│   │   ├── test-generation.md
│   │   └── refactor.md
│   └── patterns/
│       ├── rubber-duck.md
│       ├── legacy-code-explainer.md
│       └── migration-assistant.md
├── .cursor/
│   ├── hooks.json
│   └── hooks/
│       ├── after-edit.sh
│       └── stop.sh
├── examples/
│   ├── copilot-skills-usage.md
│   ├── subagent-code-review.md
│   └── cursor-hooks-workflow.md
├── docs/
│   └── architecture.md
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── LICENSE
└── README.md
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add new skills, subagents, prompts, and hooks.

## License

[MIT](LICENSE) © 2026 Columbia Cloudworks

