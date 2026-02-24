---
name: powershell
description: Expert skill for writing, explaining, and refactoring PowerShell scripts with modern best practices, error handling, and cross-platform compatibility.
version: 1.0.0
author: Columbia Cloudworks
tags: [powershell, windows, automation, scripting, devops, cross-platform]
---

## Overview

This skill provides expert guidance for PowerShell scripting (`.ps1`, `.psm1`, `.psd1`). It covers:

- PowerShell 5.1 (Windows PowerShell) and PowerShell 7+ (cross-platform)
- Structured error handling with `try/catch/finally` and `$ErrorActionPreference`
- Parameter declarations with `[CmdletBinding()]` and `[Parameter()]`
- Pipeline-friendly function design
- Logging and verbose output patterns
- Module structure and manifest files

---

## Conventions and constraints

### Script header
Every standalone script should begin with:
```powershell
#Requires -Version 5.1
[CmdletBinding()]
param(
    # Parameters here
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
```

- `#Requires -Version` — declare the minimum PowerShell version
- `[CmdletBinding()]` — enables `-Verbose`, `-Debug`, `-ErrorAction`, and `-WhatIf` support
- `Set-StrictMode -Version Latest` — catch undefined variables and other common mistakes
- `$ErrorActionPreference = 'Stop'` — treat all errors as terminating by default

### Parameter naming
- Use `PascalCase` for parameters and variables.
- Provide `[Parameter(Mandatory)]` and `[ValidateNotNullOrEmpty()]` for required inputs.
- Use `[switch]` for boolean flags.

### Error handling
```powershell
try {
    # risky operation
}
catch [System.IO.FileNotFoundException] {
    Write-Error "File not found: $_"
    exit 1
}
catch {
    Write-Error "Unexpected error: $_"
    exit 1
}
finally {
    # cleanup
}
```

### Output
- Use `Write-Verbose` for diagnostic messages (only shown with `-Verbose`).
- Use `Write-Warning` for non-fatal issues.
- Use `Write-Error` + `exit 1` for fatal errors.
- Return objects from functions, not formatted strings — let the caller decide how to format.

### Security
- Never use `Invoke-Expression` with user-provided strings.
- Prefer `Start-Process` with argument arrays over string concatenation for external commands.
- Validate all input parameters before use.
- Use `[SecureString]` for passwords; never store credentials in plain text.

### Cross-platform compatibility (PS 7+)
- Avoid WMI cmdlets (`Get-WmiObject`) — use CIM cmdlets (`Get-CimInstance`) instead.
- Use `[System.IO.Path]::Combine()` or `Join-Path` instead of hardcoded path separators.
- Test OS with `$IsWindows`, `$IsLinux`, `$IsMacOS`.

---

## Usage patterns

### Pattern 1: Explain a script

> Prompt: "Explain what this PowerShell script does: #file:deploy.ps1"

Expected behavior: Walk through parameters, main logic flow, error handling, and summarize what the script accomplishes and any risks.

### Pattern 2: Add proper error handling to a script

> Prompt: "Add structured error handling to this PowerShell script: #selection"

Expected behavior:
1. Wrap risky operations in `try/catch`.
2. Add `$ErrorActionPreference = 'Stop'` at the top.
3. Replace bare `exit` with `exit 0` / `exit 1`.

### Pattern 3: Generate a new script

> Prompt: "Write a PowerShell script that recursively searches a directory for files modified in the last 24 hours and copies them to an archive folder."

```powershell
#Requires -Version 5.1
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$SourcePath,

    [Parameter(Mandatory)]
    [string]$ArchivePath,

    [int]$HoursBack = 24
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$cutoff = (Get-Date).AddHours(-$HoursBack)

try {
    if (-not (Test-Path $ArchivePath)) {
        New-Item -ItemType Directory -Path $ArchivePath | Out-Null
    }

    $files = Get-ChildItem -Path $SourcePath -Recurse -File |
             Where-Object { $_.LastWriteTime -ge $cutoff }

    foreach ($file in $files) {
        if ($PSCmdlet.ShouldProcess($file.FullName, 'Copy to archive')) {
            Copy-Item -Path $file.FullName -Destination $ArchivePath -Force
            Write-Verbose "Copied: $($file.FullName)"
        }
    }

    Write-Host "Archived $($files.Count) file(s)."
}
catch {
    Write-Error "Archive operation failed: $_"
    exit 1
}
```

---

## Common pitfalls to flag

| Issue | Correct approach |
|-------|-----------------|
| `$ErrorActionPreference` not set | Set to `'Stop'` at the top of scripts |
| Using `Write-Host` for data output | Use `Write-Output` or `return` for data; `Write-Host` for UI only |
| `Invoke-Expression` with user input | Use `Start-Process` with argument arrays |
| Hardcoded Windows paths | Use `Join-Path` and `[System.IO.Path]` |
| Missing `[CmdletBinding()]` | Prevents common parameter support |
