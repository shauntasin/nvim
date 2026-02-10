return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				c = { "clang_format" },
				cpp = { "clang_format" },
				json = { "prettierd", "prettier" },
				jsonc = { "prettierd", "prettier" },
				json5 = { "prettierd", "prettier" },
				python = { "ruff_format", "black" },
				rust = { "rustfmt" },
				xml = { "prettierd", "prettier" },
			},
		},
	},
}
