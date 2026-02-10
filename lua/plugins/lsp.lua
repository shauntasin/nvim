return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
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
