# Contributing to agents

Thank you for your interest in contributing! This repo is a living library of agent skills, subagents, prompts, and hooks. Contributions of all kinds are welcome.

---

## Table of Contents

- [Adding a new skill](#adding-a-new-skill)
- [Adding a new subagent](#adding-a-new-subagent)
- [Adding prompts](#adding-prompts)
- [Extending Cursor hooks](#extending-cursor-hooks)
- [General guidelines](#general-guidelines)

---

## Adding a new skill

1. Create a new folder under `skills/` using a short, lowercase hyphenated name:

   ```
   skills/my-new-skill/
   ```

2. Create `skills/my-new-skill/SKILL.md` with the following structure:

   ```markdown
   ---
   name: my-new-skill
   description: One sentence describing what this skill does and when Copilot should use it.
   version: 1.0.0
   author: Your Name
   tags: [tag1, tag2]
   ---

   ## Overview

   Describe what the skill does.

   ## Conventions

   List any conventions, constraints, or coding standards the skill enforces.

   ## Usage patterns

   ### Pattern 1: ...

   Describe a concrete usage example.

   ### Pattern 2: ...
   ```

3. Optionally add `examples/`, `scripts/`, or additional `.md` docs inside the skill folder.

4. Add a row for your skill in the `README.md` skills table.

---

## Adding a new subagent

1. Create a new folder under `subagents/`:

   ```
   subagents/my-subagent/
   ```

2. Create `subagents/my-subagent/AGENT.md` with the following structure:

   ```markdown
   ---
   name: my-subagent
   description: One sentence describing the subagent's role.
   version: 1.0.0
   ---

   ## Role

   Describe the subagent's purpose and area of specialization.

   ## Inputs

   What information the main agent should provide when delegating.

   ## Outputs

   What the subagent returns to the main agent.

   ## Delegation pattern

   Describe exactly how the main Copilot agent should invoke this subagent.

   ## Constraints

   Any limitations or boundaries the subagent should respect.
   ```

3. Optionally add example prompt files (`.md`) inside the subagent folder.

4. Add a row for your subagent in the `README.md` subagents table.

---

## Adding prompts

- **Repository-level prompts** go in `.github/prompts/` and can be referenced from Copilot Chat with `#prompt:<filename-without-extension>`.
- **Reusable prompt library** entries go in `prompts/system/`, `prompts/tasks/`, or `prompts/patterns/` depending on their scope.
- Keep prompt files small and focused on a single task or theme.
- Use Copilot context selectors (`#file`, `#selection`, `#codebase`, `#git`) where they add value.

---

## Extending Cursor hooks

1. Add a new script in `.cursor/hooks/`. Use shell scripts (`.sh`) for Unix-like systems.
2. Register the hook in `.cursor/hooks.json` under the appropriate event key (`afterFileEdit`, `stop`, etc.).
3. Document the hook's purpose in the script header comments and in the [`.cursor/hooks.json`](.cursor/hooks.json) `description` field.

---

## General guidelines

- Keep all files **plain text / Markdown**. No binaries.
- Write **clear, concise English** with practical examples.
- Make files **small and composable** — easy to copy into other repos.
- Follow the existing file and naming conventions.
- Open a pull request with a clear description of what you're adding and why.
- One skill / subagent / prompt per pull request when possible, to keep reviews focused.
