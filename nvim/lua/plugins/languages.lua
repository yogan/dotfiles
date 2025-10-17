return {
	-- NeoVim specific lua_ls settings (adds types and API docs for vim.* etc.)
	{
		"folke/lazydev.nvim",
		dependencies = {
			{ "LuaCATS/luassert", name = "luassert-types", lazy = true },
			{ "LuaCATS/busted", name = "busted-types", lazy = true },
		},
		opts = {
			library = {
				-- Only load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				-- Same for busted and luassert support
				{ path = "luassert-types/library", words = { "assert" } },
				{ path = "busted-types/library", words = { "describe" } },
			},
		},
		ft = "lua",
	},

	-- TypeScript extended LSP functionality (rename file, update imports, etc.)
	-- :VtsExec <tab> / :VtsRename
	{
		"yioneko/nvim-vtsls",
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	},

	-- Elixir
	{
		"elixir-tools/elixir-tools.nvim",
		version = "*",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
		event = { "BufReadPre", "BufNewFile" },
		ft = "elixir",
	},

	-- Crystal
	{ "vim-crystal/vim-crystal", ft = "crystal" },

	-- Idris
	-- Install idris2-lsp via pack as described here:
	-- https://github.com/idris-community/idris2-lsp?tab=readme-ov-file
	{
		"ShinKage/idris2-nvim",
		dependencies = { "neovim/nvim-lspconfig", "MunifTanjim/nui.nvim" },
		config = true,
		ft = "idris2",
	},

	-- MIPS Assembly Syntax Highlighting
	{ "harenome/vim-mipssyntax", ft = "mips" },

	-- Highlighting for Storybook files
	{
		"davidmh/mdx.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = true,
	},

	-- Markdown
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			heading = {
				icons = { "" },
				position = "inline",
			},
			indent = {
				enabled = true,
				icon = " ",
			},
			code = {
				sign = false,
				width = "block",
				language_pad = 2,
				left_pad = 2,
				right_pad = 2,
				min_width = 45,
			},
			latex = {
				enabled = false,
			},
		},
		config = function(_, opts)
			require("render-markdown").setup(opts)

			local wk = require("which-key")
			wk.add({
				{
					mode = { "n" },
					"<leader>p",
					function() require("render-markdown").preview() end,
					desc = "Render Markdown Preview",
				},
			})
		end,
	},
}
