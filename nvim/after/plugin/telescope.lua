local telescope           = require('telescope')
local action_layout       = require('telescope.actions.layout')
local builtin             = require('telescope.builtin')

local insert_mappings     = {
    ['<C-h>']      = 'which_key', -- show mappings (same as <C-/>)
    ['<C-j>']      = 'move_selection_next',
    ['<C-k>']      = 'move_selection_previous',
    ['<C-u>']      = false,                    -- remove to fallback to clear line
    ['<PageUp>']   = 'preview_scrolling_up',   -- replacements for
    ['<PageDown>'] = 'preview_scrolling_down', -- <C-u>/<C-d>
    ['<F4>']       = action_layout.toggle_preview,
}

local normal_mappings     = {
    ['<F4>'] = action_layout.toggle_preview
}

local trouble_ok, trouble = pcall(require, 'trouble.providers.telescope')
if trouble_ok then
    -- Move telescope results to trouble window with <C-t>
    -- Usage example:
    --     <leader>* to search for word under cursor (see mapping below),
    --     preview results in telescope, <C-t> to move to trouble window.
    insert_mappings['<C-t>'] = trouble.open_with_trouble
    normal_mappings['<C-t>'] = trouble.open_with_trouble
end

telescope.setup {
    defaults = {
        -- mappings used while telescope prompt is open
        mappings = { i = insert_mappings, n = normal_mappings, },
        file_ignore_patterns = { 'node_modules', '_compiled.lua' }
    }
}

telescope.load_extension('fzf')

-- help
vim.keymap.set('n', '<F1>',       builtin.help_tags, { desc = 'Help tags' })

-- search
vim.keymap.set('n', '<C-f>',      builtin.live_grep)
vim.keymap.set('n', '<leader>*',  builtin.grep_string, { desc = 'Search for word under cursor' })

-- buffers
vim.keymap.set('n', '<C-b>',      builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = 'Buffers' })

-- files
vim.keymap.set('n', '<C-p>',      builtin.find_files, { desc = 'Find file' })

-- git
vim.keymap.set('n', '<C-g>',      builtin.git_files,  { desc = 'Git files' })
vim.keymap.set('n', '<leader>pg', builtin.find_files, { desc = 'Git files' })
vim.keymap.set('n', '<leader>pc', builtin.git_status, { desc = 'Git status (changes)' })

-- vim things
vim.keymap.set('n', '<leader>p/', builtin.search_history, { desc = 'Search history' })
vim.keymap.set('n', '<leader>p=', builtin.spell_suggest,  { desc = 'Spell suggestions' }) -- vim: z=
vim.keymap.set('n', '<leader>ph', builtin.highlights,     { desc = 'Highlights' })
vim.keymap.set('n', '<leader>pj', builtin.jumplist,       { desc = 'Jumplist (previous locations)' })
vim.keymap.set('n', '<leader>pk', builtin.keymaps,        { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>pm', builtin.marks,          { desc = 'Marks' })
vim.keymap.set('n', '<leader>po', builtin.vim_options,    { desc = 'Options' })
vim.keymap.set('n', '<leader>pr', builtin.registers,      { desc = 'Registers' })

-- symbols (telescope-symbols.nvim) (ps = symbols)
vim.keymap.set('n', '<leader>pse', function() builtin.symbols { sources = { 'emoji' } } end,
    { desc = 'Insert Emoji' })
vim.keymap.set('n', '<leader>psg', function() builtin.symbols { sources = { 'gitmoji' } } end,
    { desc = 'Insert Git Emoji' })
vim.keymap.set('n', '<leader>psn', function() builtin.symbols { sources = { 'nerd' } } end,
    { desc = 'Insert Nerd Font icon' })
vim.keymap.set('n', '<leader>psm', function() builtin.symbols { sources = { 'math' } } end,
    { desc = 'Insert math symbol' })
