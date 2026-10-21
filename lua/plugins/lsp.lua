return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			clangd = {
				root_dir = function(bufnr, on_dir)
					local util = require("lspconfig.util")
					local fname = vim.api.nvim_buf_get_name(bufnr)
					on_dir(
						util.root_pattern(
							"compile_commands.json",
							"compile_flags.txt",
							"*.uproject",
							"CMakeLists.txt",
							"wscript",
							"waf",
							".px4board",
							"platforms",
							"boards",
							".git"
						)(fname)
					)
				end,
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=never",
					"--completion-style=detailed",
					"--fallback-style=LLVM",
				},
			},
			cmake = {},
			csharp_ls = {
				enabled = false,
			},
			fsautocomplete = false,
			omnisharp = {
				cmd = (function()
					local executable = vim.fn.exepath("omnisharp")
					if executable == nil or executable == "" then
						executable = "omnisharp"
					end
					return {
						executable,
						"-z",
						"--hostPID",
						tostring(vim.fn.getpid()),
						"DotNet:enablePackageRestore=false",
						"--encoding",
						"utf-8",
						"--languageserver",
					}
				end)(),
				mason = false,
				root_dir = function(bufnr, on_dir)
					local util = require("lspconfig.util")
					local fname = vim.api.nvim_buf_get_name(bufnr)
					on_dir(
						util.root_pattern(
							"*.slnx",
							"*.sln",
							"*.csproj",
							"*.fsproj",
							"*.vbproj",
							"omnisharp.json",
							"function.json"
						)(fname)
					)
				end,
				enable_roslyn_analyzers = true,
				organize_imports_on_format = true,
				enable_import_completion = true,
				settings = {
					FormattingOptions = {
						EnableEditorConfigSupport = true,
						OrganizeImports = true,
					},
					MsBuild = {
						LoadProjectsOnDemand = true,
					},
					RoslynExtensionsOptions = {
						EnableAnalyzersSupport = true,
						EnableDecompilationSupport = true,
						EnableImportCompletion = true,
					},
				},
			},
			pyright = {
				settings = {
					python = {
						analysis = {
							autoImportCompletions = true,
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							typeCheckingMode = "basic",
							useLibraryCodeForTypes = true,
						},
					},
				},
			},
			ruff = {
				init_options = {
					settings = {
						lineLength = 100,
					},
				},
			},
			rust_analyzer = {},
		},
	},
}
