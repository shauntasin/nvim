# custom_nvim

Personal Neovim configuration built on LazyVim with a focused, minimal setup.

## Highlights
- Base: LazyVim + lazy.nvim
- Plugins: catppuccin, trouble.nvim, nvim-cmp, telescope.nvim, nvim-lspconfig, nvim-treesitter, lualine.nvim, Comment.nvim, lazydev.nvim, vim-be-good, OmniSharp (cross-platform config)
- Languages: Lua, Python, C/C++, C#, TypeScript/TSX, JavaScript, JSON, XML, YAML, Bash, HTML, Markdown, Vimscript
- ArduPilot: `clangd` + Treesitter for C/C++, Python support for `wscript`, `.parm`/`.param` detection, and `./waf` terminal keymaps
- PX4: `clangd` root detection for PX4 repos, CMake LSP (`cmake-language-server`), and SITL build/run terminal keymaps
- Formatting: `clang-format` (C/C++), `ruff_format`/`black` (Python), `prettierd` (JSON/XML) via `conform.nvim`

## Install
1. Backup any existing Neovim config.
2. Place this repo at the appropriate config path:
   - macOS/Linux: `~/.config/nvim`
   - Windows: `%LOCALAPPDATA%\nvim`
3. Start Neovim and let lazy.nvim install plugins.

## Notes
- Tooling is managed via Mason (see `lua/plugins/mason.lua`).
- Formatting is configured in `lua/plugins/formatting.lua`.
- ArduPilot keymaps:
  - `<leader>ac`: `./waf configure --board sitl`
  - `<leader>ab`: `./waf copter`
  - `<leader>as`: `./waf copter --run`
- PX4 keymaps:
  - `<leader>pb`: `make px4_sitl_default`
  - `<leader>ps`: `PX4_SIM_MODEL=iris make px4_sitl_default gazebo`
