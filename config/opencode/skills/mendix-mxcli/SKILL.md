---
name: mendix-mxcli
description: Work with Mendix projects using mxcli for exploration, MDL changes, linting, testing, and agent setup. Use when the user mentions Mendix, mxcli, MDL, .mpr files, Studio Pro models, or wants to inspect or change a Mendix project from OpenCode.
---

# mendix-mxcli

## Safety Rules

- Never run mutating `mxcli` commands while the project is open in Studio Pro.
- Treat write operations as risky: `mxcli` is alpha-quality and can corrupt `.mpr` files.
- Use version control or a backup before model changes.
- Before applying changes, preview with `mxcli diff` or a dry run when available, then confirm with the user.
- Prefer project-relative paths over absolute paths.

## Platform-Agnostic Shell Rules

This skill must work from Windows PowerShell, Windows `cmd`, WSL/Linux, Linux devcontainers, and macOS/Linux terminals.

Before running commands, detect the active shell and platform.

POSIX shell:

```bash
uname -a
pwd
command -v mxcli || which mxcli
```

PowerShell:

```powershell
$PSVersionTable.Platform
Get-Location
Get-Command mxcli -ErrorAction SilentlyContinue
```

Windows `cmd`:

```bat
ver
cd
where mxcli
```

Use the `mxcli` available in the current execution environment. Do not assume a Windows `mxcli.exe` is visible inside WSL, or that a Linux `mxcli` is visible from PowerShell.

Prefer project-relative paths:

```bash
mxcli -p ./App.mpr
mxcli check -p ./App.mpr
```

```powershell
mxcli -p .\App.mpr
mxcli check -p .\App.mpr
```

Avoid hardcoded absolute paths unless the user supplied them.

## Windows / WSL Boundary

- Do not mix Windows and POSIX path styles in one command.
- Only convert paths when the command actually crosses the Windows <-> WSL boundary.

WSL conversion helpers:

```bash
wslpath -u 'C:\Users\<user>\Documents\MyMendixApp'
wslpath -w '/mnt/c/Users/<user>/Documents/MyMendixApp'
```

## Executable Resolution

If the user says `mxcli` does not work, check these in order.

POSIX shell / WSL / devcontainer:

```bash
command -v mxcli
mxcli --version
echo "$PATH"
```

PowerShell:

```powershell
Get-Command mxcli -ErrorAction SilentlyContinue
mxcli --version
$env:Path
```

Windows `cmd`:

```bat
where mxcli
mxcli --version
echo %PATH%
```

If `mxcli` is missing, tell the user to install it in the same environment where OpenCode is running.

## Command Examples

### POSIX / WSL / Devcontainer

```bash
mxcli --version
mxcli -p ./App.mpr -c "show modules"
mxcli describe -p ./App.mpr module MyModule
mxcli search -p ./App.mpr "validation"
mxcli callers -p ./App.mpr MyModule.ProcessOrder --transitive
mxcli refs -p ./App.mpr MyModule.Customer
mxcli lint -p ./App.mpr
mxcli report -p ./App.mpr
mxcli test ./tests -p ./App.mpr --list
mxcli check ./changes.mdl -p ./App.mpr --references
mxcli diff -p ./App.mpr ./changes.mdl
mxcli -p ./App.mpr -c "create entity MyModule.Product (Name: string(200) not null)"
```

### PowerShell

```powershell
mxcli --version
mxcli -p .\App.mpr -c "show modules"
mxcli describe -p .\App.mpr module MyModule
mxcli search -p .\App.mpr "validation"
mxcli callers -p .\App.mpr MyModule.ProcessOrder --transitive
mxcli refs -p .\App.mpr MyModule.Customer
mxcli lint -p .\App.mpr
mxcli report -p .\App.mpr
mxcli test .\tests -p .\App.mpr --list
mxcli check .\changes.mdl -p .\App.mpr --references
mxcli diff -p .\App.mpr .\changes.mdl
mxcli -p .\App.mpr -c "create entity MyModule.Product (Name: string(200) not null)"
```

### Windows `cmd`

```bat
mxcli --version
mxcli -p .\App.mpr -c "show modules"
mxcli describe -p .\App.mpr module MyModule
mxcli search -p .\App.mpr "validation"
mxcli callers -p .\App.mpr MyModule.ProcessOrder --transitive
mxcli refs -p .\App.mpr MyModule.Customer
mxcli lint -p .\App.mpr
mxcli report -p .\App.mpr
mxcli test .\tests -p .\App.mpr --list
mxcli check .\changes.mdl -p .\App.mpr --references
mxcli diff -p .\App.mpr .\changes.mdl
mxcli -p .\App.mpr -c "create entity MyModule.Product (Name: string(200) not null)"
```

The agent should pick the form matching the current shell.

## Agent Workflow

1. Detect shell and confirm `mxcli` exists in the current environment.
2. Discover the project `.mpr` path and prefer a project-relative reference.
3. For exploration, use `show`, `describe`, `search`, `callers`, `callees`, `refs`, `impact`, and `context` first.
4. For model changes, draft MDL, run `mxcli check` and `mxcli diff`, then ask before applying.
5. After each applied change, run `mxcli check`, and use `mxcli lint` or `mxcli report` when useful.
6. Use `mxcli init` or `mxcli add-tool` when the user wants Mendix agent setup for OpenCode or other assistants.

## MDL Reference

- `mxcli syntax` shows the full MDL syntax reference.
- `mxcli syntax entity`, `mxcli syntax microflow`, `mxcli syntax page`, and `mxcli syntax search` are the fastest topic lookups.
- Typical safe learning flow: inspect with `show` and `describe`, then validate draft MDL with `mxcli check`, then preview with `mxcli diff`, then apply with confirmation.
