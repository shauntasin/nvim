return {
	{
		"nosduco/remote-sshfs.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		cmd = {
			"RemoteSSHFSConnect",
			"RemoteSSHFSDisconnect",
			"RemoteSSHFSEdit",
			"RemoteSSHFSFindFiles",
			"RemoteSSHFSLiveGrep",
		},
		keys = {
			{
				"<leader>rc",
				function()
					require("remote-sshfs.api").connect()
				end,
				desc = "Remote SSHFS connect",
			},
			{
				"<leader>rd",
				function()
					require("remote-sshfs.api").disconnect()
				end,
				desc = "Remote SSHFS disconnect",
			},
			{
				"<leader>re",
				function()
					require("remote-sshfs.api").edit()
				end,
				desc = "Edit SSH config",
			},
			{
				"<leader>rf",
				function()
					require("remote-sshfs.api").find_files()
				end,
				desc = "Remote find files",
			},
			{
				"<leader>rG",
				function()
					require("remote-sshfs.api").live_grep()
				end,
				desc = "Remote live grep",
			},
		},
		opts = function()
			return {
				connections = {
					ssh_configs = {
						vim.fn.expand("$HOME") .. "/.ssh/config",
					},
					ssh_known_hosts = vim.fn.expand("$HOME") .. "/.ssh/known_hosts",
					sshfs_args = {
						"-o reconnect",
						"-o ConnectTimeout=5",
					},
				},
				mounts = {
					base_dir = vim.fn.expand("$HOME") .. "/.sshfs/",
					unmount_on_exit = true,
				},
				handlers = {
					on_connect = {
						change_dir = true,
					},
					on_disconnect = {
						clean_mount_folders = false,
					},
				},
				ui = {
					picker = "telescope",
					confirm = {
						connect = true,
						change_dir = false,
					},
				},
			}
		end,
		config = function(_, opts)
			require("remote-sshfs").setup(opts)

			local ok, telescope = pcall(require, "telescope")
			if ok then
				pcall(telescope.load_extension, "remote-sshfs")
			end
		end,
	},
	{
		"folke/which-key.nvim",
		opts = function(_, opts)
			opts.spec = opts.spec or {}
			table.insert(opts.spec, { "<leader>r", group = "Remote SSHFS" })
		end,
	},
}
