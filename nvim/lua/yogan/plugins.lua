-- auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
		})
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

-- Automatically sync plugins when this file (packer.lua) is written
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Load the actual plugins
return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- Icons; many other plugins depend on this. Config is intentionally inline,
	-- it has to be set up before other plugins are loaded.
	use({
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({
				override_by_extension = {
					["m"] = { icon = "󰻊", name = "MATLAB" },
				},
			})
		end,
	})

	-- Color scheme, status line, icons, indent guides, trailing whitespace
	-- Config for colorscheme: after/plugin/colors.lua
	use("ficcdaf/ashen.nvim")
	use("nvim-lualine/lualine.nvim")
	use("shellRaining/hlchunk.nvim")
	use("HiPhish/rainbow-delimiters.nvim")

	-- Commenting stuff
	use("numToStr/Comment.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring") -- for jsx/tsx support

	use({
		"ntpeters/vim-better-whitespace",
		config = function()
			-- Strip whitespace operator, also works on visual selection
			-- Operator mode examples:
			--    <leader>Wj  - current line
			--    <leader>Wap - current paragraph
			--    <leader>Wib - current block (e.g. {…})
			--    <leader>Wig - current git change hunk
			vim.cmd([[ let g:better_whitespace_operator = "<leader>W" ]])
		end,
	})

	-- Noice (fancy UI, only for cmdline and completion)
	use({ "folke/noice.nvim", requires = { "MunifTanjim/nui.nvim" } })

	-- Oil File Explorer
	use({
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup()
		end,
	})

	-- Close buffer helpers
	use("kazhala/close-buffers.nvim")

	-- Git
	use("lewis6991/gitsigns.nvim")

	-- Automatically set indentation settings
	use("nmac427/guess-indent.nvim")

	-- Better folding
	use({
		"kevinhwang91/nvim-ufo",
		requires = {
			"kevinhwang91/promise-async",
			"luukvbaal/statuscol.nvim",
		},
	})

	-- Start screen
	use({
		"goolord/alpha-nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
	})

	-- Session management
	use({
		"jedrzejboczar/possession.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})

	-- Snacks plugin collection
	use("folke/snacks.nvim")

	-- Todo comments
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
	})

	-- Treesitter
	-- NOTE for Windows: Treesitter requires a C compiler. This one works fine:
	-- https://github.com/skeeto/w64devkit (unzip somewhere, add bin/ to PATH)
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
	use("nvim-treesitter/playground")
	use("nvim-treesitter/nvim-treesitter-context")
	use("nvim-treesitter/nvim-treesitter-textobjects")

	-- Harpoon (jump around and shit)
	-- NOTE: https://github.com/toppair/reach.nvim might be nicer
	use("theprimeagen/harpoon")

	-- Surround (there are alternatives and stuff, but this seems fine)
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup()
		end,
	})

	-- Jump around like a boss (used to be EasyMotion and Leap)
	use("folke/flash.nvim")

	-- Shows not only key mappings, but also registers, marks, etc.
	use({
		"folke/which-key.nvim",
		config = function()
			vim.opt.timeout = true
			vim.opt.timeoutlen = 500
			require("which-key").setup()
		end,
	})

	-- Undo tree
	use("mbbill/undotree")

	-- LSP & Friends
	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Fancy icons in completion menu
			{ "onsails/lspkind-nvim" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			-- Snippet Collection (Optional)
			{ "rafamadriz/friendly-snippets" },
		},
	})

	-- LSP Fidget
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
	})

	-- Improved LSP renaming (live preview)
	use({
		"smjonas/inc-rename.nvim",
		config = function()
			require("inc_rename").setup({})
		end,
	})

	-- LSP Symbol Navigation
	use("bassamsdata/namu.nvim")

	-- TypeScript extended LSP functionality (rename file, update imports, etc.)
	-- :VtsExec <tab> / :VtsRename
	use("yioneko/nvim-vtsls")

	-- NeoVim specific lua_ls settings (adds types and API docs for vim.* etc.)
	-- (successor of neodev.nvim)
	use({
		"folke/lazydev.nvim",
		requires = { "LuaCATS/busted", "LuaCATS/luassert" },
	})

	-- Elixir
	use({
		"elixir-tools/elixir-tools.nvim",
		tag = "stable",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("elixir").setup()
		end,
	})

	-- MIPS Assembly Syntax Highlighting
	use("harenome/vim-mipssyntax")

	-- Web Assembly Syntax Highlighting
	use("rhysd/vim-wasm")

	-- F# Syntax Highlighting
	use("adelarsq/neofsharp.vim")

	-- Crystal
	use("vim-crystal/vim-crystal")

	-- Idris
	-- Install idris2-lsp via pack as described here:
	-- https://github.com/idris-community/idris2-lsp?tab=readme-ov-file
	use({
		"ShinKage/idris2-nvim",
		requires = { "neovim/nvim-lspconfig", "MunifTanjim/nui.nvim" },
	})

	-- GNU Octave (MATLAB)
	-- This is only syntax highlighting, not a full LSP
	-- (info pages for Octave functions can be shown with `K`, though)
	-- There is https://github.com/mathworks/MATLAB-language-server, but this
	-- requires a real MATLAB installation, not just GNU Octave.
	use("gnu-octave/vim-octave")

	-- (Auto) Formatter
	use("stevearc/conform.nvim")

	-- Trouble: project wide diagnostics
	use({
		"folke/trouble.nvim",
		requires = "nvim-tree/nvim-web-devicons",
	})

	-- GitHub Copilot
	use("github/copilot.vim")
	use("ofseed/copilot-status.nvim")

	-- Writable quickfix window
	use("stefandtw/quickfix-reflector.vim")

	-- Find and display URLs (:UrlView)
	-- :UrlView packer shows URLs of all installed packer plugins
	use("axieax/urlview.nvim")

	-- Zen mode (toggle buffer to full-screen floating window)
	use("folke/zen-mode.nvim")
	use("folke/twilight.nvim") -- integrates with Zen mode, dim inactive areas

	-- Animated cursor
	use("sphamba/smear-cursor.nvim")

	-- Just for fun
	use("eandrju/cellular-automaton.nvim")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
