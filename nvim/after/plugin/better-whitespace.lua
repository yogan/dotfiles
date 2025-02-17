-- Strip whitespace operator, also works on visual selection
-- Operator mode examples:
--    <leader>Wj  - current line
--    <leader>Wap - current paragraph
--    <leader>Wib - current block (e.g. {…})
--    <leader>Wig - current git change hunk
vim.g.better_whitespace_operator = "<leader>W"

vim.g.better_whitespace_filetypes_blacklist = {
	"diff",
	"git",
	"gitcommit",
	"unite",
	"qf",
	"help",
	"markdown",
	"fugitive",
	"snacks_dashboard",
	"",
}
