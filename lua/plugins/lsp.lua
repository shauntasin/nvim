return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			omnisharp = {
				cmd = (function()
					local ok, registry = pcall(require, "mason-registry")
					if ok then
						local pkg = registry.get_package("omnisharp")
						if pkg and pkg:is_installed() then
							local bin = vim.fn.has("win32") == 1 and "omnisharp.cmd" or "omnisharp"
							return { vim.fs.joinpath(pkg:get_install_path(), "bin", bin) }
						end
					end
					return { "omnisharp" }
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
		},
	},
}
