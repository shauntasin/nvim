vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
local undodir = vim.fs.joinpath(vim.fn.stdpath("state"), "undo")
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 13
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 10
vim.opt.pumheight = 12
vim.opt.confirm = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.shada = "'100,<50,s10,h"
vim.opt.synmaxcol = 240
vim.opt.redrawtime = 10000

if vim.fn.executable("rg") == 1 then
	vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --glob=!**/.git/**"
	vim.opt.grepformat = "%f:%l:%c:%m"
end

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

--vim.opt.colorcolumn = "80"
