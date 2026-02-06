return {
	{
		"folke/snacks.nvim",
		opts = function(_, opts)
			local uv = vim.uv or vim.loop
			local uname = uv.os_uname()
			local hostname = vim.fn.hostname()

			opts.dashboard = opts.dashboard or {}
			opts.dashboard.preset = opts.dashboard.preset or {}
			opts.dashboard.preset.header = table.concat({
				"System: " .. uname.sysname .. " (" .. uname.machine .. ")",
				"Release: " .. uname.release,
				"Version: " .. uname.version,
				"Host: " .. hostname,
			}, "\n")
		end,
	},
}
