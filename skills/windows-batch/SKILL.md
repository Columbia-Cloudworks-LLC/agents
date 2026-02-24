---
name: windows-batch
description: Expert skill for writing, explaining, and refactoring Windows batch (.bat/.cmd) scripts using modern NT-style cmd best practices.
version: 1.0.0
author: Columbia Cloudworks
tags: [windows, batch, cmd, bat, scripting, automation, legacy]
---

## Overview

This skill provides expert guidance for Windows batch scripting (`.bat` and `.cmd` files). It covers:

- Modern NT-style `cmd.exe` best practices
- Variable expansion and delayed expansion (`EnableDelayedExpansion`)
- Proper error handling with `ERRORLEVEL` and `EXIT /B`
- String manipulation, loops, and conditionals
- Escaping special characters
- Calling and chaining other scripts

Use this skill when asked to **explain**, **refactor**, or **generate** batch scripts.

---

## Conventions and constraints

### Always include at the top of every script
```bat
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
```

- `@ECHO OFF` — suppress command echoing
- `SETLOCAL ENABLEEXTENSIONS` — ensure modern command extensions are active
- `ENABLEDELAYEDEXPANSION` — allow `!VAR!` syntax inside loops and blocks

### Variable naming
- Use `UPPERCASE_WITH_UNDERSCORES` for all variables.
- Prefer `SET "VAR=value"` (with quotes around the assignment) to handle trailing spaces correctly.

### Error handling
- Always check `ERRORLEVEL` after critical commands.
- Use `IF ERRORLEVEL 1 GOTO :ERROR` or `IF %ERRORLEVEL% NEQ 0 ...`
- End scripts with `EXIT /B 0` on success, `EXIT /B 1` (or non-zero) on failure.
- Define a `:ERROR` label for centralized error reporting.

### Labels and structure
- Use `:MAIN`, `:PARSE_ARGS`, `:CLEANUP`, `:ERROR`, `:EOF` labels to structure scripts.
- End every subroutine with `EXIT /B` (not `GOTO :EOF` alone) unless calling via `CALL`.

### Special character escaping
- Escape `&`, `|`, `<`, `>`, `^`, `(`, `)` with `^` when they appear literally: `^&`, `^|`, etc.
- Inside double quotes, `%` must be doubled: `"C:\path with spaces\%FILE%%"`
- Inside `IF` blocks with delayed expansion, use `!VAR!` instead of `%VAR%`

### Security
- Validate any input passed to scripts (e.g., from `%1`, `%2` arguments).
- Never pass raw user input directly to `CMD /C` or similar.
- Prefer absolute paths; use `%~dp0` to reference the script's own directory.

---

## Usage patterns

### Pattern 1: Explain an existing script

> Prompt: "Explain what this batch script does: #file:deploy.bat"

Expected behavior: Walk through each section, explain the purpose of commands, flag any issues or outdated patterns, and summarize the overall flow.

### Pattern 2: Refactor an old script

> Prompt: "Refactor this batch script to use modern NT-style best practices: #selection"

Expected behavior:
1. Add `@ECHO OFF` and `SETLOCAL` if missing.
2. Replace `SET VAR=value` with `SET "VAR=value"`.
3. Add `ERRORLEVEL` checks after critical commands.
4. Add `:ERROR` label and structured exit.
5. Replace deprecated `%0` references with `%~dp0`.

### Pattern 3: Generate a new script

> Prompt: "Write a batch script that backs up all `.log` files from `C:\App\Logs` to `D:\Backup\Logs`, keeping the last 7 days."

Expected output example:
```bat
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

SET "SOURCE_DIR=C:\App\Logs"
SET "BACKUP_DIR=D:\Backup\Logs"
SET "RETENTION_DAYS=7"

IF NOT EXIST "!BACKUP_DIR!" MKDIR "!BACKUP_DIR!"
IF ERRORLEVEL 1 GOTO :ERROR

:: Copy log files
XCOPY "!SOURCE_DIR!\*.log" "!BACKUP_DIR!\" /Y /Q
IF ERRORLEVEL 1 GOTO :ERROR

:: Delete files older than retention period
FORFILES /P "!BACKUP_DIR!" /M "*.log" /D -!RETENTION_DAYS! /C "CMD /C DEL @PATH" 2>NUL

ECHO Backup complete.
EXIT /B 0

:ERROR
ECHO ERROR: Script failed with ERRORLEVEL %ERRORLEVEL%. >&2
EXIT /B 1
```

---

## Common pitfalls to flag

| Issue | Explanation |
|-------|-------------|
| Using `%VAR%` inside a `FOR` loop body | Must use `!VAR!` with delayed expansion |
| Missing `SETLOCAL` | Variables leak to the calling environment |
| `IF %ERRORLEVEL% == 0` | Fails when `ERRORLEVEL` is undefined; prefer `IF ERRORLEVEL 1` |
| Paths with spaces not quoted | Always quote paths: `"%PROGRAM_FILES%\app.exe"` |
| Calling `GOTO :EOF` in a subroutine | Use `EXIT /B` inside `CALL`-ed subroutines |
