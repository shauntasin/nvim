return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		ensure_installed = {
			"black",
			"debugpy",
			"clang-format",
			"clangd",
			"cmake-language-server",
			"codelldb",
			"omnisharp",
			"ruff",
			"stylua",
			"shellcheck",
			"shfmt",
			"flake8",
			"lua-language-server",
			"pyright",
		},
		run_on_start = false,
		start_delay = 3000,
	},
}
