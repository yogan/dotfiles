require("Comment").setup({
	-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring#commentnvim
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),

	-- NOTE: Changed default gb/gbc prefix to gC/gCC for blockwise comments,
	--       so that <leader>gb can be mapped to git blame (see gitsigns.lua).

	---LHS of toggle mappings in NORMAL mode
	toggler = {
		---Line-comment toggle keymap
		line = "gcc",
		---Block-comment toggle keymap
		block = "gCC",
	},
	---LHS of operator-pending mappings in NORMAL and VISUAL mode
	opleader = {
		---Line-comment keymap
		line = "gc",
		---Block-comment keymap
		block = "gC",
	},
})

local ft = require("Comment.ft")
ft.set("gitconfig", "# %s") -- default is ; but all my stuff uses # (both work)

if vim.g.neovide then
	vim.keymap.set("n", "<C-/>", "<Plug>(comment_toggle_linewise_current)")
	vim.keymap.set("v", "<C-/>", "<Plug>(comment_toggle_linewise_visual)")
else
	-- Ctrl+/ is <C-_>, see https://vi.stackexchange.com/a/26617
	vim.keymap.set("n", "<C-_>", "<Plug>(comment_toggle_linewise_current)")
	vim.keymap.set("v", "<C-_>", "<Plug>(comment_toggle_linewise_visual)")
end
