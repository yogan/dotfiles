local ftMap = {
	yaml = "indent",
	-- add empty entry when a ft shall have no folding
}

---@diagnostic disable-next-line: missing-fields
require("ufo").setup({
	---@diagnostic disable-next-line: unused-local
	provider_selector = function(bufnr, filetype, buftype)
		return ftMap[filetype] -- default fallback is { "lsp", "indent" }
	end,
})

vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99 -- ufo provider needs a large value
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.fillchars = [[eob:󱙝,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
vim.keymap.set("n", "zK", function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if not winid then
		vim.lsp.buf.hover()
	end
end, { desc = "Peek Fold" })
