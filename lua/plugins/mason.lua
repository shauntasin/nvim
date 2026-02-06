return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		ensure_installed = {
			"omnisharp",
			"stylua",
			"shellcheck",
			"shfmt",
			"flake8",
			"lua-language-server",
			"pyright",
			"typescript-language-server",
			"prettierd",
		},
		run_on_start = true,
	},
}
