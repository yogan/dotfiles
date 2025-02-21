return {
	-- TypeScript extended LSP functionality (rename file, update imports, etc.)
	-- :VtsExec <tab> / :VtsRename
	"yioneko/nvim-vtsls",

	-- NeoVim specific lua_ls settings (adds types and API docs for vim.* etc.)
	-- (successor of neodev.nvim)
	{
		"folke/lazydev.nvim",
		dependencies = { "LuaCATS/busted", "LuaCATS/luassert" },
	},

	-- Elixir
	{
		"elixir-tools/elixir-tools.nvim",
		tag = "stable",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("elixir").setup()
		end,
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
