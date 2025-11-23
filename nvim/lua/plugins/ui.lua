return {
	-- Color scheme with high prio so that it is loaded first
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		---@type CatppuccinOptions
		opts = {
			color_overrides = {
				-- for original colors, see palettes/mocha.lua in plugin
				mocha = {
					-- a bit darker and less blue than the default
					base = "#1b1b27",
					-- define a new color, somewhere between surface0 and base
					surbase = "#212231",
				},
			},
			---@param colors CtpColors<"string">|{surbase: string}
			custom_highlights = function(colors)
				return {
					ColorColumn = { bg = colors.mantle },
					Folded = { bg = colors.surbase },
					UfoFoldedEllipsis = { fg = colors.lavender, bg = colors.surbase },
					Yank = { bg = "#649dbb" },

					["@markup.heading.1.markdown"] = { fg = "#74c7ec" },
					RenderMarkdownH1 = { fg = "#74c7ec" },
					RenderMarkdownH1Bg = { bg = "#364f62" },

					["@markup.heading.2.markdown"] = { fg = "#68b0d3" },
					RenderMarkdownH2 = { fg = "#68b0d3" },
					RenderMarkdownH2Bg = { bg = "#2f4557" },

					["@markup.heading.3.markdown"] = { fg = "#5c99bb" },
					RenderMarkdownH3 = { fg = "#5c99bb" },
					RenderMarkdownH3Bg = { bg = "#293c4d" },

					["@markup.heading.4.markdown"] = { fg = "#5083a3" },
					RenderMarkdownH4 = { fg = "#5083a3" },
					RenderMarkdownH4Bg = { bg = "#233343" },

					["@markup.heading.5.markdown"] = { fg = "#446d8b" },
					RenderMarkdownH5 = { fg = "#446d8b" },
					RenderMarkdownH5Bg = { bg = "#1d2a39" },

					["@markup.heading.6.markdown"] = { fg = "#385774" },
					RenderMarkdownH6 = { fg = "#385774" },
					RenderMarkdownH6Bg = { bg = "#172130" },
				}
			end,
			dim_inactive = {
				enabled = true,
				percentage = 0.25,
				shade = "light",
			},
			float = {
				transparent = true,
				solid = false,
			},
			show_end_of_buffer = true,
			transparent_background = false,
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
			smear_to_cmd = false, -- fixes glitch in noice's cmd/search box
			never_draw_over_target = true, -- don't hide my current position
			hide_target_hack = true, -- same (?)

			-- `true` would prevent background from showing up when moving
			-- through a visual selection block, or jumping between windows,
			-- but some Unicode replacement characters show up then
			legacy_computing_symbols_support = false,

			--
			-- Fire hazard preset from docs:
			--
			-- cursor_color = "#ff4000",
			-- particles_enabled = true,
			-- stiffness = 0.5,
			-- trailing_stiffness = 0.2,
			-- trailing_exponent = 5,
			-- damping = 0.6,
			-- gradient_exponent = 0,
			-- gamma = 1,
			-- particle_spread = 1,
			-- particles_per_second = 500,
			-- particles_per_length = 50,
			-- particle_max_lifetime = 800,
			-- particle_max_initial_velocity = 20,
			-- particle_velocity_from_cursor = 0.5,
			-- particle_damping = 0.15,
			-- particle_gravity = -50,
			-- min_distance_emit_particles = 0,
			--
			-- Snow preset from
			-- https://old.reddit.com/r/neovim/comments/1p1z43w/particle_effects_in_smearcursornvim_let_it/npx36yh/
			--
			cursor_color = "Cursor",
			gradient_exponent = 0,
			particles_enabled = true,
			particle_spread = 1,
			particles_per_second = 100,
			particles_per_length = 50,
			particle_max_lifetime = 1500,
			particle_max_initial_velocity = 10,
			particle_velocity_from_cursor = 0,
			particle_random_velocity = 300,
			particle_damping = 0.1,
			particle_gravity = 50,
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
					function(v) return v.level ~= 1 end,
				},
				style = {
					{ fg = "#2a2b3c" }, -- taken from CursorLine bg
				},
			},
		},
	},

	-- Rainbow parens
	{ "HiPhish/rainbow-delimiters.nvim", event = "BufRead" },

	-- Backgrounds for color values
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {
			user_default_options = {
				names = false,
			},
		},
	},
}
