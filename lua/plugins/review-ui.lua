-- Reuse installed UI plugins and the active theme's highlight groups.
return {
	{
		"folke/snacks.nvim",
		opts = {
			picker = { layout = { preset = "default" } },
			styles = { notification = { border = "rounded" } },
		},
	},
	{
		"akinsho/bufferline.nvim",
		opts = { options = { separator_style = "thin", show_close_icon = false, show_buffer_close_icons = false } },
	},
	{
		"dlyongemallo/diffview.nvim",
		opts = {
			diffopt = { algorithm = "histogram", linematch = 60 },
			view = { default = { winbar_info = true } },
			file_panel = { win_config = { width = 34 } },
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			diagnostics = {
				severity_sort = true,
				update_in_insert = false,
				float = { border = "rounded", source = "always" },
			},
		},
	},
}
