return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "torte",
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "mocha",
			background = {
				light = "latte",
				dark = "mocha",
			},
			integrations = {
				cmp = true,
				gitsigns = true,
				mason = true,
				neotest = true,
				noice = true,
				notify = true,
				telescope = true,
				treesitter = true,
				which_key = true,
			},
		},
	},
	{ "folke/tokyonight.nvim", lazy = true },
	{ "rebelot/kanagawa.nvim", lazy = true },
	{ "scottmckendry/cyberdream.nvim", lazy = true },
	{ "miikanissi/modus-themes.nvim", cmd = "ModusThemes" },
}
