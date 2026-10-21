# custom_nvim

Personal Neovim configuration built on LazyVim with a focused, minimal setup.

## PDFs

Open `nvim file.pdf`, select a PDF in the explorer, or use `:PdfText path/to/file.pdf`.
PDFs open as read-only extracted text: use `/` to search and normal Vim motions/yanks.
Poppler is required (`brew install poppler`), and is already installed on this Mac.

- `:PdfView` or `<leader>pi` in a PDF: show page images in a right split in Ghostty/Kitty.
- `]p` / `[p` or PageDown / PageUp in the image split: next / previous page.
- `q` in the image split: close the preview.
- `:PdfOpen` or `<leader>po`: open the original PDF in the system viewer (Preview on macOS).
- `:PdfText`: return to searchable text from a page preview.

Scanned PDFs require the page view or system viewer; text extraction does not perform OCR.
Graphical viewing uses Snacks and Poppler; ImageMagick must also be available.

## Highlights
- Base: LazyVim + lazy.nvim
- Plugins: catppuccin, trouble.nvim, nvim-cmp, telescope.nvim, nvim-lspconfig, nvim-treesitter, lualine.nvim, Comment.nvim, lazydev.nvim, vim-be-good, lazygit.nvim, OmniSharp (cross-platform config)
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
