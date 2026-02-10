return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			clangd = {
				root_dir = function(fname)
					local util = require("lspconfig.util")
					return util.root_pattern("wscript", "waf", ".git")(fname)
				end,
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=never",
				},
			},
			fsautocomplete = false,
			omnisharp = {
				cmd = (function()
					local bin = vim.fn.has("win32") == 1 and "omnisharp.cmd" or "omnisharp"
					local path = vim.fn.exepath(bin)
					if path ~= nil and path ~= "" then
						return { path }
					end
					return { bin }
				end)(),
				settings = {
					FormattingOptions = {
						OrganizeImports = true,
					},
					RoslynExtensionsOptions = {
						EnableAnalyzersSupport = true,
						EnableImportCompletion = true,
					},
				},
			},
			pyright = {},
			rust_analyzer = {},
		},
	},
}
