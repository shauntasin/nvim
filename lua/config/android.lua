local M = { jobs = {}, outputs = {} }
local join = vim.fs.joinpath

-- Prefer the outer Git project: the companion also has its own Gradle wrapper.
function M.root(path)
	path = path or vim.api.nvim_buf_get_name(0)
	if path == "" or path:match("^%w+://") then
		path = vim.fn.getcwd()
	end
	local git = vim.fs.root(path, ".git")
	if git and vim.fn.filereadable(join(git, "gradlew")) == 1 then
		return git
	end
	local root = vim.fs.root(path, { "settings.gradle", "settings.gradle.kts" })
	if root and vim.fn.filereadable(join(root, "gradlew")) == 1 then
		return root
	end
	-- Also support opening Neovim from the containing review workspace.
	local child = join(vim.fn.getcwd(), "dronecontrol")
	if vim.fn.filereadable(join(child, "gradlew")) == 1 then
		return child
	end
end

local function project()
	local root = M.root()
	if not root then
		vim.notify("Open an Android Gradle project first", vim.log.levels.WARN)
	end
	return root
end

function M.module(path)
	path = path or vim.api.nvim_buf_get_name(0)
	if path:find("/MavsdkServerApp/", 1, true) then
		return "MAVSDK"
	end
	return "GCS"
end

function M.command(root, args)
	local helper = join(vim.fs.dirname(root), "setup", "build")
	local cmd
	if vim.fs.basename(root) == "dronecontrol" and vim.fn.executable(helper) == 1 then
		cmd = { helper }
	else
		cmd = { "sh", join(root, "gradlew"), "--max-workers=2", "--console=plain" }
	end
	return vim.list_extend(cmd, args)
end

function M.output()
	local root = project()
	local buf = root and M.outputs[root]
	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		vim.notify("No Android task output in this session", vim.log.levels.INFO)
		return
	end
	vim.cmd("botright 14split")
	vim.api.nvim_win_set_buf(0, buf)
end

function M.gradle(args)
	local root = project()
	if not root then
		return
	end
	if M.jobs[root] then
		vim.notify("An Android task is already running. Use :AndroidStop to cancel.", vim.log.levels.WARN)
		return
	end
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local name = vim.api.nvim_buf_get_name(buf)
		if name:sub(1, #root + 1) == root .. "/" and vim.bo[buf].modified then
			vim.notify("Save project buffers before running Gradle (use :wa)", vim.log.levels.WARN)
			return
		end
	end
	vim.cmd("botright 14new")
	local buf = vim.api.nvim_get_current_buf()
	M.outputs[root] = buf
	vim.bo[buf].bufhidden = "hide"
	local label = table.concat(args, " ")
	local output = {}
	local job = vim.fn.jobstart(M.command(root, args), {
		cwd = root,
		term = true,
		stdout_buffered = true,
		on_stdout = function(_, data)
			-- Capture the raw stream: terminal screen wrapping must not split paths.
			output = vim.tbl_map(function(line)
				return line:gsub("\r", ""):gsub("\27%[[0-9;?]*[A-Za-z]", "")
			end, data)
		end,
		on_exit = function(_, code)
			vim.schedule(function()
				M.jobs[root] = nil
				local lines = output
				local log = join(vim.fn.stdpath("state"), "android", vim.fn.sha256(root):sub(1, 12) .. ".log")
				vim.fn.mkdir(vim.fs.dirname(log), "p")
				vim.fn.writefile(lines, log)
				-- Only recognized compiler locations become quickfix entries.
				local items = {}
				for _, line in ipairs(lines) do
					local file, lnum, severity, message = line:match("^%s*(.-):(%d+):%s*(%a+):%s*(.*)")
					if file and (severity == "error" or severity == "warning") then
						if file:sub(1, 1) ~= "/" then
							file = join(root, file)
						end
						table.insert(items, {
							filename = file,
							lnum = tonumber(lnum),
							text = message,
							type = severity == "error" and "E" or "W",
						})
					end
				end
				vim.fn.setqflist({}, " ", { title = "Gradle: " .. label .. " (exit " .. code .. ")", items = items })
				vim.notify(
					"Gradle " .. label .. ": exit " .. code .. "\nLog: " .. log,
					code == 0 and vim.log.levels.INFO or vim.log.levels.WARN
				)
				vim.cmd("redrawstatus")
			end)
		end,
	})
	if job <= 0 then
		vim.notify("Could not start Gradle", vim.log.levels.ERROR)
		return
	end
	M.jobs[root] = job
	vim.cmd("redrawstatus")
end

function M.stop()
	local root = project()
	if root and M.jobs[root] then
		vim.fn.jobstop(M.jobs[root])
	end
end

local exclude = {
	"**/build/**",
	"**/.gradle/**",
	"**/.cxx/**",
	"**/.git/**",
	"**/.idea/**",
	"**/bin/**",
	"**/libs/**",
	"**/jniLibs/**",
}

local function pick_files(root, title, globs)
	local args = {}
	for _, glob in ipairs(globs or {}) do
		vim.list_extend(args, { "--glob", glob })
	end
	Snacks.picker.files({ cwd = root, title = title, cmd = "rg", args = args, hidden = true, exclude = exclude })
end

function M.files(kind)
	local root = project()
	if not root then
		return
	end
	local globs = {
		source = { "**/*.java", "**/*.kt", "**/*.aidl", "**/*.c", "**/*.h", "**/*.cpp" },
		resources = { "**/res/**", "**/AndroidManifest.xml" },
		build = {
			"**/*.gradle",
			"**/*.gradle.kts",
			"**/*.properties",
			"**/*.mk",
			"**/CMakeLists.txt",
			".gitlab-ci.yml",
		},
	}
	pick_files(root, "Android · " .. (kind or "files"), globs[kind])
end

function M.grep()
	local root = project()
	if root then
		Snacks.picker.grep({ cwd = root, title = "Android · source search", hidden = true, exclude = exclude })
	end
end

function M.resource()
	local root = project()
	if not root then
		return
	end
	local line, col = vim.api.nvim_get_current_line(), vim.api.nvim_win_get_cursor(0)[2] + 1
	local kind, name
	for _, pattern in ipairs({ "R%.([%w_]+)%.([%w_]+)", "@%+?([%w_]+)/([%w_]+)" }) do
		local start = 1
		while true do
			local a, b, k, n = line:find(pattern, start)
			if not a then
				break
			end
			if col >= a and col <= b then
				kind, name = k, n
				break
			end
			start = b + 1
		end
	end
	if not name then
		return M.files("resources")
	end
	if
		vim.tbl_contains(
			{ "layout", "drawable", "mipmap", "menu", "xml", "raw", "anim", "animator", "navigation", "font" },
			kind
		)
	then
		pick_files(root, kind .. "/" .. name, { "**/res/" .. kind .. "*/" .. name .. ".*" })
	else
		Snacks.picker.grep({
			cwd = root,
			title = kind .. "/" .. name .. " definitions",
			exclude = exclude,
			glob = { "**/res/**/*.xml" },
			search = '(name="' .. name .. '"|@\\+id/' .. name .. "\\b)",
			live = false,
		})
	end
end

function M.lint_results()
	local root = project()
	if not root then
		return
	end
	local parser = join(vim.fn.stdpath("config"), "scripts", "android-lint.py")
	vim.system({ "python3", parser, root }, { text = true }, function(result)
		vim.schedule(function()
			if result.code ~= 0 then
				vim.notify(result.stderr or "Cannot read lint reports", vim.log.levels.WARN)
				return
			end
			local parsed = vim.json.decode(result.stdout)
			vim.fn.setqflist({}, " ", {
				title = "Android lint · saved reports (run AndroidLint to refresh)",
				items = parsed.items,
				quickfixtextfunc = function(info)
					local entries = vim.fn.getqflist({ id = info.id, items = 1 }).items
					local lines = {}
					for i = info.start_idx, info.end_idx do
						local item = entries[i]
						local path = vim.api.nvim_buf_get_name(item.bufnr)
						lines[#lines + 1] = ("%s  %-6s  %s:%d  %s"):format(
							item.type,
							M.module(path),
							vim.fs.basename(path),
							item.lnum,
							item.text
						)
					end
					return lines
				end,
			})
			vim.cmd("copen")
			vim.notify(("Loaded %d lint findings from %d reports"):format(#parsed.items, #parsed.reports))
		end)
	end)
end

local function adb()
	local sdk = vim.env.ANDROID_HOME or vim.fn.expand("~/Library/Android/sdk")
	local exe = join(sdk, "platform-tools", "adb")
	return vim.fn.executable(exe) == 1 and exe or "adb"
end

function M.device(callback)
	vim.system({ adb(), "devices", "-l" }, { text = true }, function(result)
		vim.schedule(function()
			if result.code ~= 0 then
				vim.notify(result.stderr, vim.log.levels.ERROR)
				return
			end
			local devices = {}
			for line in (result.stdout or ""):gmatch("[^\n]+") do
				local serial = line:match("^(%S+)%s+device%s")
				if serial then
					table.insert(devices, { serial = serial, label = line })
				end
			end
			if #devices == 0 then
				vim.notify("No authorized Android devices connected", vim.log.levels.INFO)
				return
			end
			vim.ui.select(devices, {
				prompt = "Android device",
				format_item = function(d)
					return d.label
				end,
			}, function(d)
				if d then
					M.serial = d.serial
					if callback then
						callback(d.serial)
					end
				end
			end)
		end)
	end)
end

function M.logcat()
	M.device(function(serial)
		Snacks.terminal.open({ adb(), "-s", serial, "logcat", "-v", "threadtime", "-T", "300" }, {
			auto_close = false,
			win = { position = "bottom", height = 0.3, title = " Logcat · " .. serial .. " (Ctrl-C stops) " },
		})
	end)
end

function M.helper(name)
	local root = project()
	if not root then
		return
	end
	local script = join(vim.fs.dirname(root), "setup", name)
	if vim.fs.basename(root) ~= "dronecontrol" or vim.fn.executable(script) ~= 1 then
		vim.notify("DroneControl setup helper is unavailable: " .. name, vim.log.levels.WARN)
		return
	end
	Snacks.terminal.open({ script }, { cwd = root, auto_close = false, win = { position = "bottom", height = 0.3 } })
end

function M.review_toggle()
	if vim.b.android_review_mode then
		vim.b.autoformat = vim.b.android_saved_autoformat
		vim.b.android_review_mode = nil
		vim.b.android_saved_autoformat = nil
	else
		vim.b.android_saved_autoformat = vim.b.autoformat
		vim.b.android_review_mode = true
		vim.b.autoformat = false
	end
	vim.notify(
		vim.b.android_review_mode and "Review mode: autoformat disabled for this buffer"
			or "Review mode off: previous autoformat setting restored"
	)
	vim.cmd("redrawstatus")
end

function M.branch_diff()
	local root = project()
	if root then
		vim.cmd("DiffviewOpen -C=" .. vim.fn.fnameescape(root) .. " upstream/main...HEAD")
	end
end

local actions = {
	{
		"Build both debug APKs",
		function()
			M.gradle({ "assembleDebug" })
		end,
	},
	{
		"Run both modules' unit tests",
		function()
			M.gradle({ "testDebugUnitTest" })
		end,
	},
	{
		"Run lint on both modules",
		function()
			M.gradle({ "lintDebug", "--continue" })
		end,
	},
	{ "Browse saved lint findings", M.lint_results },
	{
		"Find source files",
		function()
			M.files("source")
		end,
	},
	{
		"Find resources / manifests",
		function()
			M.files("resources")
		end,
	},
	{
		"Find Gradle / JNI build files",
		function()
			M.files("build")
		end,
	},
	{ "Search Android source", M.grep },
	{ "Select device", M.device },
	{ "Stream device logcat", M.logcat },
	{
		"Install / open in the offline emulator",
		function()
			M.helper("run")
		end,
	},
	{
		"Open Android Studio",
		function()
			M.helper("studio")
		end,
	},
	{ "Review branch against upstream/main", M.branch_diff },
	{ "Toggle review mode for buffer", M.review_toggle },
	{ "Show last task output", M.output },
	{ "Stop running Gradle task", M.stop },
}

function M.menu()
	vim.ui.select(actions, {
		prompt = "Android · DroneControl",
		format_item = function(a)
			return a[1]
		end,
	}, function(a)
		if a then
			a[2]()
		end
	end)
end

function M.setup()
	local commands = {
		Android = M.menu,
		AndroidBuild = actions[1][2],
		AndroidTest = actions[2][2],
		AndroidLint = actions[3][2],
		AndroidLintResults = M.lint_results,
		AndroidDevices = M.device,
		AndroidLogcat = M.logcat,
		AndroidRun = function()
			M.helper("run")
		end,
		AndroidStudio = function()
			M.helper("studio")
		end,
		AndroidResource = M.resource,
		AndroidReview = M.review_toggle,
		AndroidOutput = M.output,
		AndroidStop = M.stop,
	}
	for name, fn in pairs(commands) do
		vim.api.nvim_create_user_command(name, function()
			fn()
		end, {})
	end
	vim.api.nvim_create_user_command("AndroidGradle", function(opts)
		M.gradle(opts.fargs)
	end, { nargs = "+" })
end

return M
