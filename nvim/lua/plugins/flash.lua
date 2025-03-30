return {
	"folke/flash.nvim",
	dependencies = "folke/which-key.nvim",
	opts = {
		modes = {
			-- can be enabled when needed with <C-s> during search, see bottom
			search = { enabled = false },
			-- disable handling of `f`, `F`, `t`, `T`, `;` and `,` motions
			-- (defaults for fFtT are fine, and ; and , are handled by
			-- treesitter-textobjects to repeat all kinds of motions)
			char = { enabled = false },
		},
		label = {
			rainbow = {
				enabled = true,
				shade = 3, -- number between 1 and 9
			},
		},
	},
	config = function(_, opts)
		local flash = require("flash")
		local wk = require("which-key")

		flash.setup(opts)

		local function jump_to_line()
			flash.jump({
				search = { mode = "search", max_length = 0 },
				label = { after = { 0, 0 } },
				pattern = "^",
			})
		end

		local function current_word()
			flash.jump({
				pattern = vim.fn.expand("<cword>"),
			})
		end

		local function map(mode, l, r, desc)
			wk.add({
				{ mode = mode, l, r, desc = desc, icon = { icon = "", color = "yellow" } },
				group = "Flash",
			})
		end

		map({ "n", "x", "o" }, "s", function() flash.jump() end, "Flash")
		map({ "n", "x", "o" }, "S", function() flash.treesitter() end, "Flash Treesitter Select")
		map({ "n", "x", "o" }, "<M-s>", function() flash.jump({ continue = true }) end, "Flash Continue")
		map({ "n", "v" }, "<leader>l", jump_to_line, "Flash Line")
		map({ "n", "v" }, "<M-w>", current_word, "Flash Current Word")
		map({ "x", "o" }, "R", function() flash.treesitter_search() end, "Flash Treesitter Search")
		map({ "c" }, "<C-s>", function() flash.toggle() end, "Flash Toggle Search")
	end,
}
