-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring#commentnvim

require 'nvim-treesitter.configs'.setup {
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    }
}

require('Comment').setup {
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim')
        .create_pre_hook(),
}

local ft = require('Comment.ft')
ft.set('gitconfig', '# %s') -- default is ; but all my stuff uses # (both work)

if vim.g.neovide then
    vim.keymap.set('n', '<C-/>', '<Plug>(comment_toggle_linewise_current)')
    vim.keymap.set('v', '<C-/>', '<Plug>(comment_toggle_linewise_visual)')
else
    -- Ctrl+/ is <C-_>, see https://vi.stackexchange.com/a/26617
    vim.keymap.set('n', '<C-_>', '<Plug>(comment_toggle_linewise_current)')
    vim.keymap.set('v', '<C-_>', '<Plug>(comment_toggle_linewise_visual)')
end
