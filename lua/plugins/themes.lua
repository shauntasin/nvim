local themes = {
	{
		name = "matrix-pro",
		background = "dark",
		before = function()
			require("lazy").load({ plugins = { "matrix-pro" } })
		end,
	},
	{
		name = "matrix-pro-light",
		background = "light",
		before = function()
			require("lazy").load({ plugins = { "matrix-pro" } })
			-- matrix-pro uses background=light for its day variant
			vim.o.background = "light"
			vim.cmd.colorscheme("matrix-pro")
		end,
	},
	{ name = "github_dark_high_contrast", background = "dark" },
	{ name = "catppuccin-mocha", background = "dark" },
	{ name = "catppuccin", background = "light" },
	{ name = "catppuccin-latte", background = "light" },
	{ name = "tokyonight-night", background = "dark" },
	{ name = "tokyonight-moon", background = "dark" },
	{ name = "tokyonight-day", background = "light" },
	{ name = "kanagawa-wave", background = "dark" },
	{ name = "kanagawa-dragon", background = "dark" },
	{ name = "kanagawa-lotus", background = "light" },
	{ name = "cyberdream", background = "dark" },
	{ name = "modus_vivendi", background = "dark" },
	{ name = "modus_operandi", background = "light" },
	{ name = "rose-pine", background = "dark" },
	{ name = "rose-pine-dawn", background = "light" },
	{ name = "dayfox", background = "light" },
	{ name = "dawnfox", background = "light" },
	{ name = "github_light", background = "light" },
	{ name = "github_light_default", background = "light" },
	{ name = "github_light_high_contrast", background = "light" },
	{ name = "github_light_colorblind", background = "light" },
	{ name = "github_light_tritanopia", background = "light" },
	{
		name = "everforest",
		background = "light",
		before = function()
			vim.g.everforest_background = "medium"
			vim.g.everforest_better_performance = 1
		end,
	},
	{
		name = "onedark",
		background = "light",
		before = function()
			require("lazy").load({ plugins = { "onedark.nvim" } })
			require("onedark").setup({ style = "light" })
		end,
	},
}

local function theme_name(theme)
	return type(theme) == "table" and theme.name or theme
end

local function apply_theme(theme)
	local name = theme_name(theme)
	if type(theme) == "table" then
		if theme.background then
			vim.o.background = theme.background
		end
		if theme.before then
			local ok, err = pcall(theme.before)
			if not ok then
				vim.notify("Failed to prepare colorscheme " .. name .. ": " .. err, vim.log.levels.ERROR)
				return
			end
		end
	end

	local ok, err = pcall(vim.cmd.colorscheme, name)
	if not ok then
		vim.notify("Failed to load colorscheme " .. name .. ": " .. err, vim.log.levels.ERROR)
	end
end

local function pick_theme()
	vim.ui.select(themes, {
		prompt = "Colorscheme",
		format_item = theme_name,
	}, function(choice)
		if choice then
			apply_theme(choice)
		end
	end)
end

local function next_theme()
	local current = vim.g.colors_name
	local index = 0
	for i, theme in ipairs(themes) do
		if theme_name(theme) == current then
			index = i
			break
		end
	end
	apply_theme(themes[(index % #themes) + 1])
end

return {
	{
		"LazyVim/LazyVim",
		init = function()
			vim.api.nvim_create_user_command("ThemePick", pick_theme, {})
			vim.api.nvim_create_user_command("ThemeNext", next_theme, {})
		end,
		keys = {
			{ "<leader>uC", pick_theme, desc = "Colorscheme picker" },
			{ "<leader>uN", next_theme, desc = "Next colorscheme" },
		},
	},
}
