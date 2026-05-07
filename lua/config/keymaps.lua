-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", function()
	if _G.Snacks and Snacks.explorer then
		Snacks.explorer({ cwd = vim.fn.getcwd() })
		return
	end

	local ok, telescope = pcall(require, "telescope.builtin")
	if ok then
		telescope.find_files()
	else
		vim.cmd("edit .")
	end
end, { desc = "Project view" })
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "nm", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment line" })

vim.keymap.set("n", "<leader>tf", "<cmd>Neotest run file<cr>", { desc = "Run test file" })

-- vim.keymap.set("n", "J", "mzJ`z")
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")
-- vim.keymap.set("n", "=ap", "ma=ap'a")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

local function optional_call(module, fn)
	return function()
		local ok, plugin = pcall(require, module)
		if not ok then
			vim.notify(module .. " is not installed", vim.log.levels.WARN)
			return
		end
		plugin[fn]()
	end
end

vim.keymap.set("n", "<leader>vwm", function()
	optional_call("vim-with-me", "StartVimWithMe")()
end, { desc = "Start Vim With Me" })
vim.keymap.set("n", "<leader>svwm", function()
	optional_call("vim-with-me", "StopVimWithMe")()
end, { desc = "Stop Vim With Me" })
vim.keymap.set("n", "<leader>lt", function()
	if vim.fn.exists(":PlenaryBustedFile") == 2 then
		vim.cmd([[PlenaryBustedFile %]])
	else
		vim.cmd("Neotest run file")
	end
end, { desc = "Run Lua test file" })

local function ardupilot_term(cmd)
	vim.cmd("belowright split")
	vim.cmd("resize 14")
	vim.fn.termopen(cmd)
	vim.cmd("startinsert")
end

--ardupilot--

vim.keymap.set("n", "<leader>ac", function()
	ardupilot_term("./waf configure --board sitl")
end, { desc = "ArduPilot configure SITL" })

vim.keymap.set("n", "<leader>ab", function()
	ardupilot_term("./waf copter")
end, { desc = "ArduPilot build copter" })

vim.keymap.set("n", "<leader>as", function()
	ardupilot_term("./waf copter --run")
end, { desc = "ArduPilot run copter SITL" })

--px4--

vim.keymap.set("n", "<leader>pb", function()
	ardupilot_term("make px4_sitl_default")
end, { desc = "PX4 build SITL default" })

vim.keymap.set("n", "<leader>ps", function()
	ardupilot_term("PX4_SIM_MODEL=iris make px4_sitl_default gazebo")
end, { desc = "PX4 run SITL gazebo (iris)" })

-- dotnet / WPF
vim.keymap.set("n", "<leader>nR", "<cmd>DotnetRestore<cr>", { desc = "Dotnet restore" })
vim.keymap.set("n", "<leader>nb", "<cmd>DotnetBuild<cr>", { desc = "Dotnet build" })
vim.keymap.set("n", "<leader>nr", "<cmd>DotnetRun<cr>", { desc = "Dotnet run" })
vim.keymap.set("n", "<leader>nt", "<cmd>DotnetTest<cr>", { desc = "Dotnet test" })
vim.keymap.set("n", "<leader>nw", "<cmd>DotnetWatch<cr>", { desc = "Dotnet watch run" })

-- Python AI/ML
vim.keymap.set("n", "<leader>pr", "<cmd>PythonRun<cr>", { desc = "Python run file" })
vim.keymap.set("n", "<leader>pt", "<cmd>PythonTest<cr>", { desc = "Python pytest" })

-- C/C++ application and game-dev projects
vim.keymap.set("n", "<leader>cc", "<cmd>CmakeConfigure<cr>", { desc = "CMake configure" })
vim.keymap.set("n", "<leader>cb", "<cmd>CmakeBuild<cr>", { desc = "CMake build" })
vim.keymap.set("n", "<leader>ct", "<cmd>CmakeTest<cr>", { desc = "CMake test" })
vim.keymap.set("n", "<leader>cr", "<cmd>CppRun<cr>", { desc = "C++ compile/run file" })

-- greatest remap ever to have yank history
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux-sessionizer -s 0 --vsplit<CR>")
-- vim.keymap.set("n", "<M-H>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

-- vim.keymap.set("n", "<leader>ea", 'oassert.NoError(err, "")<Esc>F";a')

-- vim.keymap.set("n", "<leader>ef", 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj')

-- vim.keymap.set("n", "<leader>el", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i')

-- vim.keymap.set("n", "<leader>ca", function()
-- require("cellular-automaton").start_animation("make_it_rain")
-- end)

vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("source %")
end)

-- SSH + tunneling helpers
local ssh_tunnel_jobs = {}

local function split_term(cmd, opts)
	opts = opts or {}
	vim.cmd("belowright split")
	vim.cmd("resize " .. (opts.height or 14))
	vim.fn.termopen(cmd, { cwd = opts.cwd, env = opts.env })
	vim.cmd("startinsert")
end

local function start_ssh_tunnel(name, args)
	local job = vim.fn.jobstart(args, { detach = false })
	if job <= 0 then
		vim.notify("Failed to start tunnel: " .. name, vim.log.levels.ERROR)
		return
	end

	ssh_tunnel_jobs[name] = job
	vim.notify("Tunnel started (" .. name .. ") as job " .. job, vim.log.levels.INFO)
end

local function stop_ssh_tunnel(name)
	local job = ssh_tunnel_jobs[name]
	if not job then
		vim.notify("No active tunnel named " .. name, vim.log.levels.WARN)
		return
	end

	vim.fn.jobstop(job)
	ssh_tunnel_jobs[name] = nil
	vim.notify("Tunnel stopped: " .. name, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("SSHTerm", function(opts)
	if opts.args == "" then
		vim.notify("Usage: :SSHTerm user@host", vim.log.levels.WARN)
		return
	end
	split_term({ "ssh", opts.args })
end, { nargs = 1, complete = "file" })

vim.api.nvim_create_user_command("TunnelLocal", function(opts)
	if #opts.fargs < 4 then
		vim.notify(
			"Usage: :TunnelLocal <name> <local_port> <remote_host> <remote_port> [ssh_host]",
			vim.log.levels.WARN
		)
		return
	end

	local name = opts.fargs[1]
	local local_port = opts.fargs[2]
	local remote_host = opts.fargs[3]
	local remote_port = opts.fargs[4]
	local ssh_host = opts.fargs[5] or "localhost"

	start_ssh_tunnel(name, {
		"ssh",
		"-N",
		"-L",
		("%s:%s:%s"):format(local_port, remote_host, remote_port),
		ssh_host,
	})
end, { nargs = "+" })

vim.api.nvim_create_user_command("TunnelRemote", function(opts)
	if #opts.fargs < 4 then
		vim.notify(
			"Usage: :TunnelRemote <name> <remote_port> <local_host> <local_port> [ssh_host]",
			vim.log.levels.WARN
		)
		return
	end

	local name = opts.fargs[1]
	local remote_port = opts.fargs[2]
	local local_host = opts.fargs[3]
	local local_port = opts.fargs[4]
	local ssh_host = opts.fargs[5] or "localhost"

	start_ssh_tunnel(name, {
		"ssh",
		"-N",
		"-R",
		("%s:%s:%s"):format(remote_port, local_host, local_port),
		ssh_host,
	})
end, { nargs = "+" })

vim.api.nvim_create_user_command("TunnelSocks", function(opts)
	if #opts.fargs < 3 then
		vim.notify("Usage: :TunnelSocks <name> <local_port> <ssh_host>", vim.log.levels.WARN)
		return
	end

	local name = opts.fargs[1]
	local local_port = opts.fargs[2]
	local ssh_host = opts.fargs[3]

	start_ssh_tunnel(name, { "ssh", "-N", "-D", local_port, ssh_host })
end, { nargs = "+" })

vim.api.nvim_create_user_command("TunnelStop", function(opts)
	if opts.args == "" then
		vim.notify("Usage: :TunnelStop <name>", vim.log.levels.WARN)
		return
	end
	stop_ssh_tunnel(opts.args)
end, { nargs = 1 })

vim.keymap.set("n", "<leader>TS", ":SSHTerm ", { desc = "SSH terminal (enter host)" })
vim.keymap.set("n", "<leader>TL", ":TunnelLocal ", { desc = "Start local tunnel" })
vim.keymap.set("n", "<leader>TR", ":TunnelRemote ", { desc = "Start remote tunnel" })
vim.keymap.set("n", "<leader>TD", ":TunnelSocks ", { desc = "Start SOCKS tunnel" })
vim.keymap.set("n", "<leader>TX", ":TunnelStop ", { desc = "Stop tunnel" })
