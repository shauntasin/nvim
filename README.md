# custom_nvim

Personal Windows-first Neovim configuration built on LazyVim with a focused C#/.NET,
Python AI/ML, and C/C++ application workflow.

## Highlights
- Base: LazyVim + lazy.nvim
- Plugins: catppuccin, tokyonight.nvim, kanagawa.nvim, cyberdream.nvim, trouble.nvim, nvim-cmp, telescope.nvim, nvim-lspconfig, nvim-treesitter, lualine.nvim, Comment.nvim, lazydev.nvim, lazygit.nvim, OmniSharp, nvim-dap, nvim-dap-ui
- Languages: Lua, Python, C/C++, C#, F#, JSON, XML, XAML, AXAML, TOML, YAML, Bash, HTML, Markdown, Vimscript
- Startup: LazyVim extras are trimmed to .NET, Python, clangd, Git, JSON, Markdown, TOML, and YAML; Mason tool installation is manual via `:MasonToolsInstall`
- .NET / WPF: OmniSharp with Roslyn analyzers, `netcoredbg` + DAP UI, XML-backed XAML/AXAML editing, and `dotnet watch` helpers for hot reload workflows
- Python AI/ML: Pyright + Ruff, `debugpy`, `pytest`, venv-aware LazyVim Python support, and quick file/test runners
- C/C++ game/application dev: `clangd`, `clangd_extensions.nvim`, CMake LSP, `codelldb`, CMake commands, and Unreal-style root detection via `.uproject`, `.sln`, `.vcxproj`, and `compile_commands.json`
- Formatting: `clang-format` (C/C++), `ruff_format`/`black` (Python), `xmlformatter` (XML/XAML/AXAML), `prettierd` (JSON) via `conform.nvim`

## Install
1. Backup any existing Neovim config.
2. Place this repo at the appropriate config path:
   - macOS/Linux: `~/.config/nvim`
   - Windows: `%LOCALAPPDATA%\nvim`
3. Start Neovim and let lazy.nvim install plugins.

## Notes
- Detailed .NET/WPF usage guide: [docs/dotnet-wpf-guide.md](docs/dotnet-wpf-guide.md)
- Tooling is managed via Mason (see `lua/plugins/mason.lua` and `lua/plugins/dotnet.lua`).
- Install or refresh external language tools manually with `:MasonToolsInstall`; it no longer runs on every startup.
- Formatting is configured in `lua/plugins/formatting.lua` and `lua/plugins/dotnet.lua`.
- .NET / WPF helpers:
  - `:DotnetRestore`, `:DotnetBuild`, `:DotnetRun`, `:DotnetTest`, `:DotnetWatch`
  - `<leader>nR`: restore nearest solution/project
  - `<leader>nb`: build nearest solution/project
  - `<leader>nr`: run nearest project
  - `<leader>nt`: test nearest solution/project
  - `<leader>nw`: `dotnet watch run` for hot reload / XAML iteration
- Python helpers:
  - `:PythonRun [args...]` / `<leader>pr`: run the current file
  - `:PythonTest [args...]` / `<leader>pt`: run `pytest`
  - `<leader>dPt`: debug nearest Python test method
  - `<leader>dPc`: debug nearest Python test class
- C/C++ helpers:
  - `:CmakeConfigure [args...]` / `<leader>cc`: configure `build/` with compile commands
  - `:CmakeBuild [args...]` / `<leader>cb`: build `build/` Debug in parallel
  - `:CmakeTest [args...]` / `<leader>ct`: run CTest from `build/`
  - `:CppRun` / `<leader>cr`: compile and run the current C/C++ file
- DAP keymaps come from LazyVim DAP extra:
  - `<leader>dc`: continue
  - `<leader>db`: toggle breakpoint
  - `<leader>du`: toggle DAP UI
  - `<leader>dt`: terminate
- Git (LazyGit) keymaps:
  - `<leader>gg`: open LazyGit
  - `<leader>gF`: current file history in LazyGit
  - `<leader>gf`: filter LazyGit to current file
  - `<leader>gC`: open LazyGit config
- Themes:
  - `:ThemePick` / `<leader>uC`: pick from installed themes
  - `:ThemeNext` / `<leader>uN`: cycle the curated theme list
- TUI launcher:
  - `:Tui [name]` / `<leader>T`: pick an available terminal UI
  - `<leader>Tg`: LazyGit in a Snacks terminal
  - `<leader>Tb`: `btop`
  - `<leader>TB`: `btm`
  - `<leader>Tf`: `fzf`
  - `<leader>Tr`: `rg` piped through `fzf`
  - `<leader>Th`: `fastfetch` status terminal
  - `<leader>Ts`: PowerShell
  - `<leader>Tp`: Python REPL
  - `<leader>Tn`: Node REPL
- Remote SSH terminal:
  - `:Ssh user@host -p 22`: open a plain SSH session in a Snacks terminal
  - `:Ssh`: prompt for a target such as `user@host` or `user@host -p 2222`
  - `:SshHost`: pick a host from `~/.ssh/config`
  - `:RemoteSSHStatus`: check whether `ssh` and parsed SSH config hosts are available
  - `<leader>rc`: pick a configured host, or prompt when no host config exists
  - `<leader>rs`: prompt for any SSH target
  - `<leader>rh`: pick from `~/.ssh/config`
  - `<leader>rS`: SSH status
- Netrw is enabled; `:Ex`, `:Sex`, `:Vex`, and paths like `scp://user@host//path/file` are available.
- ArduPilot keymaps:
  - `<leader>ac`: `./waf configure --board sitl`
  - `<leader>ab`: `./waf copter`
  - `<leader>as`: `./waf copter --run`
- PX4 keymaps:
  - `<leader>pb`: `make px4_sitl_default`
  - `<leader>ps`: `PX4_SIM_MODEL=iris make px4_sitl_default gazebo`
