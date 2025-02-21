return {
	-- Shows not only key mappings, but also registers, marks, etc.
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	-- Oil file explorer
	{
		"stevearc/oil.nvim",
		dependencies = "folke/which-key.nvim",
		lazy = false,
		config = function()
			require("oil").setup()
			require("which-key").add({
				{ mode = "n", "-", ":Oil<CR>", desc = "Open Oil file explorer" },
			})
		end,
	},

	-- Analyze nvim startup time
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		init = function()
			vim.g.startuptime_tries = 10
		end,
	},

	-- Close buffer helpers
	{
		"kazhala/close-buffers.nvim",
		dependencies = "folke/which-key.nvim",
		config = function()
			local cb = require("close_buffers")
			local wk = require("which-key")

			local function map(l, r, desc)
				wk.add({
					{ mode = "n", l, r, desc = desc, icon = "󰓩" },
					group = "Close Buffers",
				})
			end

			map("<leader>bc", function()
				cb.delete({ type = "this" })
			end, "Close current buffer")

			map("<leader>bh", function()
				cb.delete({ type = "hidden" })
			end, "Close hidden buffers")

			map("<leader>bu", function()
				cb.delete({ type = "nameless" })
			end, "Close unnamed buffers")
		end,
	},

	-- Session management
	{
		"jedrzejboczar/possession.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Writable quickfix window
	"stefandtw/quickfix-reflector.vim",

	-- Undo tree
	"mbbill/undotree",

	-- Find and open URLs (:UrlView lazy for plugin websites)
	"axieax/urlview.nvim",

	-- Just for fun
	"eandrju/cellular-automaton.nvim",
}
