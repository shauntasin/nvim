return {
	"folke/snacks.nvim",
	opts = {
		-- PDF reads are handled by config.pdf; render only its generated PNG pages.
		image = { enabled = true, formats = { "png" }, doc = { enabled = false } },
	},
}
