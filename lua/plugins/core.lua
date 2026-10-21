return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "cyberdream",
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		priority = 1000,
		opts = {
			flavour = "latte",
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
	{ "miikanissi/modus-themes.nvim", priority = 1000 },
	{ "rebelot/kanagawa.nvim", lazy = true },
	{ "rose-pine/neovim", lazy = true },
	{ "scottmckendry/cyberdream.nvim", lazy = true },
	{ "edeneast/nightfox.nvim", lazy = true },
	{ "projekt0n/github-nvim-theme", name = "github-theme", lazy = true },
	{ "sainnhe/everforest", lazy = true },
	{ "alexesba/matrix-pro.nvim", lazy = true, name = "matrix-pro" },
	{
		"navarasu/onedark.nvim",
		lazy = true,
		opts = {
			style = "light",
		},
	},
}
