require('twilight').setup {
    context = 12,
}

vim.keymap.set('n', '<leader>Z', '<cmd>Twilight<cr>', { desc = 'Toggle Twilight' })
