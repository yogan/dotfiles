return {
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

	-- Commenting stuff
	"numToStr/Comment.nvim",
	"JoosepAlviste/nvim-ts-context-commentstring", -- for jsx/tsx support

	-- (Auto) Formatting
	"stevearc/conform.nvim",

	-- Highlighting and trimming of trailing whitespace
	{
		"ntpeters/vim-better-whitespace",
		-- Loading the plugin on this event helps that the initial Snacks dashboard
		-- has its filetype set to 'snacks_dashboard', see:
		-- https://github.com/folke/snacks.nvim/issues/1220#issuecomment-2661542968
		event = "BufReadPost",
	},

	-- GitHub Copilot
	"github/copilot.vim",
	"ofseed/copilot-status.nvim",

	-- Surround (there are alternatives and stuff, but this seems fine)
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = true,
	},

	-- Todo comments
	{
		"folke/todo-comments.nvim",
		dependencies = "nvim-lua/plenary.nvim",
	},

	-- Trouble: project wide diagnostics
	{
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
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
}
