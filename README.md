# agents

> A library of **agent skills**, **subagents**, and **prompt templates** designed to extend **GitHub Copilot in VS Code** with reusable, composable agentic building blocks.

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## What's in this repo?

| Directory | Purpose |
|-----------|---------|
| `skills/` | Copilot Agent Skills — task-specific behaviors loaded via `SKILL.md` |
| `subagents/` | Specialized sub-agents that handle heavy analysis and return summaries |
| `prompts/` | Reusable prompt templates referenceable with `#prompt:` in Copilot Chat |
| `.github/copilot-instructions.md` | Repository-level coding standards injected into every Copilot session |

---

## Quickstart: VS Code + GitHub Copilot

### 1. Clone or fork this repository

```bash
git clone https://github.com/Columbia-Cloudworks-LLC/agents.git
```

### 2. Open the repo in VS Code with the GitHub Copilot extension installed

Copilot automatically reads `.github/copilot-instructions.md` and applies it to every chat session in this workspace.

### 3. Use skills in Copilot Chat

Skills live in `skills/<skill-name>/SKILL.md`. Copilot selects and injects the relevant `SKILL.md` into its context based on the skill's trigger keywords and description.

### 4. Reference prompt files

Prompt files in `prompts/` can be referenced by name in Copilot Chat:

```
#prompt:reflect
```

### 5. Invoke subagents

Subagents (in `subagents/`) are specialized helpers for heavy, context-intensive tasks. Tell Copilot to use one:

```
Use the code-auditor subagent to audit #file:src/auth.ts for security issues, then summarize the findings.
```

---

## What are skills?

A **skill** is a folder under `skills/` that contains a `SKILL.md` file. When Copilot determines a skill is relevant to the current task, it injects the `SKILL.md` contents into its context window.

Each `SKILL.md` has YAML frontmatter (`name`, `description`) followed by a body covering conventions, examples, and usage patterns. Many skills also include a `references/` subfolder with supporting documentation and a `scripts/` subfolder with ready-to-use PowerShell or TypeScript files.

**Available skills:**

| Skill | Description |
|-------|-------------|
| [`skills/cost-optimization/`](skills/cost-optimization/) | Cloud cost reduction: rightsizing, tagging, reserved instances, spending analysis |
| [`skills/docker-expert/`](skills/docker-expert/) | Multi-stage builds, image optimization, container security, Compose orchestration |
| [`skills/microsoft-code-reference/`](skills/microsoft-code-reference/) | Azure SDK / .NET API lookup and working code samples via Learn MCP |
| [`skills/microsoft-docs/`](skills/microsoft-docs/) | Official Microsoft documentation queries via Learn MCP |
| [`skills/microsoft-hyper-v/`](skills/microsoft-hyper-v/) | Hyper-V host and VM lifecycle automation with PowerShell |
| [`skills/microsoft-skill-creator/`](skills/microsoft-skill-creator/) | Generate new skills for Microsoft technologies using Learn MCP |
| [`skills/modern-javascript-patterns/`](skills/modern-javascript-patterns/) | ES6+ features, async/await, functional patterns, clean JS |
| [`skills/multi-cloud-architecture/`](skills/multi-cloud-architecture/) | Multi-cloud design patterns across AWS, Azure, and GCP |
| [`skills/nodejs-best-practices/`](skills/nodejs-best-practices/) | Node.js architecture, framework selection, async, security, port/process management |
| [`skills/powershell-5.1-expert/`](skills/powershell-5.1-expert/) | Legacy Windows PowerShell 5.1: WMI, ADSI, COM automation |
| [`skills/powershell-7-expert/`](skills/powershell-7-expert/) | Modern PowerShell Core: cross-platform, parallel processing, REST APIs |
| [`skills/powershell-master/`](skills/powershell-master/) | Full PowerShell expertise across all platforms and CI/CD pipelines |
| [`skills/powershell-ui-architect/`](skills/powershell-ui-architect/) | PowerShell GUIs and TUIs using WinForms, WPF, and console frameworks |
| [`skills/powershell-windows/`](skills/powershell-windows/) | Critical Windows PowerShell pitfalls, operator syntax, error handling |
| [`skills/reddit-api/`](skills/reddit-api/) | Reddit API integration via PRAW (Python) and Snoowrap (Node.js) |
| [`skills/semantic-html/`](skills/semantic-html/) | Semantic HTML, accessibility, and proper document structure |
| [`skills/terraform-module-library/`](skills/terraform-module-library/) | Reusable Terraform modules for AWS, Azure, and GCP |
| [`skills/web-design-reviewer/`](skills/web-design-reviewer/) | Visual inspection and source-level fixes for websites and SPAs |
| [`skills/windows-batch/`](skills/windows-batch/) | Windows `.bat`/`.cmd` scripting patterns and best practices |

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

## Repository structure

```
agents/
├── .github/
│   ├── copilot-instructions.md      # Repo-wide Copilot coding standards
│   └── prompts/                     # Chat-referenceable prompts (#prompt:<name>)
├── skills/
│   ├── cost-optimization/SKILL.md
│   ├── docker-expert/SKILL.md
│   ├── microsoft-code-reference/SKILL.md
│   ├── microsoft-docs/SKILL.md
│   ├── microsoft-hyper-v/SKILL.md
│   ├── microsoft-skill-creator/
│   │   ├── SKILL.md
│   │   └── references/skill-templates.md
│   ├── modern-javascript-patterns/SKILL.md
│   ├── multi-cloud-architecture/SKILL.md
│   ├── nodejs-best-practices/SKILL.md
│   ├── powershell-5.1-expert/
│   │   ├── SKILL.md
│   │   ├── references/
│   │   └── scripts/
│   ├── powershell-7-expert/
│   │   ├── SKILL.md
│   │   ├── references/
│   │   └── scripts/
│   ├── powershell-master/SKILL.md
│   ├── powershell-ui-architect/
│   │   ├── SKILL.md
│   │   ├── references/
│   │   └── scripts/
│   ├── powershell-windows/SKILL.md
│   ├── reddit-api/SKILL.md
│   ├── semantic-html/
│   │   ├── SKILL.md
│   │   └── references/
│   ├── terraform-module-library/
│   │   ├── SKILL.md
│   │   └── references/
│   ├── web-design-reviewer/
│   │   ├── SKILL.md
│   │   └── references/
│   └── windows-batch/SKILL.md
├── subagents/
│   ├── code-auditor/AGENT.md
│   ├── log-analyzer/AGENT.md
│   └── migration-assistant/AGENT.md
├── prompts/
│   └── reflect.prompt.md
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── LICENSE
└── README.md
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add new skills, subagents, and prompts.

## License

[MIT](LICENSE) © 2026 Columbia Cloudworks

