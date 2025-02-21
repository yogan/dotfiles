return {
	-- Color scheme with high prio so that it is loaded first
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },

	-- Fancy command line / search bar / messages
	{ "folke/noice.nvim", dependencies = { "MunifTanjim/nui.nvim" } },

	-- Nerd font icons
	{
		"nvim-tree/nvim-web-devicons",
		opts = { override_by_extension = {
			["m"] = { icon = "󰻊", name = "MATLAB" },
		} },
	},

	-- Animated cursor
	{
		"sphamba/smear-cursor.nvim",
		opts = {
			stiffness = 0.8, --                         [0, 1]  default: 0.6
			trailing_stiffness = 0.5, --                [0, 1]  default: 0.3
			distance_stop_animating = 0.5, --           > 0     default: 0.1
			legacy_computing_symbols_support = false,
			smear_insert_mode = false,
		},
	},

	-- Indent guides
	{
		"shellRaining/hlchunk.nvim",
		opts = {
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
		},
	},

	-- Rainbow parens
	"HiPhish/rainbow-delimiters.nvim",
}
