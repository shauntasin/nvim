local M = {}

local function root()
	return vim.fn.getcwd()
end

local function term(cmd, opts)
	opts = opts or {}
	vim.cmd("belowright split")
	vim.cmd("resize " .. (opts.height or 14))
	vim.fn.termopen(cmd, { cwd = opts.cwd or root(), env = opts.env })
	vim.cmd("startinsert")
end

local function executable(name)
	local path = vim.fn.exepath(name)
	return path ~= nil and path ~= "" and name or nil
end

local function python_cmd()
	if vim.fn.has("win32") == 1 and executable("py") then
		return { "py", "-3" }
	end
	return { executable("python") or executable("python3") or "python" }
end

local function append(list, items)
	local out = vim.deepcopy(list)
	vim.list_extend(out, items)
	return out
end

local function ps_quote(value)
	return "'" .. tostring(value):gsub("'", "''") .. "'"
end

function M.python_run(args)
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.notify("No Python file open", vim.log.levels.WARN)
		return
	end

	term(append(python_cmd(), append({ file }, args or {})))
end

function M.python_test(args)
	local test_runner = vim.fn.executable("pytest") == 1 and "pytest" or nil
	if test_runner then
		term(append({ test_runner }, args or {}))
		return
	end

	term(append(python_cmd(), append({ "-m", "pytest" }, args or {})))
end

function M.cmake_configure(args)
	term(append({
		"cmake",
		"-S",
		".",
		"-B",
		"build",
		"-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
	}, args or {}))
end

function M.cmake_build(args)
	term(append({ "cmake", "--build", "build", "--config", "Debug", "--parallel" }, args or {}))
end

function M.cmake_test(args)
	term(append({ "ctest", "--test-dir", "build", "--output-on-failure", "-C", "Debug" }, args or {}))
end

function M.cpp_run()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.notify("No C/C++ file open", vim.log.levels.WARN)
		return
	end

	local out = vim.fs.joinpath(vim.fn.stdpath("cache"), "nvim-cpp-run.exe")
	local compiler = executable("clang++") or executable("g++") or "cl"
	local script

	if compiler == "cl" then
		script = ("cl /EHsc %s /Fe:%s; if ($LASTEXITCODE -eq 0) { & %s }")
			:format(ps_quote(file), ps_quote(out), ps_quote(out))
	else
		script = ("%s -std=c++20 -g %s -o %s; if ($LASTEXITCODE -eq 0) { & %s }")
			:format(compiler, ps_quote(file), ps_quote(out), ps_quote(out))
	end

	term({ "powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", script })
end

function M.setup()
	if M._did_setup then
		return
	end
	M._did_setup = true

	vim.api.nvim_create_user_command("PythonRun", function(opts)
		M.python_run(opts.fargs)
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("PythonTest", function(opts)
		M.python_test(opts.fargs)
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("CmakeConfigure", function(opts)
		M.cmake_configure(opts.fargs)
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("CmakeBuild", function(opts)
		M.cmake_build(opts.fargs)
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("CmakeTest", function(opts)
		M.cmake_test(opts.fargs)
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("CppRun", function()
		M.cpp_run()
	end, {})
end

return M
