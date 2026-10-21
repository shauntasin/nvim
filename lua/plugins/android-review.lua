local jdk17 = "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
local studio_jdk = "/Applications/Android Studio.app/Contents/jbr/Contents/Home"

return {
	{
		"mfussenegger/nvim-jdtls",
		opts = function(_, opts)
			-- The language server uses a recent JDK; this Android build uses JDK 17.
			opts.jdtls = vim.tbl_deep_extend("force", opts.jdtls or {}, {
				cmd_env = { JAVA_HOME = studio_jdk, ANDROID_HOME = vim.fn.expand("~/Library/Android/sdk") },
			})
			opts.dap_main = false
			opts.dap = false
			opts.test = false
			opts.settings.java = vim.tbl_deep_extend("force", opts.settings.java or {}, {
				import = { gradle = { java = { home = jdk17 } } },
				jdt = { ls = { androidSupport = { enabled = true } } },
				configuration = { runtimes = { { name = "JavaSE-17", path = jdk17, default = true } } },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				lemminx = { cmd_env = { JAVA_HOME = studio_jdk } },
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "java", "groovy", "xml" })
		end,
	},
	{
		"dlyongemallo/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		opts = {},
		keys = {
			{ "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Review working changes" },
			{ "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "Review file history" },
		},
	},
	{
		"harrisoncramer/gitlab.nvim",
		dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "dlyongemallo/diffview.nvim" },
		build = function()
			require("gitlab.server").build(true)
		end,
		config = function(_, opts)
			local upstream = vim.system({ "git", "remote", "get-url", "upstream" }, { text = true }):wait()
			if upstream.code == 0 and (upstream.stdout or ""):find("androidgcs/dronecontrol", 1, true) then
				opts.connection_settings = { remote = "upstream" }
			end
			require("gitlab").setup(opts)
		end,
		opts = {
			keymaps = { global = { disable_all = true } },
			discussion_tree = { draft_mode = true },
			auth_provider = function()
				local token = vim.env.GITLAB_TOKEN
				local url = vim.env.GITLAB_URL or "http://ayaanservers.local:8080"
				if not token or token == "" then
					local result = vim.system(
						{ "glab", "config", "get", "token", "--host", "ayaanservers.local" },
						{ text = true }
					):wait()
					if result.code == 0 then
						token = vim.trim(result.stdout or "")
					end
				end
				if not token or token == "" then
					return nil,
						nil,
						"Authenticate using android_review/setup/gitlab-login.command first (macOS Keychain)."
				end
				return token, url, nil
			end,
		},
		keys = {
			{
				"<leader>gLc",
				function()
					require("gitlab").choose_merge_request()
				end,
				desc = "GitLab choose MR",
			},
			{
				"<leader>gLr",
				function()
					require("gitlab").review()
				end,
				desc = "GitLab review branch MR",
			},
			{
				"<leader>gLd",
				function()
					require("gitlab").toggle_discussions()
				end,
				desc = "GitLab discussions",
			},
			{
				"<leader>gLn",
				function()
					require("gitlab").create_comment()
				end,
				mode = { "n", "x" },
				desc = "GitLab line comment",
			},
			{
				"<leader>gLs",
				function()
					require("gitlab").summary()
				end,
				desc = "GitLab MR summary",
			},
			{
				"<leader>gLo",
				function()
					require("gitlab").open_in_browser()
				end,
				desc = "GitLab MR in browser",
			},
			{
				"<leader>gLp",
				function()
					require("gitlab").publish_all_drafts()
				end,
				desc = "GitLab publish draft review",
			},
		},
	},
}
