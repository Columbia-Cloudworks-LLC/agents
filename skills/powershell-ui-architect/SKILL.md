---
name: powershell-ui-architect
description: Expert in building GUIs and TUIs with PowerShell using WinForms, WPF, and Console/TUI frameworks. Use when creating PowerShell tools with graphical or terminal interfaces. Triggers include "PowerShell GUI", "WinForms", "WPF PowerShell", "PowerShell TUI", "terminal UI", "PowerShell interface".
---

# PowerShell UI Architect

## Purpose
Provides expertise in building graphical user interfaces (GUI) and terminal user interfaces (TUI) with PowerShell. Specializes in WinForms, WPF, and console-based TUI frameworks for creating user-friendly PowerShell tools.

## When to Use
- Building PowerShell tools with GUI
- Creating WinForms applications
- Developing WPF interfaces for scripts
- Building terminal user interfaces (TUI)
- Adding dialogs to automation scripts
- Creating interactive admin tools
- Building configuration wizards
- Implementing progress displays

## Quick Start
**Invoke this skill when:**
- Creating GUIs for PowerShell scripts
- Building WinForms or WPF interfaces
- Developing terminal-based UIs
- Adding interactive dialogs to tools
- Creating admin tool interfaces

**Do NOT invoke when:**
- Cross-platform CLI tools → use `/cli-developer`
- PowerShell module design → use `/powershell-module-architect`
- Web interfaces → use `/frontend-design`
- Windows app development (non-PS) → use `/windows-app-developer`

## Decision Framework
```
UI Type Needed?
├── Simple Dialog
│   └── WinForms MessageBox / InputBox
├── Full Windows App
│   ├── Simple layout → WinForms
│   └── Rich UI → WPF with XAML
├── Console/Terminal
│   ├── Simple menu → Write-Host + Read-Host
│   └── Rich TUI → Terminal.Gui / PSReadLine
└── Cross-Platform
    └── Terminal-based only
```

## Core Workflows

### 1. WinForms Application
1. Add System.Windows.Forms assembly
2. Create Form object, call `$form.SuspendLayout()`
3. Create all panels and controls
4. Add controls to form in correct dock-priority order (see Dock Layout Rules)
5. Call `$form.ResumeLayout($false)` then `$form.PerformLayout()`
6. Wire up event handlers
7. Use `$form.Add_Shown({})` for any logic that must run when the form first appears
8. Show form with `$form.ShowDialog()`

### 2. WPF Interface
1. Define XAML layout
2. Load XAML in PowerShell
3. Get control references
4. Add event handlers
5. Implement logic
6. Display window

### 3. TUI with Terminal.Gui
1. Install Terminal.Gui module
2. Initialize application
3. Create window and views
4. Add controls (buttons, lists, text)
5. Handle events
6. Run main loop

## WinForms Dock Layout Rules

### CRITICAL: Controls.Add Order Determines Layout

WinForms resolves docked layout in **reverse z-order**: the control added **last** to `Controls` has the highest z-order and is processed **last** by the layout engine. `Dock=Fill` must therefore be added **first** so it is processed last and takes only the remaining space after all other docked panels have claimed their edges.

#### Correct add order for a Header + Nav + Content layout:
```powershell
$form.SuspendLayout()

# Build all panels first (do not add to form yet)
$pnlHeader  = ...  # Dock = Top
$pnlNav     = ...  # Dock = Left
$pnlContent = ...  # Dock = Fill

# Add in reverse dock-priority order:
#   Fill first  → highest z-order → processed LAST → takes remaining space
#   Left second → processed second → carves its edge slice
#   Top last    → lowest z-order  → processed FIRST → takes top strip
$form.Controls.Add($pnlContent)   # Fill
$form.Controls.Add($pnlNav)       # Left
$form.Controls.Add($pnlHeader)    # Top

$form.ResumeLayout($false)
$form.PerformLayout()
```

#### General rule — add order by Dock value:
| Add order | Dock value | Processed order |
|-----------|------------|-----------------|
| 1st (first added) | Fill | Last processed |
| 2nd | Left / Right | Second |
| Last (last added) | Top / Bottom | First processed |

#### Why SuspendLayout / ResumeLayout matters
- `SuspendLayout()` prevents incremental layout recalculations as each control is added
- `ResumeLayout($false)` re-enables layout without triggering a full layout pass
- `PerformLayout()` triggers one clean layout pass with all controls present
- Omitting these can cause controls to be sized/positioned based on a partially constructed control tree

### Add_Shown vs Add_Load
| Event | When it fires | Use for |
|-------|---------------|---------|
| `Add_Load` | Before form is visible | One-time setup that must not show UI |
| `Add_Shown` | After form is fully rendered and visible | Auto-running logic that updates controls (e.g. populating a ListView on open) |

```powershell
# Correct: auto-populate data when form first appears
$form.Add_Shown({
    $form.btnCheckAll.PerformClick()
})
```

## Event Handler Scoping (Critical)

### Synchronous handlers ARE closures

Scriptblocks passed to synchronous UI-thread events — `.Add_Click()`, `.Add_Shown()`, `.Add_FormClosing()`, `.Add_SelectedIndexChanged()`, etc. — **are PowerShell closures**. They capture the lexical scope at definition time and can read and write local variables from the enclosing function, just like any other PowerShell scriptblock.

```powershell
# ✅ Works — $form is a function-local variable, captured by the closure
function Show-ScraperDialog {
    $form = New-RedditScraperForm
    $form.btnBrowse.Add_Click({
        $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
        if ($dlg.ShowDialog() -eq 'OK') {
            $form.txtOutputDir.Text = $dlg.SelectedPath   # $form is visible here
        }
    })
    [System.Windows.Forms.Application]::Run($form)
}
```

Event parameters (`$sender`, `$e`) are **not** injected automatically. Declare them explicitly with `param()` if needed:

```powershell
$form.Add_FormClosing({
    param($sender, $e)
    if ($script:isRunning) { $e.Cancel = $true }
})
```

| Scope level | Visible in synchronous handler? | Example |
|-------------|--------------------------------|---------|
| `$script:` (module) | Yes | `$script:logForm` |
| `$global:` | Yes | `$global:config` |
| Function-local `$var` | **Yes** (closure) | `$form`, `$setInputsEnabled` |
| `$sender` / `$e` | Only with `param($sender, $e)` | `$sender.Tag`, `$e.Cancel` |

### Timer and async callbacks are NOT closures

`System.Windows.Forms.Timer` `.Add_Tick()` and all genuinely asynchronous callbacks (`System.Timers.Timer` Elapsed, `BackgroundWorker` DoWork, Runspace scripts) do **not** retain the enclosing function's local variables. By the time the callback fires, the original function's stack frame is gone.

| Handler type | Closure? | Local vars accessible? |
|---|---|---|
| `Add_Click`, `Add_Shown`, `Add_FormClosing`, etc. | **Yes** | Yes — captured at definition |
| `WinForms.Timer` `.Add_Tick` | **No** | No — use `$script:` or Tag |
| `System.Timers.Timer` Elapsed | **No** | No — fires on ThreadPool thread |
| BackgroundWorker / Runspace | **No** | No — separate runspace |

```powershell
# ❌ WRONG — $Form is gone when the timer fires
function Start-LogTailing {
    param($Form)
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Add_Tick({
        $Form.txtStatus.AppendText("update")   # THROWS — $Form is $null
    })
}

# ✅ CORRECT — store in module scope before registering timer handler
function Start-LogTailing {
    param($Form)
    $script:logForm = $Form
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Add_Tick({
        $script:logForm.txtStatus.AppendText("update")   # Works
    })
}
```

### Alternative: use `$sender.Tag` to pass context (preferred when multiple timers exist)

Storing state in `$timer.Tag` keeps context local to each timer instance. This is
preferable over `$script:` variables when a module may create more than one timer,
because each timer carries its own context and there is no shared mutable state to
manage.

```powershell
# ✅ ALSO CORRECT — store state on the timer itself so each instance has its own context
function Start-LogTailing {
    param($Form)
    $timer = New-Object System.Windows.Forms.Timer

    # Attach any state the handler needs directly to the timer
    $timer.Tag = [pscustomobject]@{
        Form = $Form
        # Add more fields here if needed, e.g. LogPath, Filter, etc.
    }

    $timer.Add_Tick({
        param($sender, $eventArgs)

        # Each timer instance carries its own state in $sender.Tag
        $ctx = $sender.Tag
        $ctx.Form.txtStatus.AppendText("update")
    })

    $timer.Start()
}
```

| Approach | Module-scope pollution | Works with multiple timers | Notes |
|---|---|---|---|
| `$script:logForm` | Yes — one shared variable | Only if you manage separate vars per timer | Simple; fine for single-timer modules |
| `$timer.Tag` | No | Yes — each timer is self-contained | Preferred when ≥2 timers may coexist |

### Invoke([Action]{}) — when is it needed?

| Scenario | Invoke needed? | Reason |
|----------|---------------|--------|
| WinForms Timer `.Add_Tick` | **No** | Timer fires on UI thread via message pump |
| `System.Timers.Timer` Elapsed | **Yes** | Fires on ThreadPool thread |
| BackgroundWorker / Runspace | **Yes** | Runs on worker thread |
| Button `.Add_Click` | **No** | User input fires on UI thread |

Only use `$control.Invoke([Action]{...})` when the event genuinely fires on a non-UI thread. Unnecessary Invoke calls add complexity and can mask scoping bugs.

## Best Practices
- Keep UI code separate from logic
- Use XAML for complex WPF layouts
- Handle errors gracefully with user feedback
- Provide progress indication for long operations
- Test on target Windows versions
- Use appropriate UI for audience (GUI vs TUI)
- Always use `SuspendLayout`/`ResumeLayout`/`PerformLayout` when building forms with multiple docked panels
- Prefer `Dock` and `Anchor` over hardcoded pixel coordinates for all panels; use fixed coordinates only for controls *inside* a panel where the panel itself is docked
- Store child controls as `NoteProperty` members on the form/panel object for clean cross-function access: `Add-Member -InputObject $form -Name 'btnRun' -Value $btn -MemberType NoteProperty`

## Anti-Patterns
| Anti-Pattern | Problem | Correct Approach |
|--------------|---------|------------------|
| UI logic mixed with business logic | Hard to maintain | Separate concerns |
| Blocking UI thread | Frozen interface | Use runspaces/jobs |
| No input validation | Crashes, bad data | Validate before use |
| Hardcoded sizes | Scaling issues | Use anchoring/docking |
| No error messages | Confused users | Friendly error dialogs |
| `Dock=Fill` added last to `Controls` | Fill claims full area; Left/Right panels overlap it | Add Fill **first**, then Left/Right, then Top/Bottom |
| Missing `SuspendLayout`/`ResumeLayout` | Controls sized against partially built tree; incorrect layout | Wrap all control construction with `SuspendLayout()` / `ResumeLayout($false)` / `PerformLayout()` |
| Using `Add_Load` to populate visible controls | Fires before form renders; ListView/grid updates are lost | Use `Add_Shown` for any logic that updates controls on first display |
