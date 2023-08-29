require('bufferline').setup {
    highlights = {
        buffer_selected = { italic = true },
    },
    options = {
        separator_style = 'slant',
        modified_icon = '',
        show_buffer_close_icons = false,
        show_close_icon = false,
        offsets = {
            {
                filetype = 'NvimTree',
                text = function()
                    return ' ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
                end,
                -- HINT: :highlight or :Telescope highlights to check options
                highlight = 'BufferLineFill',
                separator = true, -- uses offset_separator colors
            }
        },
    }
}

vim.keymap.set('n', '<leader>bb', '<cmd>BufferLinePick<cr>',
    { noremap = true, silent = true, desc = 'Jump to buffer' }
)
vim.keymap.set('n', '<leader>bj', '<cmd>BufferLineCycleNext<cr>',
    { noremap = true, silent = true, desc = 'Next buffer' }
)
vim.keymap.set('n', '<leader>bk', '<cmd>BufferLineCyclePrev<cr>',
    { noremap = true, silent = true, desc = 'Previous buffer' }
)
vim.keymap.set('n', '<leader>bl', '<cmd>BufferLineMoveNext<cr>',
    { noremap = true, silent = true, desc = 'Move buffer right' }
)
vim.keymap.set('n', '<leader>bh', '<cmd>BufferLineMovePrev<cr>',
    { noremap = true, silent = true, desc = 'Move buffer left' }
)
vim.keymap.set('n', '<leader>bp', '<cmd>BufferLineTogglePin<cr>',
    { noremap = true, silent = true, desc = 'Pin/unpin buffer' }
)
vim.keymap.set('n', '<leader>bc', '<cmd>BufferLinePickClose<cr>',
    { noremap = true, silent = true, desc = 'Close buffer' }
)

local close_buffers = require('close_buffers')

close_buffers.setup {
    preserve_window_layout = { 'this' },
    next_buffer_cmd = function(windows)
        require('bufferline').cycle(1)
        local bufnr = vim.api.nvim_get_current_buf()

        for _, window in ipairs(windows) do
            vim.api.nvim_win_set_buf(window, bufnr)
        end
    end,
}

vim.keymap.set('n', '<leader>bH',
    function() close_buffers.delete { type = 'hidden' } end,
    { noremap = true, silent = true, desc = 'Close hidden buffers' }
)
vim.keymap.set('n', '<leader>bU',
    function() close_buffers.delete { type = 'nameless' } end,
    { noremap = true, silent = true, desc = 'Close unnamed buffers' }
)
vim.keymap.set('n', '<leader>bC',
    function() close_buffers.delete { type = 'this' } end,
    { noremap = true, silent = true, desc = 'Close current buffer' }
)
