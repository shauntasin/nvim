return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			clangd = {
				root_dir = function(fname)
					local util = require("lspconfig.util")
					return util.root_pattern(
						"wscript",
						"waf",
						".px4board",
						"platforms",
						"boards",
						".git"
					)(fname)
				end,
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=never",
				},
			},
			cmake = {},
			fsautocomplete = false,
			omnisharp = {
				cmd = (function()
					local bin = vim.fn.has("win32") == 1 and "omnisharp.cmd" or "omnisharp"
					local path = vim.fn.exepath(bin)
					local executable = path ~= nil and path ~= "" and path or bin

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
				root_dir = function(fname)
					local util = require("lspconfig.util")
					return util.root_pattern(
						"*.slnx",
						"*.sln",
						"*.csproj",
						"*.fsproj",
						"*.vbproj",
						"omnisharp.json",
						"function.json"
					)(fname)
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
			pyright = {},
			rust_analyzer = {},
		},
	},
}
