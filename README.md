# custom_nvim

Personal Neovim configuration built on LazyVim with a focused, minimal setup.

## Highlights
- Base: LazyVim + lazy.nvim
- Plugins: catppuccin, trouble.nvim, nvim-cmp, telescope.nvim, nvim-lspconfig, nvim-treesitter, lualine.nvim, Comment.nvim, lazydev.nvim, vim-be-good
- Languages: Lua, Python, TypeScript/TSX, JavaScript, JSON, YAML, Bash, HTML, Markdown, Vimscript

## Install
1. Backup any existing Neovim config.
2. Place this repo at `~/.config/nvim`.
3. Start Neovim and let lazy.nvim install plugins.

## Notes
- Tooling is managed via Mason (formatters/linters/LSPs configured in `lua/plugins/core.lua`).
