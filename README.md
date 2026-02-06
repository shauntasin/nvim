# custom_nvim

Personal Neovim configuration built on LazyVim with a focused, minimal setup.

## Highlights
- Base: LazyVim + lazy.nvim
- Plugins: catppuccin, trouble.nvim, nvim-cmp, telescope.nvim, nvim-lspconfig, nvim-treesitter, lualine.nvim, Comment.nvim, lazydev.nvim, vim-be-good, OmniSharp (cross-platform config)
- Languages: Lua, Python, C#, TypeScript/TSX, JavaScript, JSON, XML, YAML, Bash, HTML, Markdown, Vimscript
- Formatting: `prettierd` for JSON/XML via `conform.nvim`

## Install
1. Backup any existing Neovim config.
2. Place this repo at the appropriate config path:
   - macOS/Linux: `~/.config/nvim`
   - Windows: `%LOCALAPPDATA%\nvim`
3. Start Neovim and let lazy.nvim install plugins.

## Notes
- Tooling is managed via Mason (see `lua/plugins/mason.lua`).
- Formatting is configured in `lua/plugins/formatting.lua`.
