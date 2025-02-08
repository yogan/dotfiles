require("hlchunk").setup({
	chunk = {
		enable = true,
		style = {
			{ fg = "#8e3434" }, -- normal chunk
			{ fg = "#e11811" }, -- chunk with error(s)
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
			{ fg = "#351f1e" },
			{ fg = "#3c1a19" },
			{ fg = "#421411" },
			{ fg = "#4d0706" },
		},
	},
})
