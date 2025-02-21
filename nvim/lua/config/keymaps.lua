vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local noremap_silent = { noremap = true, silent = true }

-- navigate buffers with <Tab> and <Shift>+<Tab>
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", noremap_silent)
vim.keymap.set("n", "<Tab>", ":bnext<CR>", noremap_silent)

-- clear search highlight
vim.keymap.set("n", "<leader>h", ":noh<CR>", { desc = "Clear search highlight" })

-- move selected lines up and down, with correct indentation (visual J/K)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor in place when joining lines (J)
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })

-- delete into blackhole register (keep current paste)
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank" })
-- copy to system clipboard (works magically from WSL to Windows)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })

-- toggle quickfix window with <C-q>, taken from:
-- https://old.reddit.com/r/neovim/comments/vramof/better_keymaps_for_toggling_quickfix_focus_and/ievet6c/
vim.keymap.set("n", "<C-q>", function()
	local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
	local action = qf_winid > 0 and "cclose" or "copen"
	vim.cmd("botright " .. action)
end, noremap_silent)
-- navigate between quickfix items with <C-j> and <C-k>
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>")

-- Currently disabled, as I don't really use the location list.
-- It might be cool, though, it's a window-specific qflist, see:
-- https://stackoverflow.com/a/20934608
-- TL;DR: :lvim foo % / :lopen / :lnext / :lprev
--        for buffer/window local search results in the location list
-- vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>")
-- vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>")

-- replace current word under cursor (with live preview)
-- (F1 is already help, F2-F4 are used for LSP via lsp-zero)
vim.keymap.set("n", "<F5>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace current word" })

-- make current file executable (shell scripts)
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- move "record macro" from q to Q (q is hit accidentally way too often)
vim.keymap.set("n", "Q", "q", { desc = "Record macro" })
vim.keymap.set("n", "q", "<nop>")

-- command line, map <C-p>/<C-n> to work like up/down (history /w matching prefix)
-- see https://stackoverflow.com/a/60355468/183582 for a good explanation
local cmd_history_opts = { expr = true, replace_keycodes = false }
vim.keymap.set("c", "<C-p>", 'wildmenumode() ? "\\<C-p>" : "\\<Up>"', cmd_history_opts)
vim.keymap.set("c", "<C-n>", 'wildmenumode() ? "\\<C-n>" : "\\<Down>"', cmd_history_opts)
