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
				-- Prettier has no XML parser here; use LemMinX through LSP fallback.
				xml = {},
			},
		},
	},
}
