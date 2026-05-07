return {
	{ "nvim-neotest/nvim-nio", lazy = true },
	{
		"nvim-neotest/neotest",
		lazy = true,
		cmd = "Neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
		},
		keys = {
			{ "<leader>t", "", desc = "+test" },
			{
				"<leader>ta",
				function()
					require("neotest").run.attach()
				end,
				desc = "Attach to test",
			},
			{ "<leader>tf", "<cmd>Neotest run file<cr>", desc = "Run test file" },
			{
				"<leader>tl",
				function()
					require("neotest").run.run_last()
				end,
				desc = "Run last test",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end,
				desc = "Test output",
			},
			{
				"<leader>tr",
				function()
					require("neotest").run.run()
				end,
				desc = "Run nearest test",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Test summary",
			},
			{
				"<leader>tS",
				function()
					require("neotest").run.stop()
				end,
				desc = "Stop test",
			},
			{
				"<leader>tt",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run test file",
			},
			{
				"<leader>tT",
				function()
					require("neotest").run.run(vim.uv.cwd())
				end,
				desc = "Run all tests",
			},
			{
				"<leader>tw",
				function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end,
				desc = "Watch test file",
			},
		},
	},
}
