local themes = {
	"catppuccin",
	"tokyonight-night",
	"tokyonight-moon",
	"kanagawa-wave",
	"kanagawa-dragon",
	"cyberdream",
	"modus_vivendi",
	"modus_operandi",
}

local function apply_theme(name)
	local ok, err = pcall(vim.cmd.colorscheme, name)
	if not ok then
		vim.notify("Failed to load colorscheme " .. name .. ": " .. err, vim.log.levels.ERROR)
	end
end

local function pick_theme()
	vim.ui.select(themes, { prompt = "Colorscheme" }, function(choice)
		if choice then
			apply_theme(choice)
		end
	end)
end

local function next_theme()
	local current = vim.g.colors_name
	local index = 0
	for i, name in ipairs(themes) do
		if name == current then
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
