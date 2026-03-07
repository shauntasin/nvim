return {
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "Lazygit" },
			{ "<leader>gF", "<cmd>LazyGitCurrentFile<cr>", desc = "Lazygit Current File History" },
			{ "<leader>gf", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "Lazygit Current File" },
			{ "<leader>gC", "<cmd>LazyGitConfig<cr>", desc = "Lazygit Config" },
		},
	},
}
