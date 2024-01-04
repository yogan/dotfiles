---@diagnostic disable: missing-fields
require("nvim-surround").setup({
	keymaps = {
		visual = "gs", -- default is S, but this clashes with leap
		visual_line = false -- I don't see the point to surround full lines
	},
})
