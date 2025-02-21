local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	install = { colorscheme = { "catppuccin-mocha" } },
	checker = { enabled = true },
	spec = {
		-- Highlighting and trimming of trailing whitespace
		{
			"ntpeters/vim-better-whitespace",
			-- Loading the plugin on this event helps that the initial Snacks dashboard
			-- has its filetype set to 'snacks_dashboard', see:
			-- https://github.com/folke/snacks.nvim/issues/1220#issuecomment-2661542968
			event = "BufReadPost",
		},

		-- Commenting stuff
		"numToStr/Comment.nvim",
		"JoosepAlviste/nvim-ts-context-commentstring", -- for jsx/tsx support

		-- Git
		"lewis6991/gitsigns.nvim",

		-- Automatically set indentation settings
		"nmac427/guess-indent.nvim",

		-- Better folding
		{
			"kevinhwang91/nvim-ufo",
			dependencies = {
				"kevinhwang91/promise-async",
				"luukvbaal/statuscol.nvim",
			},
		},

		-- Session management
		{
			"jedrzejboczar/possession.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
		},

		-- Snacks plugin collection
		"folke/snacks.nvim",

		-- Todo comments
		{
			"folke/todo-comments.nvim",
			dependencies = "nvim-lua/plenary.nvim",
		},

		-- Treesitter
		-- NOTE for Windows: Treesitter requires a C compiler. This one works fine:
		-- https://github.com/skeeto/w64devkit (unzip somewhere, add bin/ to PATH)
		{
			"nvim-treesitter/nvim-treesitter",
			build = function()
				local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
				ts_update()
			end,
		},
		"nvim-treesitter/playground",
		"nvim-treesitter/nvim-treesitter-context",
		"nvim-treesitter/nvim-treesitter-textobjects",

		-- Harpoon (jump around and shit)
		-- NOTE: https://github.com/toppair/reach.nvim might be nicer
		"theprimeagen/harpoon",

		-- Surround (there are alternatives and stuff, but this seems fine)
		{
			"kylechui/nvim-surround",
			version = "*", -- Use for stability; omit to use `main` branch for the latest features
			event = "VeryLazy",
			config = true,
		},

		-- Jump around like a boss (used to be EasyMotion and Leap)
		"folke/flash.nvim",

		-- (Auto) Formatter
		"stevearc/conform.nvim",

		-- LSP & Friends
		{
			"VonHeikemen/lsp-zero.nvim",
			branch = "v2.x",
			dependencies = {
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
		},

		-- LSP Fidget
		{
			"j-hui/fidget.nvim",
			config = function()
				require("fidget").setup({})
			end,
		},

		-- Improved LSP renaming (live preview)
		{
			"smjonas/inc-rename.nvim",
			config = function()
				require("inc_rename").setup({})
			end,
		},
		-- Trouble: project wide diagnostics
		{
			"folke/trouble.nvim",
			dependencies = "nvim-tree/nvim-web-devicons",
		},

		-- GitHub Copilot
		"github/copilot.vim",
		"ofseed/copilot-status.nvim",

		{ import = "plugins" },
	},
})
