-- close help window with q
vim.api.nvim_buf_set_keymap(0, "n", "q", ":bd<cr>", { noremap = true, silent = true })
