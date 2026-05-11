local function root()
	if _G.LazyVim and LazyVim.root then
		return LazyVim.root.get()
	end
	return vim.fn.getcwd()
end

local function has(name)
	return vim.fn.executable(name) == 1
end

local apps = {
	lazygit = {
		label = "LazyGit",
		cmd = { "lazygit" },
		requires = { "lazygit" },
	},
	btop = {
		label = "btop",
		cmd = { "btop" },
		requires = { "btop" },
	},
	btm = {
		label = "bottom",
		cmd = { "btm" },
		requires = { "btm" },
	},
	fzf = {
		label = "fzf",
		cmd = { "fzf" },
		requires = { "fzf" },
	},
	rg_fzf = {
		label = "ripgrep + fzf",
		cmd = { "zsh", "-c", "rg --hidden --smart-case --line-number . | fzf" },
		requires = { "rg", "fzf" },
	},
	fastfetch = {
		label = "fastfetch",
		cmd = { "fastfetch" },
		requires = { "fastfetch" },
		keep_open = true,
		always_show = true,
		fallback_cmd = function()
			return { "zsh", "-c", "echo 'fastfetch not found. Install: brew install fastfetch'; sleep 3" }
		end,
	},
	zsh = {
		label = "Zsh",
		cmd = { "zsh" },
		requires = { "zsh" },
		keep_open = true,
	},
	python = {
		label = "Python REPL",
		cmd = { "python3" },
		requires = { "python3" },
		keep_open = true,
	},
	node = {
		label = "Node REPL",
		cmd = { "node" },
		requires = { "node" },
		keep_open = true,
	},
	yazi = {
		label = "yazi",
		cmd = { "yazi" },
		requires = { "yazi" },
	},
	lf = {
		label = "lf",
		cmd = { "lf" },
		requires = { "lf" },
	},
}

local function command(app)
	return type(app.cmd) == "function" and app.cmd() or app.cmd
end

local function missing(app)
	for _, name in ipairs(app.requires or {}) do
		if not has(name) then
			return name
		end
	end
end

local function available()
	local names = {}
	for name, app in pairs(apps) do
		if app.always_show or not missing(app) then
			table.insert(names, name)
		end
	end
	table.sort(names)
	return names
end

local function launch(name)
	if not name or name == "" then
		return vim.ui.select(available(), { prompt = "TUI app" }, function(choice)
			if choice then
				launch(choice)
			end
		end)
	end

	local app = apps[name]
	if not app then
		vim.notify("Unknown TUI app: " .. name, vim.log.levels.WARN)
		return
	end

	local miss = missing(app)
	if miss then
		if app.fallback_cmd then
			Snacks.terminal.toggle(command({ cmd = app.fallback_cmd, keep_open = true }), {
				cwd = root(),
				interactive = true,
				auto_close = false,
				win = {
					position = "float",
					width = 0.92,
					height = 0.9,
					border = "rounded",
					title = " " .. app.label .. " ",
					title_pos = "center",
				},
			})
			return
		end
		vim.notify("Missing TUI executable: " .. miss, vim.log.levels.WARN)
		return
	end

	Snacks.terminal.toggle(command(app), {
		cwd = root(),
		interactive = true,
		auto_close = not app.keep_open,
		win = {
			position = "float",
			width = 0.92,
			height = 0.9,
			border = "rounded",
			title = " " .. app.label .. " ",
			title_pos = "center",
		},
	})
end

return {
	{
		"folke/snacks.nvim",
		init = function()
			vim.api.nvim_create_user_command("Tui", function(opts)
				require("lazy").load({ plugins = { "snacks.nvim" } })
				launch(opts.args)
			end, {
				nargs = "?",
				complete = function()
					return available()
				end,
			})
		end,
		keys = {
			{
				"<leader>T",
				function()
					launch()
				end,
				desc = "TUI launcher",
			},
			{
				"<leader>TB",
				function()
					launch("btm")
				end,
				desc = "bottom monitor",
			},
			{
				"<leader>Tb",
				function()
					launch("btop")
				end,
				desc = "btop monitor",
			},
			{
				"<leader>Tf",
				function()
					launch("fzf")
				end,
				desc = "fzf",
			},
			{
				"<leader>Tg",
				function()
					launch("lazygit")
				end,
				desc = "LazyGit terminal",
			},
			{
				"<leader>Th",
				function()
					launch("fastfetch")
				end,
				desc = "fastfetch",
			},
			{
				"<leader>Tn",
				function()
					launch("node")
				end,
				desc = "Node REPL",
			},
			{
				"<leader>Tp",
				function()
					launch("python")
				end,
				desc = "Python REPL",
			},
			{
				"<leader>Tr",
				function()
					launch("rg_fzf")
				end,
				desc = "ripgrep fzf",
			},
			{
				"<leader>Ts",
				function()
					launch("zsh")
				end,
				desc = "Zsh shell",
			},
			{
				"<leader>Ty",
				function()
					launch("yazi")
				end,
				desc = "yazi",
			},
		},
	},
	{
		"folke/which-key.nvim",
		opts = function(_, opts)
			opts.spec = opts.spec or {}
			table.insert(opts.spec, { "<leader>T", group = "TUI" })
		end,
	},
}
