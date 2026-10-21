return {
	{
		"folke/snacks.nvim",
		keys = {
			{ "<leader>A", "<cmd>Android<cr>", desc = "Android action menu" },
			{ "<leader>ma", "<cmd>Android<cr>", desc = "Android actions" },
			{ "<leader>mb", "<cmd>AndroidBuild<cr>", desc = "Build debug APKs" },
			{ "<leader>mt", "<cmd>AndroidTest<cr>", desc = "Gradle unit tests" },
			{ "<leader>ml", "<cmd>AndroidLint<cr>", desc = "Run Android lint" },
			{ "<leader>mq", "<cmd>AndroidLintResults<cr>", desc = "Browse lint findings" },
			{
				"<leader>mf",
				function()
					require("config.android").files("source")
				end,
				desc = "Android source files",
			},
			{
				"<leader>mx",
				function()
					require("config.android").files("resources")
				end,
				desc = "Resources / manifests",
			},
			{
				"<leader>mc",
				function()
					require("config.android").files("build")
				end,
				desc = "Gradle / JNI build files",
			},
			{
				"<leader>ms",
				function()
					require("config.android").grep()
				end,
				desc = "Search Android source",
			},
			{ "<leader>mr", "<cmd>AndroidResource<cr>", desc = "Resource under cursor" },
			{ "<leader>md", "<cmd>AndroidDevices<cr>", desc = "Select Android device" },
			{ "<leader>me", "<cmd>AndroidRun<cr>", desc = "Install / open offline emulator" },
			{ "<leader>mi", "<cmd>AndroidStudio<cr>", desc = "Open Android Studio" },
			{ "<leader>mL", "<cmd>AndroidLogcat<cr>", desc = "Device logcat" },
			{ "<leader>mo", "<cmd>AndroidOutput<cr>", desc = "Gradle output" },
			{ "<leader>mS", "<cmd>AndroidStop<cr>", desc = "Stop Gradle task" },
			{ "<leader>mR", "<cmd>AndroidReview<cr>", desc = "Review mode (buffer)" },
			{
				"<leader>mB",
				function()
					require("config.android").branch_diff()
				end,
				desc = "Diff against upstream/main",
			},
			{
				"<leader>mO",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "Code outline",
			},
		},
	},
	{
		"folke/which-key.nvim",
		opts = function(_, opts)
			opts.spec = opts.spec or {}
			vim.list_extend(
				opts.spec,
				{ { "<leader>m", group = "Android", icon = " " }, { "<leader>gL", group = "GitLab review" } }
			)
		end,
	},
}
