local M = {}

local project_patterns = { "*.csproj", "*.fsproj", "*.vbproj" }
local solution_patterns = { "*.sln", "*.slnx" }

local function normalize(path)
	if not path or path == "" then
		return ""
	end
	return vim.fs.normalize(path)
end

local function current_cwd()
	return normalize(vim.uv.cwd() or vim.fn.getcwd())
end

local function parent_dirs(start_dir)
	local dir = normalize(start_dir)
	local dirs = { dir ~= "" and dir or current_cwd() }

	for parent in vim.fs.parents(dirs[1]) do
		table.insert(dirs, parent)
	end

	return dirs
end

local function find_first(patterns, start_dir)
	for _, dir in ipairs(parent_dirs(start_dir or M.current_dir())) do
		for _, pattern in ipairs(patterns) do
			local matches = vim.fn.globpath(dir, pattern, false, true)
			if #matches > 0 then
				table.sort(matches)
				return normalize(matches[1])
			end
		end
	end
end

local function read_file(path)
	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok then
		return ""
	end
	return table.concat(lines, "\n")
end

local function read_tag(xml, tag)
	local value = xml:match("<" .. tag .. ">([^<]+)</" .. tag .. ">")
	if value and value ~= "" then
		return vim.trim(value)
	end
end

local function read_first_framework(xml)
	local frameworks = read_tag(xml, "TargetFrameworks")
	if not frameworks then
		return nil
	end

	local first = vim.split(frameworks, ";", { plain = true, trimempty = true })[1]
	if first and first ~= "" then
		return vim.trim(first)
	end
end

local function glob_first(pattern)
	local matches = vim.fn.glob(pattern, false, true)
	if #matches == 0 then
		return nil
	end
	table.sort(matches)
	return normalize(matches[1])
end

local function run_in_split(cmd, opts)
	opts = opts or {}

	vim.cmd("belowright split")
	vim.cmd("resize " .. (opts.height or 14))
	vim.fn.termopen(cmd, {
		cwd = opts.cwd or M.find_workspace_root(),
		env = opts.env,
	})
	vim.cmd("startinsert")
end

local function run_dotnet(args, opts)
	local cmd = { "dotnet" }
	vim.list_extend(cmd, args)
	run_in_split(cmd, opts)
end

local function with_extra_args(base, extra)
	local args = vim.deepcopy(base)
	for _, arg in ipairs(extra or {}) do
		table.insert(args, arg)
	end
	return args
end

local function require_project(action)
	local project = M.find_project()
	if project then
		return project
	end

	vim.notify("No .NET project found for " .. action, vim.log.levels.WARN)
end

function M.current_dir()
	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname ~= "" then
		return normalize(vim.fs.dirname(bufname))
	end

	return current_cwd()
end

function M.find_project(start_dir)
	return find_first(project_patterns, start_dir)
end

function M.find_solution(start_dir)
	return find_first(solution_patterns, start_dir)
end

function M.find_build_target(start_dir)
	return M.find_solution(start_dir) or M.find_project(start_dir)
end

function M.find_workspace_root(start_dir)
	local solution = M.find_solution(start_dir)
	if solution then
		return normalize(vim.fs.dirname(solution))
	end

	local project = M.find_project(start_dir)
	if project then
		return normalize(vim.fs.dirname(project))
	end

	return normalize(start_dir or M.current_dir())
end

function M.project_metadata(project)
	local xml = read_file(project)
	local assembly_name = read_tag(xml, "AssemblyName") or vim.fn.fnamemodify(project, ":t:r")

	return {
		project = normalize(project),
		dir = normalize(vim.fs.dirname(project)),
		assembly_name = assembly_name,
		target_framework = read_tag(xml, "TargetFramework") or read_first_framework(xml),
		configuration = read_tag(xml, "Configuration") or "Debug",
	}
end

function M.find_launch_dll(project)
	project = project or M.find_project()
	if not project then
		return nil
	end

	local meta = M.project_metadata(project)
	local dll_name = meta.assembly_name .. ".dll"
	local base = vim.fs.joinpath(meta.dir, "bin")
	local candidates = {}

	if meta.target_framework then
		table.insert(candidates, vim.fs.joinpath(base, meta.configuration, meta.target_framework, dll_name))
	end

	table.insert(candidates, vim.fs.joinpath(base, meta.configuration, "*", dll_name))
	table.insert(candidates, vim.fs.joinpath(base, "Debug", "*", dll_name))
	table.insert(candidates, vim.fs.joinpath(base, "Release", "*", dll_name))

	for _, candidate in ipairs(candidates) do
		local match = candidate:find("*", 1, true) and glob_first(candidate) or nil
		if match then
			return match
		end

		if vim.fn.filereadable(candidate) == 1 then
			return normalize(candidate)
		end
	end

	if meta.target_framework then
		return normalize(vim.fs.joinpath(base, meta.configuration, meta.target_framework, dll_name))
	end

	return normalize(vim.fs.joinpath(base, meta.configuration, dll_name))
end

function M.select_launch_dll()
	local suggested = M.find_launch_dll() or (M.find_workspace_root() .. "/")
	return vim.fn.input("Path to dll: ", suggested, "file")
end

function M.dotnet_restore(extra_args)
	local target = M.find_build_target()
	local args = { "restore" }
	if target then
		table.insert(args, target)
	end

	run_dotnet(with_extra_args(args, extra_args), { cwd = M.find_workspace_root() })
end

function M.dotnet_build(extra_args)
	local target = M.find_build_target()
	local args = { "build" }
	if target then
		table.insert(args, target)
	end

	run_dotnet(with_extra_args(args, extra_args), { cwd = M.find_workspace_root() })
end

function M.dotnet_test(extra_args)
	local target = M.find_build_target()
	local args = { "test" }
	if target then
		table.insert(args, target)
	end

	run_dotnet(with_extra_args(args, extra_args), { cwd = M.find_workspace_root() })
end

function M.dotnet_run(extra_args)
	local project = require_project("dotnet run")
	if not project then
		return
	end

	run_dotnet(with_extra_args({ "run", "--project", project }, extra_args), { cwd = M.find_workspace_root() })
end

function M.dotnet_watch(extra_args)
	local project = require_project("dotnet watch run")
	if not project then
		return
	end

	run_dotnet(with_extra_args({ "watch", "run", "--project", project }, extra_args), {
		cwd = M.find_workspace_root(),
		env = {
			DOTNET_WATCH_SUPPRESS_EMOJIS = "1",
		},
	})
end

function M.setup()
	if M._did_setup then
		return
	end
	M._did_setup = true

	vim.filetype.add({
		extension = {
			xaml = "xaml",
			axaml = "axaml",
		},
	})

	vim.treesitter.language.register("xml", "xaml")
	vim.treesitter.language.register("xml", "axaml")

	local group = vim.api.nvim_create_augroup("dotnet_xaml_support", { clear = true })

	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = { "xaml", "axaml" },
		callback = function()
			vim.bo.commentstring = "<!-- %s -->"
			vim.bo.syntax = "xml"
		end,
	})

	vim.api.nvim_create_user_command("DotnetRestore", function(opts)
		M.dotnet_restore(opts.fargs)
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("DotnetBuild", function(opts)
		M.dotnet_build(opts.fargs)
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("DotnetTest", function(opts)
		M.dotnet_test(opts.fargs)
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("DotnetRun", function(opts)
		M.dotnet_run(opts.fargs)
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("DotnetWatch", function(opts)
		M.dotnet_watch(opts.fargs)
	end, { nargs = "*" })
end

return M
