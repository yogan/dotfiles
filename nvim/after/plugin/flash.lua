local flash = require("flash")
local wk = require("which-key")

flash.setup({
	modes = {
		search = {
			enabled = true,
		},
		-- disable handling of `f`, `F`, `t`, `T`, `;` and `,` motions
		-- (defaults for fFtT are fine, and ; and , are handled by
		-- treesitter-textobjects to repeat all kinds of motions)
		char = {
			enabled = false,
		},
	},
	label = {
		rainbow = {
			enabled = true,
			shade = 9, -- number between 1 and 9
		},
	},
})

local function jump()
	flash.jump()
end

local function jump_continue()
	flash.jump({ continue = true })
end

local function treesitter()
	flash.treesitter()
end

local function treesitter_search()
	flash.treesitter_search()
end

local function toggle()
	flash.toggle()
end

local function current_word()
	flash.jump({
		pattern = vim.fn.expand("<cword>"),
	})
end

local function jump_to_line()
	flash.jump({
		search = { mode = "search", max_length = 0 },
		label = { after = { 0, 0 } },
		pattern = "^",
	})
end

wk.add({
	{ "s", mode = { "n", "x", "o" }, jump, desc = " Flash" },
	{ "S", mode = { "n", "x", "o" }, treesitter, desc = " Flash Treesitter Select" },
	{ "<leader>S", mode = { "n", "x", "o" }, jump_continue, desc = " Flash Continue" },
	{ "R", mode = { "o", "x" }, treesitter_search, desc = " Flash Treesitter Search" },
	{ "<c-s>", mode = { "c" }, toggle, desc = " Flash Toggle Search" },
	{ "<leader>l", mode = { "n", "v" }, jump_to_line, desc = " Flash Line" },
	{ "<leader>w", mode = { "n", "v" }, current_word, desc = " Flash Current Word" },
})
