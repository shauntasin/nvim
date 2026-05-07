local function mason_package_path(package, ...)
	return vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", package, ...)
end

local function existing_path(path)
	return vim.fn.filereadable(path) == 1 and path or nil
end

return {
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			local debugpy = existing_path(mason_package_path("debugpy", "venv", "Scripts", "python.exe"))
				or existing_path(mason_package_path("debugpy", "venv", "bin", "python"))
				or vim.fn.exepath("python")
				or "python"

			require("dap-python").setup(debugpy)
		end,
		keys = {
			{
				"<leader>dPt",
				function()
					require("dap-python").test_method()
				end,
				desc = "Debug Python test",
			},
			{
				"<leader>dPc",
				function()
					require("dap-python").test_class()
				end,
				desc = "Debug Python class",
			},
		},
	},
	{
		"p00f/clangd_extensions.nvim",
		ft = { "c", "cpp", "objc", "objcpp", "cuda" },
		opts = {
			inlay_hints = { inline = false },
			ast = { role_icons = { type = "T", declaration = "D", expression = "E" } },
		},
	},
	{
		"mfussenegger/nvim-dap",
		optional = true,
		opts = function()
			local dap = require("dap")
			local codelldb = existing_path(mason_package_path("codelldb", "extension", "adapter", "codelldb.exe"))
				or existing_path(mason_package_path("codelldb", "extension", "adapter", "codelldb"))
				or vim.fn.exepath("codelldb")

			if codelldb and codelldb ~= "" then
				dap.adapters.codelldb = {
					type = "server",
					port = "${port}",
					executable = {
						command = codelldb,
						args = { "--port", "${port}" },
					},
				}

				for _, lang in ipairs({ "c", "cpp" }) do
					dap.configurations[lang] = dap.configurations[lang] or {}
					table.insert(dap.configurations[lang], {
						name = "Launch executable",
						type = "codelldb",
						request = "launch",
						program = function()
							return vim.fn.input("Executable: ", vim.fn.getcwd() .. "\\build\\", "file")
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
					})
				end
			end
		end,
	},
	{
		"folke/which-key.nvim",
		opts = function(_, opts)
			opts.spec = opts.spec or {}
			vim.list_extend(opts.spec, {
				{ "<leader>n", group = ".NET / WPF" },
				{ "<leader>p", group = "Python AI/ML" },
				{ "<leader>c", group = "C++ / CMake" },
				{ "<leader>dP", group = "Python debug" },
			})
		end,
	},
}
