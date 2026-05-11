local function notify(message, level)
	vim.notify("[remote] " .. message, level or vim.log.levels.INFO)
end

local function root()
	if _G.LazyVim and LazyVim.root then
		return LazyVim.root.get()
	end
	return vim.fn.getcwd()
end

local function ssh_config_path()
	return vim.fn.expand("$HOME") .. "/.ssh/config"
end

local function ssh_hosts()
	local config = ssh_config_path()
	if vim.fn.filereadable(config) == 0 then
		return {}
	end

	local seen = {}
	local hosts = {}
	for _, line in ipairs(vim.fn.readfile(config)) do
		if not line:match("^%s*#") then
			local names = line:match("^%s*[Hh]ost%s+(.+)$")
			if names then
				names = names:gsub("%s+#.*$", "")
				for name in names:gmatch("%S+") do
					if not name:find("[*?]") and not seen[name] then
						seen[name] = true
						table.insert(hosts, name)
					end
				end
			end
		end
	end

	table.sort(hosts)
	return hosts
end

local function split_args(args)
	args = vim.trim(args or "")
	if args == "" then
		return nil
	end

	local parts = vim.split(args, "%s+", { trimempty = true })
	if parts[1] == "ssh" then
		table.remove(parts, 1)
	end
	return #parts > 0 and parts or nil
end

local function prompt_target()
	local target = vim.fn.input({
		prompt = "SSH target: ",
		default = "",
	})
	return vim.trim(target or "")
end

local function run_ssh(args)
	if vim.fn.executable("ssh") == 0 then
		notify("ssh is not available on PATH.", vim.log.levels.ERROR)
		return
	end

	local argv = split_args(args)
	if not argv then
		local target = prompt_target()
		argv = split_args(target)
	end
	if not argv then
		return
	end

	table.insert(argv, 1, "ssh")
	require("lazy").load({ plugins = { "snacks.nvim" } })
	Snacks.terminal.toggle(argv, {
		cwd = root(),
		interactive = true,
		auto_close = false,
		win = {
			position = "float",
			width = 0.92,
			height = 0.9,
			border = "rounded",
			title = " SSH terminal ",
			title_pos = "center",
		},
	})
end

local function pick_host()
	local hosts = ssh_hosts()
	if #hosts == 0 then
		run_ssh()
		return
	end

	vim.ui.select(hosts, { prompt = "SSH host" }, function(choice)
		if choice then
			run_ssh(choice)
		end
	end)
end

local function remote_status()
	local hosts = ssh_hosts()
	local lines = {
		"ssh: " .. (vim.fn.executable("ssh") == 1 and "ok" or "missing"),
		"ssh config: " .. (vim.fn.filereadable(ssh_config_path()) == 1 and ssh_config_path() or "missing"),
		"hosts: " .. #hosts,
		"connect: :Ssh user@host -p 22",
	}
	notify(table.concat(lines, "\n"), vim.fn.executable("ssh") == 1 and vim.log.levels.INFO or vim.log.levels.WARN)
end

local function complete_hosts()
	return ssh_hosts()
end

vim.api.nvim_create_user_command("Ssh", function(opts)
	run_ssh(opts.args)
end, {
	nargs = "*",
	complete = complete_hosts,
	desc = "Open a plain SSH terminal",
})

vim.api.nvim_create_user_command("SshHost", pick_host, {
	desc = "Pick a host from ~/.ssh/config and open SSH",
})

vim.api.nvim_create_user_command("RemoteSSHStatus", remote_status, {
	desc = "Show simple SSH terminal status",
})

return {
	{
		"folke/snacks.nvim",
		keys = {
			{
				"<leader>rc",
				pick_host,
				desc = "SSH terminal",
			},
			{
				"<leader>rs",
				function()
					run_ssh()
				end,
				desc = "SSH target",
			},
			{
				"<leader>rh",
				pick_host,
				desc = "SSH host picker",
			},
			{
				"<leader>rS",
				remote_status,
				desc = "SSH status",
			},
		},
	},
	{
		"folke/which-key.nvim",
		opts = function(_, opts)
			opts.spec = opts.spec or {}
			table.insert(opts.spec, { "<leader>r", group = "Remote SSH" })
		end,
	},
}
