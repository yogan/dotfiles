vim.g.mapleader = " "

-- navigate buffers with <Tab> and <Shift>+<Tab>
vim.api.nvim_set_keymap("n", "<S-Tab>", ":bprev<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true })

-- clear search highlight
vim.keymap.set("n", "<leader>/", ":noh<CR>", { desc = "Clear search highlight" })

-- move selected lines up and down, with correct indentation (visual J/K)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor in place when joining lines (J)
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })

-- delete into blackhole register (keep current paste)
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank" })
-- copy to system clipboard (works magically from WSL to Windows)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })

-- navigating between entries from quickfix/location list
-- currently not needed, but might be, so let's keep 'em ready to go
-- vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz')
-- vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz')
-- vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz')
-- vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz')

-- replace current word under cursor (with live preview)
vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace current word" }
)

-- make current file executable (shell scripts)
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- move "record macro" from q to Q (q is hit accidentally way too often)
vim.keymap.set("n", "Q", "q", { desc = "Record macro" })
vim.keymap.set("n", "q", "<nop>")

-- toggles
vim.keymap.set("n", "<leader>tn", "<cmd>set invnumber<CR>", { desc = "Toggle line numbers" })
vim.keymap.set("n", "<leader>tl", "<cmd>set invlist<CR>", { desc = "Toggle invisible char (list mode)" })
vim.keymap.set("n", "<leader>tw", "<cmd>set invwrap<CR>", { desc = "Toggle line wrapping" })
vim.keymap.set("n", "<leader>ts", "<cmd>set invspell<CR>", { desc = "Toggle spell checking" })

-- command line, map <C-p>/<C-n> to work like up/down (history /w matching prefix)
-- see https://stackoverflow.com/a/60355468/183582 for a good explanation
local cmd_history_opts = { expr = true, replace_keycodes = false }
vim.keymap.set("c", "<C-p>", 'wildmenumode() ? "\\<C-p>" : "\\<Up>"', cmd_history_opts)
vim.keymap.set("c", "<C-n>", 'wildmenumode() ? "\\<C-n>" : "\\<Down>"', cmd_history_opts)
