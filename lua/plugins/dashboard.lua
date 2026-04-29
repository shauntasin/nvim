return {
	{
		"folke/snacks.nvim",
		opts = function(_, opts)
			local uv = vim.uv or vim.loop
			local uname = uv.os_uname()
			local hostname = vim.fn.hostname()
			local cwd = vim.fn.fnamemodify(vim.uv.cwd() or vim.fn.getcwd(), ":t")

			opts.dashboard = opts.dashboard or {}
			opts.dashboard.preset = opts.dashboard.preset or {}
			opts.dashboard.preset.header = table.concat({
				"╔════════════════════════════════════════════════════════════╗",
				"║                        SYSTEM INFO                         ║",
				"╚════════════════════════════════════════════════════════════╝",
				"",
				"Host      : " .. hostname,
				"System    : " .. uname.sysname .. " / " .. uname.machine,
				"Release   : " .. uname.release,
				"Project   : " .. cwd,
				"Stacks    : .NET WPF  |  Python AI/ML  |  C++ / Game Dev",
				"Tooling   : Omnisharp + Pyright/Ruff + Clangd/CMake",
			}, "\n")
			opts.dashboard.sections = opts.dashboard.sections or {}
			opts.dashboard.preset.keys = vim.list_extend(opts.dashboard.preset.keys or {}, {
				{ icon = "N ", key = "b", desc = ".NET build", action = ":DotnetBuild" },
				{ icon = "P ", key = "p", desc = "Python file", action = ":PythonRun" },
				{ icon = "C ", key = "c", desc = "CMake build", action = ":CmakeBuild" },
				{ icon = "T ", key = "t", desc = "Tool install", action = ":MasonToolsInstall" },
			})
		end,
	},
}
