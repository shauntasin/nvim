return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				json = { "prettierd", "prettier" },
				jsonc = { "prettierd", "prettier" },
				json5 = { "prettierd", "prettier" },
				xml = { "prettierd", "prettier" },
			},
		},
	},
}
