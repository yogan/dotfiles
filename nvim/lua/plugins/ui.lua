return {
	-- Color scheme with high prio so that it is loaded first
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			custom_highlights = function(colors)
				return {
					ColorColumn = { bg = "#1a1a2a" },
					Folded = { bg = colors.surface0 },
					UfoFoldedEllipsis = { fg = colors.lavender, bg = colors.surface0 },
				}
			end,
			dim_inactive = { enabled = true },
			show_end_of_buffer = true,
		},

		config = function(_, opts)
			require("catppuccin").setup(opts)

			vim.api.nvim_set_hl(0, "ExtraWhitespace", { link = "DiagnosticVirtualTextError" })
			vim.cmd("colorscheme catppuccin")
		end,
	},

	-- Fancy command line / search bar / messages
	{
		"folke/noice.nvim",
		dependencies = "MunifTanjim/nui.nvim",
		opts = {
			message = { enabled = false },
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			presets = {
				bottom_search = false, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				inc_rename = true, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
		},
	},

	-- Automatically clear search highlights after moving away from them
	"romainl/vim-cool",

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
		event = "BufRead",
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
	{ "HiPhish/rainbow-delimiters.nvim", event = "BufRead" },
}
