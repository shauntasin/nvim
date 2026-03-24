# .NET / WPF Guide

This guide explains the C#/.NET/WPF support added to this Neovim config, where that support lives, and how to use it without guessing.

## What Changed

- LazyVim DAP support was enabled so .NET debugging can use `nvim-dap`, `nvim-dap-ui`, and `netcoredbg`.
- OmniSharp was tightened up so it starts with the proper language-server flags on Windows and keeps Roslyn analyzer support enabled.
- `.xaml` and `.axaml` files are now detected explicitly and routed through the XML parser/syntax stack.
- XML/XAML formatting now prefers `xmlformatter`.
- Repo-local `.NET` commands were added for restore, build, run, test, and watch.
- Repo-local DAP configs were added for launching the nearest built project or attaching to a running `dotnet` process.

## Where The Changes Live

- `init.lua`
  Loads the .NET bootstrap early so XAML filetype detection is available before the rest of LazyVim starts.
- `lua/config/dotnet.lua`
  Contains project discovery, `.xaml`/`.axaml` filetype registration, XML Treesitter mapping, and the `:Dotnet*` commands.
- `lua/plugins/dotnet.lua`
  Adds Treesitter parsers, `xmlformatter`, .NET DAP configs, and the DAP UI layout.
- `lua/plugins/lsp.lua`
  Contains the OmniSharp command and LSP behavior overrides.
- `lua/config/keymaps.lua`
  Contains the `.NET` workflow keymaps.
- `lazyvim.json`
  Enables LazyVim's DAP core extra.

## First-Time Setup

1. Start Neovim in this config so Lazy can install any missing plugins.
2. Run `:Mason` and confirm these tools exist:
   - `omnisharp`
   - `netcoredbg`
   - `csharpier`
   - `xmlformatter`
3. Open a `.sln`, `.slnx`, or `.csproj` project root.
4. Run `:LspInfo` if you want to verify that `omnisharp` attached.

## Project Discovery Rules

The helper commands search upward from the current buffer location.

- Build/test/restore target selection:
  Prefers the nearest `.sln` or `.slnx`. If no solution is found, it falls back to the nearest project file.
- Run/watch target selection:
  Requires a project file because `dotnet run` and `dotnet watch run` need a runnable project.
- Debug DLL suggestion:
  Looks in `bin/Debug/<target-framework>/` first, then falls back to other matching `bin` outputs.

This means you should usually work with a file inside the solution or project you want to operate on.

## Daily Workflow

### Restore, Build, Run, Test

Commands:

- `:DotnetRestore`
- `:DotnetBuild`
- `:DotnetRun`
- `:DotnetTest`
- `:DotnetWatch`

Keymaps:

- `<leader>nR` for restore
- `<leader>nb` for build
- `<leader>nr` for run
- `<leader>nt` for test
- `<leader>nw` for `dotnet watch run`

Behavior:

- These commands open a terminal split at the bottom.
- The split enters insert mode automatically.
- Restore/build/test can operate at the solution level.
- Run/watch operate on the nearest project file.

Recommended loop for WPF work:

1. Open the project from inside a `.sln` or `.csproj`.
2. Run `<leader>nR` once after dependency or SDK changes.
3. Use `<leader>nb` to produce the DLL for debugging.
4. Use `<leader>nw` while iterating on the app.
5. Use DAP when you need breakpoints and state inspection.

## Debugging

The config uses `netcoredbg` through `nvim-dap`.

Available debug actions come from LazyVim's DAP extra:

- `<leader>db` toggles a breakpoint
- `<leader>dc` continues or starts the selected debug configuration
- `<leader>di` steps into
- `<leader>dO` steps over
- `<leader>do` steps out
- `<leader>dt` terminates the session
- `<leader>du` toggles the DAP UI

Configured .NET debug entries:

- `Launch nearest project`
- `Attach to dotnet process`

How to launch:

1. Build first with `<leader>nb`.
2. Set a breakpoint with `<leader>db`.
3. Press `<leader>dc`.
4. Choose `Launch nearest project`.
5. If prompted for a DLL path, accept the suggested path if it is correct, or point it at your built DLL manually.

How to attach:

1. Start the app outside DAP, for example with `<leader>nr` or `<leader>nw`.
2. Press `<leader>dc`.
3. Choose `Attach to dotnet process`.
4. Pick the relevant `dotnet` or application process from the picker.

Notes:

- The DAP UI opens automatically when a session starts.
- The DAP UI closes automatically when the session exits or terminates.
- If the wrong DLL is suggested, the project likely has multiple target frameworks or has not been built yet.

## C# Editing And OmniSharp

This setup keeps OmniSharp as the main C# language server.

Enabled behavior includes:

- Roslyn analyzers
- import completion
- organize imports on format
- EditorConfig-aware formatting behavior
- project-root detection for `.sln`, `.slnx`, `.csproj`, `.fsproj`, and `.vbproj`

Practical effect:

- C# navigation and diagnostics should be more reliable on Windows.
- OmniSharp should resolve solution/project roots more predictably.
- Definition handling stays compatible with `omnisharp-extended-lsp.nvim`.

## XAML And AXAML Support

This config does not treat XAML as plain text anymore.

What you get:

- `.xaml` files are assigned the `xaml` filetype
- `.axaml` files are assigned the `axaml` filetype
- both are backed by the XML Treesitter parser
- XML comment strings are applied: `<!-- comment -->`
- formatting is routed through `xmlformatter`

Practical effect:

- syntax and formatting are much less fragile
- commenting behavior is correct for markup files
- the same XML formatting path works for `.xml`, `.xaml`, and `.axaml`

## Live Reload And "Live Renderer"

The current implementation gives you a usable hot-reload workflow, not an embedded Neovim visual designer.

What is supported:

- `:DotnetWatch` and `<leader>nw` run `dotnet watch run`
- this is the intended WPF iteration loop in this config

What is not currently supported:

- a XAML designer inside Neovim
- a visual tree inspector built into this repo
- a true in-editor live preview renderer

Important distinction:

- WPF hot reload happens through the .NET SDK and your running app window
- it does not render the UI inside Neovim itself

If you want a real visual renderer later, that would be a separate feature and likely a separate plugin or external integration.

## Troubleshooting

If OmniSharp is not attaching:

- open the project from a real `.sln` or `.csproj` root
- run `:LspInfo`
- check `:Mason` and confirm `omnisharp` is installed

If debugging does not start:

- confirm `netcoredbg` is installed in `:Mason`
- run `<leader>nb` first
- verify the DLL path you selected actually exists under `bin/Debug/...`

If XAML formatting does not run:

- confirm `xmlformatter` is installed in `:Mason`
- check the buffer filetype with `:set filetype?`
- `.xaml` should report `xaml`
- `.axaml` should report `axaml`

If `dotnet watch` does not hot reload a change:

- make sure you launched a runnable project, not only a solution
- some changes still require a restart depending on project type and SDK support
- XAML hot reload behavior still depends on the actual application and installed .NET SDK features

## Efficient Usage Pattern

For normal feature work:

1. Open a file inside the target solution.
2. Run `<leader>nb`.
3. Use `<leader>dc` when you need breakpoints.
4. Use `<leader>nw` when you need faster edit/run iteration.
5. Keep `<leader>du` nearby for watches, locals, stacks, and REPL.

For markup-heavy WPF work:

1. Edit `.xaml` with the XML-backed support.
2. Run formatting after major markup edits.
3. Use `<leader>nw` for hot reload testing.
4. Switch to DAP only when the issue is logic/state related rather than layout related.
