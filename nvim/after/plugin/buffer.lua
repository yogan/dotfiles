local close_buffers = require("close_buffers")

vim.keymap.set("n", "<leader>Bh", function()
	close_buffers.delete({ type = "hidden" })
end, { noremap = true, silent = true, desc = "Close [h]idden buffers" })
vim.keymap.set("n", "<leader>Bu", function()
	close_buffers.delete({ type = "nameless" })
end, { noremap = true, silent = true, desc = "Close [u]nnamed buffers" })
vim.keymap.set("n", "<leader>Bc", function()
	close_buffers.delete({ type = "this" })
end, { noremap = true, silent = true, desc = "Close [c]urrent buffer" })
