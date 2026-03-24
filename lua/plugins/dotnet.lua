local function add_unique(list, items)
	for _, item in ipairs(items) do
		if not vim.tbl_contains(list, item) then
			table.insert(list, item)
		end
	end
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			add_unique(opts.ensure_installed, { "c_sharp", "fsharp", "xml" })
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = function(_, opts)
			add_unique(opts.ensure_installed, { "xmlformatter" })
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft.xml = { "xmlformatter", "prettierd", "prettier" }
			opts.formatters_by_ft.xaml = { "xmlformatter" }
			opts.formatters_by_ft.axaml = { "xmlformatter" }
		end,
	},
	{
		"mfussenegger/nvim-dap",
		optional = true,
		opts = function()
			local dap = require("dap")
			local dotnet = require("config.dotnet")

			local function ensure_config(lang, config)
				dap.configurations[lang] = dap.configurations[lang] or {}

				for _, existing in ipairs(dap.configurations[lang]) do
					if existing.name == config.name then
						return
					end
				end

				table.insert(dap.configurations[lang], 1, config)
			end

			local launch = {
				type = "netcoredbg",
				name = "Launch nearest project",
				request = "launch",
				program = dotnet.select_launch_dll,
				cwd = "${workspaceFolder}",
			}

			local attach = {
				type = "netcoredbg",
				name = "Attach to dotnet process",
				request = "attach",
				processId = require("dap.utils").pick_process,
				cwd = "${workspaceFolder}",
			}

			for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
				ensure_config(lang, vim.deepcopy(launch))
				ensure_config(lang, vim.deepcopy(attach))
			end
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		optional = true,
		opts = {
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.5 },
						{ id = "breakpoints", size = 0.15 },
						{ id = "stacks", size = 0.2 },
						{ id = "watches", size = 0.15 },
					},
					size = 44,
					position = "right",
				},
				{
					elements = {
						{ id = "repl", size = 0.5 },
						{ id = "console", size = 0.5 },
					},
					size = 12,
					position = "bottom",
				},
			},
		},
	},
}
