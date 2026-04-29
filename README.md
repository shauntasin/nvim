# custom_nvim

Personal Windows-first Neovim configuration built on LazyVim with a focused C#/.NET,
Python AI/ML, and C/C++ application workflow.

## Highlights
- Base: LazyVim + lazy.nvim
- Plugins: cyberdream.nvim, trouble.nvim, nvim-cmp, telescope.nvim, nvim-lspconfig, nvim-treesitter, lualine.nvim, Comment.nvim, lazydev.nvim, lazygit.nvim, OmniSharp, nvim-dap, nvim-dap-ui
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
- SSH and tunneling commands:
  - `:SSHTerm user@host`: open SSH terminal in a split
  - `:TunnelLocal <name> <local_port> <remote_host> <remote_port> [ssh_host]`: local port forward (`-L`)
  - `:TunnelRemote <name> <remote_port> <local_host> <local_port> [ssh_host]`: remote port forward (`-R`)
  - `:TunnelSocks <name> <local_port> <ssh_host>`: dynamic SOCKS proxy (`-D`)
  - `:TunnelStop <name>`: stop a running tunnel by name
- SSH/tunnel leader shortcuts (command prefill):
  - `<leader>ss`: `:SSHTerm`
  - `<leader>sl`: `:TunnelLocal`
  - `<leader>sr`: `:TunnelRemote`
  - `<leader>sd`: `:TunnelSocks`
  - `<leader>sx`: `:TunnelStop`
- ArduPilot keymaps:
  - `<leader>ac`: `./waf configure --board sitl`
  - `<leader>ab`: `./waf copter`
  - `<leader>as`: `./waf copter --run`
- PX4 keymaps:
  - `<leader>pb`: `make px4_sitl_default`
  - `<leader>ps`: `PX4_SIM_MODEL=iris make px4_sitl_default gazebo`
