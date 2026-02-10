-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local ardupilot = vim.api.nvim_create_augroup("ardupilot_filetypes", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = ardupilot,
	pattern = { "wscript", "wscript_*" },
	callback = function()
		vim.bo.filetype = "python"
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = ardupilot,
	pattern = { "*.parm", "*.param" },
	callback = function()
		vim.bo.filetype = "dosini"
	end,
})
