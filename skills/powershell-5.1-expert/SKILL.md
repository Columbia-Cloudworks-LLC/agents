---
name: powershell-5.1-expert
description: Expert in legacy Windows PowerShell 5.1. Specializes in WMI, ADSI, COM automation, and maintaining backward compatibility with Windows Server environments. Use for Windows-specific automation on legacy systems. Triggers include "PowerShell 5.1", "Windows PowerShell", "WMI", "ADSI", "COM object", "legacy PowerShell".
---

# PowerShell 5.1 Expert

## Purpose
Provides expertise in Windows PowerShell 5.1 for legacy Windows environments. Specializes in WMI queries, ADSI operations, COM automation, and maintaining scripts compatible with older Windows Server systems.

## When to Use
- Scripting for Windows Server 2012/2016/2019
- Working with WMI for system management
- Active Directory operations via ADSI
- COM automation (Office, legacy apps)
- Maintaining backward compatibility
- DSC (Desired State Configuration)
- Windows-specific automation
- Legacy script maintenance

## Quick Start
**Invoke this skill when:**
- Working with Windows PowerShell 5.1 specifically
- Using WMI for system queries
- Automating with ADSI or COM objects
- Maintaining legacy PowerShell scripts
- DSC configuration management

**Do NOT invoke when:**
- Cross-platform PowerShell → use `/powershell-7-expert`
- GUI/TUI development → use `/powershell-ui-architect`
- Security hardening → use `/powershell-security-hardening`
- Module architecture → use `/powershell-module-architect`

## Decision Framework
```
PowerShell Version Context?
├── Must run on older Windows
│   └── Use 5.1 with WMI/ADSI
├── Cross-platform needed
│   └── Use PowerShell 7+ instead
├── AD Management
│   ├── Simple → ADSI
│   └── Complex → AD Module
└── System Info
    ├── Legacy → WMI
    └── Modern → CIM (also works in 5.1)
```

## Core Workflows

### 1. WMI System Query
1. Identify WMI class (Win32_*)
2. Construct WMI query
3. Use Get-WmiObject or Get-CimInstance
4. Filter results appropriately
5. Format output
6. Handle errors for remote systems

### 2. ADSI Operations
1. Create DirectoryEntry object
2. Navigate LDAP path
3. Query or modify attributes
4. Commit changes if modifying
5. Handle authentication
6. Clean up resources

### 3. COM Automation
1. Create COM object with New-Object -ComObject
2. Access object model
3. Perform operations
4. Handle COM errors
5. Release COM objects properly
6. Clean up with [System.Runtime.InteropServices.Marshal]

## Best Practices
- Use CIM cmdlets over WMI when possible (better remoting)
- Always include error handling for remote operations
- Release COM objects explicitly to prevent memory leaks
- Test on target Windows versions
- Document required PowerShell modules
- Use approved verbs for functions

## Anti-Patterns
| Anti-Pattern | Problem | Correct Approach |
|--------------|---------|------------------|
| Not releasing COM | Memory leaks | Explicit cleanup |
| WMI over slow networks | Performance issues | Use CIM with sessions |
| No error handling | Silent failures | Try/Catch with logging |
| Hardcoded paths | Portability issues | Use environment variables |
| Write-Host for output | Can't capture | Write-Output or return |

## PS 5.1 Language Pitfalls (vs PowerShell 7)

These behaviors exist in PS 5.1 but were fixed or changed in PS 7. They cause silent bugs when scripts are developed on PS 7 but run on PS 5.1.

### .Count / .Length on scalars

PS 7 added the `Count` intrinsic member to **all** objects. PS 5.1 did **not** — calling `.Count` on a scalar string or object throws `PropertyNotFoundException` under `Set-StrictMode -Version Latest`.

```powershell
# PS 7:  "hello".Count → 1 (works)
# PS 5.1: "hello".Count → PropertyNotFoundException (fails)

# Guard: wrap pipeline output with @()
$results = @(Get-Process | Where-Object { $_.CPU -gt 100 })
$results.Count   # Works in both PS 5.1 and PS 7
```

### Pipeline unrolling

A pipeline returning exactly one object delivers a **scalar**, not a single-element array. Combined with the missing `.Count`, this is the most common PS 5.1 runtime error.

```powershell
# If only one line matches, $lines is a [string], not [string[]]
$lines = "one`ntwo`nthree" -split "`n" | Where-Object { $_ -match "two" }
$lines.GetType().Name   # String (not Object[])

# Always wrap with @() when you need array behavior
$lines = @("one`ntwo`nthree" -split "`n" | Where-Object { $_ -match "two" })
$lines.Count   # 1 — works correctly
```
