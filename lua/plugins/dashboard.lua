local function has_exe(name)
	return vim.fn.executable(name) == 1
end

local function collect_tools()
	local tools = {}
	for _, name in ipairs({ "lazygit", "btop", "btm", "fzf", "rg", "node", "python3", "fastfetch" }) do
		if has_exe(name) then
			table.insert(tools, name)
		end
	end
	return #tools > 0 and table.concat(tools, "  ") or "none detected"
end

return {
	{
		"folke/snacks.nvim",
		opts = function(_, opts)
			local uv = vim.uv or vim.loop
			local uname = uv.os_uname()
			local hostname = vim.fn.hostname()
			local cwd = vim.fn.fnamemodify(uv.cwd() or vim.fn.getcwd(), ":t")

			opts.dashboard = opts.dashboard or {}
			opts.dashboard.preset = opts.dashboard.preset or {}
			opts.dashboard.preset.header = table.concat({
				"============================================================",
				"                         SYSTEM INFO                         ",
				"============================================================",
				"",
				"Host      : " .. hostname,
				"System    : " .. uname.sysname .. " / " .. uname.machine,
				"Release   : " .. uname.release,
				"Project   : " .. cwd,
				"Tools     : " .. collect_tools(),
			}, "\n")

			local keys = opts.dashboard.preset.keys or {}
			vim.list_extend(keys, {})
			opts.dashboard.preset.keys = keys
		end,
	},
}
