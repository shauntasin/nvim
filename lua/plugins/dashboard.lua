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
			local android = require("config.android").root()
			local function framed(text)
				local padding = 54 - vim.fn.strdisplaywidth(text)
				return "│"
					.. string.rep(" ", math.floor(padding / 2))
					.. text
					.. string.rep(" ", math.ceil(padding / 2))
					.. "│"
			end
			opts.dashboard.preset.header = table.concat({
				"╭──────────────────────────────────────────────────────╮",
				framed("N E O V I M"),
				"╰──────────────────────────────────────────────────────╯",
				"",
				android and "DRONECONTROL   ·   ANDROID / JAVA / XML / JNI" or ("WORKSPACE   ·   " .. cwd),
			}, "\n")
			opts.dashboard.width = 62
			opts.dashboard.sections = {
				{ section = "header", padding = 1 },
				{ section = "keys", gap = 0, padding = 1 },
				{
					text = hostname .. "  ·  " .. uname.sysname .. " / " .. uname.machine .. "  ·  " .. uname.release,
					align = "center",
					hl = "Comment",
				},
				{ text = "Tools: " .. collect_tools(), align = "center", hl = "Comment", padding = 1 },
				{ section = "startup" },
			}

			local keys = opts.dashboard.preset.keys or {}
			if android then
				table.insert(keys, 1, { icon = " ", key = "a", desc = "Android workspace", action = ":Android" })
				table.insert(keys, 2, {
					icon = " ",
					key = "d",
					desc = "Review working changes",
					action = ":DiffviewOpen -C=" .. vim.fn.fnameescape(android),
				})
				table.insert(
					keys,
					3,
					{ icon = " ", key = "i", desc = "Android lint findings", action = ":AndroidLintResults" }
				)
			end
			opts.dashboard.preset.keys = keys
		end,
	},
}
