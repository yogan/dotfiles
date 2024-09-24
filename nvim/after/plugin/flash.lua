local flash = require("flash")
local wk = require("which-key")

flash.setup({
	modes = {
		search = {
			enabled = true,
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
	{ "s", mode = { "n", "x", "o" }, jump, desc = "Flash" },
	{ "S", mode = { "n", "x", "o" }, treesitter, desc = "Flash Treesitter" },
	{ "<leader>S", mode = { "n", "x", "o" }, jump_continue, desc = "Flash Continue" },
	{ "R", mode = { "o", "x" }, treesitter_search, desc = "Treesitter Search" },
	{ "<c-s>", mode = { "c" }, toggle, desc = "Toggle Flash Search" },
	{ "<leader>l", mode = { "n", "v" }, jump_to_line, desc = "Flash Line" },
	{ "<leader>w", mode = { "n", "v" }, current_word, desc = "Flash Current Word" },
})
