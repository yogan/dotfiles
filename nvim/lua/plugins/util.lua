return {
	-- Shows not only key mappings, but also registers, marks, etc.
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function() require("which-key").show({ global = false }) end,
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
		init = function() vim.g.startuptime_tries = 10 end,
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

			map("<leader>bc", function() cb.delete({ type = "this" }) end, "Close current buffer")

			map("<leader>bh", function() cb.delete({ type = "hidden" }) end, "Close hidden buffers")

			map("<leader>bu", function() cb.delete({ type = "nameless" }) end, "Close unnamed buffers")
		end,
	},

	-- Session management
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- only start saving when a file was opened
		config = true,
	},

	-- Writable quickfix window
	"stefandtw/quickfix-reflector.vim",

	-- Undo tree
	{
		"mbbill/undotree",
		event = "BufRead",
		config = function()
			require("which-key").add({
				{ mode = "n", "<leader>U", vim.cmd.UndotreeToggle, desc = "Toggle undo tree", icon = "󰕍" },
			})
		end,
	},

	-- Find and open URLs in browser
	{
		"axieax/urlview.nvim",
		config = function()
			require("urlview").setup({
				default_action = "system",
				sorted = false,
			})

			require("which-key").add({
				{ mode = "n", "<leader>uu", "<Cmd>UrlView<CR>", desc = "View buffer URLs", icon = "" },
				{ mode = "n", "<leader>up", "<Cmd>UrlView lazy<CR>", desc = "View lazy plugin URLs", icon = "󰒲" },
			})
		end,
	},

	-- Extended increment/decrement (^A/^X), works for dates, hex colors, etc.
	{
		"monaqa/dial.nvim",
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.date.alias["%Y-%m-%d"],
					augend.hexcolor.new(),
				},
			})

			vim.keymap.set("n", "<C-a>", function() require("dial.map").manipulate("increment", "normal") end)
			vim.keymap.set("n", "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end)
			vim.keymap.set("n", "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end)
			vim.keymap.set("n", "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end)
			vim.keymap.set("v", "<C-a>", function() require("dial.map").manipulate("increment", "visual") end)
			vim.keymap.set("v", "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end)
			vim.keymap.set("v", "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end)
			vim.keymap.set("v", "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end)
		end,
	},

	-- Just for fun
	"eandrju/cellular-automaton.nvim",
}
