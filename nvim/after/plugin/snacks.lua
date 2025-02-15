---@diagnostic disable-next-line: missing-fields
require("snacks").setup({
	picker = {
		enabled = true,
		win = {
			input = {
				bo = {
					textwidth = 0,
				},
			},
			preview = {
				wo = {
					number = false,
					spell = false,
					wrap = false,
					statuscolumn = "",
					foldcolumn = "0",
				},
			},
		},
	},
	bigfile = { enabled = true },
	toggle = { enabled = true },
	words = { enabled = true },
})

local sp = require("snacks.picker")
local wk = require("which-key")

local function map(l, r, desc, mode)
	wk.add({
		{ mode = mode or "n", l, r, desc = desc },
		group = "Snacks",
	})
end

local function smart_picker()
	sp.smart({ hidden = true })
end

local function vim_config_files()
	---@diagnostic disable-next-line: assign-type-mismatch
	sp.files({ cwd = vim.fn.stdpath("config") })
end

-- Important pickers on control + key
map("<C-b>", sp.buffers, "Buffers")
map("<C-f>", sp.grep, "Grep")
map("<C-g>", sp.grep_buffers, "Grep buffers")
map("<C-p>", smart_picker, "Find files")
map("<C-x>", sp.explorer, "Explorer")

-- Special things
map("<F1>", sp.help, "Help Pages")
map("<leader>,", sp.spelling, "Spelling")
map("<leader>*", sp.grep_word, "Live grep (word or selection)", { "n", "x" })

-- <leader>s namespace for various snacks pickers
map('<leader>s"', sp.registers, "Registers")
map("<leader>s/", sp.search_history, "Search History")
map("<leader>sa", sp.autocmds, "Autocmds")
map("<leader>sb", sp.lines, "Buffer Lines")
map("<leader>sc", sp.command_history, "Command History")
map("<leader>sC", sp.commands, "Commands")
map("<leader>sd", sp.diagnostics, "Diagnostics")
map("<leader>sD", sp.diagnostics_buffer, "Buffer Diagnostics")
map("<leader>sh", sp.help, "Help Pages")
map("<leader>sH", sp.highlights, "Highlights")
map("<leader>si", sp.icons, "Icons")
map("<leader>sj", sp.jumps, "Jumps")
map("<leader>sk", sp.keymaps, "Keymaps")
map("<leader>sl", sp.loclist, "Location List")
map("<leader>sM", sp.man, "Man Pages")
map("<leader>sm", sp.marks, "Marks")
map("<leader>so", sp.colorschemes, "Colorschemes")
map("<leader>sq", sp.qflist, "Quickfix List")
map("<leader>sR", sp.resume, "Resume")
map("<leader>su", sp.undo, "Undo History")
map("<leader>sv", vim_config_files, "Vim Config Files")

-- LSP
-- Remember to keep this in sync with the `omit` list of
-- `lsp_zero.default_keymaps` in `lsp.lua`.
map("gd", sp.lsp_definitions, "Goto Definitions")
map("gD", sp.lsp_declarations, "Goto Declarations")
map("gr", sp.lsp_references, "References")
map("gi", sp.lsp_implementations, "Goto Implementations")
map("gy", sp.lsp_type_definitions, "Goto Type Definitions")
map("<leader>ss", sp.lsp_symbols, "LSP Symbols")
map("<leader>sS", sp.lsp_workspace_symbols, "LSP Workspace Symbols")
