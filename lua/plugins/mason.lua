return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		ensure_installed = {
			"stylua",
			"shellcheck",
			"shfmt",
			"flake8",
			"lua-language-server",
			"pyright",
			"typescript-language-server",
		},
		run_on_start = true,
	},
}
