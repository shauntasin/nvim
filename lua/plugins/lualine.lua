return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = function(_, opts)
		table.insert(opts.sections.lualine_x, {
			function()
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				local names = vim.tbl_map(function(client)
					return client.name
				end, clients)
				table.sort(names)
				return table.concat(names, " · ")
			end,
			icon = "",
			cond = function()
				return vim.o.columns > 120
			end,
		})
		table.insert(opts.sections.lualine_b, {
			function()
				local android = require("config.android")
				local root = android.root()
				if not root then
					return ""
				end
				return " "
					.. android.module()
					.. (android.jobs[root] and " · BUILD" or "")
					.. (vim.b.android_review_mode and " · REVIEW" or "")
			end,
		})
		opts.options.component_separators = { left = "│", right = "│" }
		opts.options.section_separators = { left = "", right = "" }
	end,
}
