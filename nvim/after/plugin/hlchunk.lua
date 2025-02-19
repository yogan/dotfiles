require("hlchunk").setup({
	chunk = {
		enable = true,
		style = {
			{ fg = "#435D95" }, -- normal chunk
			{ fg = "#f38ba8" }, -- chunk with error(s)
		},
	},
	indent = {
		enable = true,
		filter_list = {
			function(v)
				return v.level ~= 1
			end,
		},
		style = {
			{ fg = "#2a2b3c" }, -- taken from CursorLine bg
		},
	},
})
