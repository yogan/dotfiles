vim.api.nvim_set_hl(0, 'NvimTreeNormal', { link = 'BufferInactive' })
vim.api.nvim_set_hl(0, 'NvimTreeOpenedFile', { link = 'BufferVisible' })
vim.api.nvim_set_hl(0, 'NvimTreeModifiedFile', { link = 'BufferVisibleMod' })

require('nvim-tree').setup {
    open_on_setup = false, -- open tree when nvim is started without file arg
    hijack_unnamed_buffer_when_opening = true,
    hijack_cursor = true,
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
    modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
    },
    filters = {
        custom = { '^\\.git$', '^node_modules$' }
    },
    renderer = {
        group_empty = true, -- show foo/bar/quz/ in single line
        symlink_destination = false,
        highlight_opened_files = "all",
        highlight_modified = "all",
        highlight_git = true,
        icons = {
            git_placement = "after",
            show = {
                modified = true,
            },
            glyphs = {
                modified = "",
            },
        },
    },
    update_focused_file = {
        enable = true,
    },
    view = {
        adaptive_size = true,
        width = 8, -- with adaptive_size, we can use a very low minimum
        side = 'right',
        signcolumn = 'no', -- only useful with e.g. diagnostics.enable = true
    },
}

vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
