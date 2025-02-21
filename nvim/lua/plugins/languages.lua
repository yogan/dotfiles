return {
	-- TypeScript extended LSP functionality (rename file, update imports, etc.)
	-- :VtsExec <tab> / :VtsRename
	"yioneko/nvim-vtsls",

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

	-- Elixir
	{
		"elixir-tools/elixir-tools.nvim",
		version = "*",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		config = true,
	},

	-- MIPS Assembly Syntax Highlighting
	"harenome/vim-mipssyntax",

	-- Web Assembly Syntax Highlighting
	"rhysd/vim-wasm",

	-- F# Syntax Highlighting
	"adelarsq/neofsharp.vim",

	-- Crystal
	"vim-crystal/vim-crystal",

	-- Idris
	-- Install idris2-lsp via pack as described here:
	-- https://github.com/idris-community/idris2-lsp?tab=readme-ov-file
	{
		"ShinKage/idris2-nvim",
		dependencies = { "neovim/nvim-lspconfig", "MunifTanjim/nui.nvim" },
		config = true,
		ft = "idris2", -- lazy-load on file type
	},

	-- GNU Octave (MATLAB)
	-- This is only syntax highlighting, not a full LSP
	-- (info pages for Octave functions can be shown with `K`, though)
	-- There is https://github.com/mathworks/MATLAB-language-server, but this
	-- requires a real MATLAB installation, not just GNU Octave.
	"gnu-octave/vim-octave",
}
