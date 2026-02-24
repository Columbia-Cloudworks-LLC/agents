## Description

<!-- A clear and concise summary of what this PR does and why. Link any related issues below. -->

Closes #

---

## Type of Change

<!-- Check all that apply. -->

- [ ] Bug fix (non-breaking change that resolves an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Refactor / code cleanup (no functional change)
- [ ] Documentation update
- [ ] Skill / agent infrastructure

---

## Affected Project(s)

- [ ] `enterprise-admin-lab`
- [ ] `patch-management-tools`
- [ ] `subreddit-scraper`
- [ ] Skills / agent config (`.agents/`, `skills-lock.json`)
- [ ] Global (Modules, root configs, `.github/`)

---

## PowerShell Version(s) Tested

- [ ] Windows PowerShell 5.1
- [ ] PowerShell 7.x
- [ ] Not applicable

---

## Checklist

<!-- All items must be checked before requesting review. -->

- [ ] Follows naming conventions: Verb-Noun functions, PascalCase parameters, camelCase locals
- [ ] Script includes `#Requires -Version 5.1` (or appropriate version requirement)
- [ ] `Set-StrictMode -Version Latest` declared at the top of every script/module
- [ ] State-modifying scripts use `[CmdletBinding(SupportsShouldProcess)]`
- [ ] Multi-action scripts route via `switch ($PSCmdlet.ParameterSetName)`
- [ ] All API calls and critical operations wrapped in `try/catch` with `$_.Exception.Message`
- [ ] Mutated environment state (e.g. `$env:PSModulePath`) restored in `finally` block
- [ ] No hardcoded secrets — credentials use JSON sidecar files (and are gitignored)
- [ ] `Write-Progress` used for any operation expected to take > 2 seconds
- [ ] No large binary output files written under the OneDrive-synced workspace

---

## Breaking Changes

<!-- Describe any breaking changes, or write "None". -->

---

## Additional Context

<!-- Screenshots, log excerpts, related PRs, or any other context that helps reviewers. -->

