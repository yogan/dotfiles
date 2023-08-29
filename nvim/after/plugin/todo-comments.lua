require('todo-comments').setup {
    keywords = {
        FIX  = { icon = ' ', color = 'error', alt = { 'FIXME', 'FIXIT', 'BUG', 'BUGS' } },
        WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'WARNINGS', 'ATTENTION' } },
        TODO = { icon = ' ', color = 'info', alt = { 'TODOS', 'ISSUE', 'ISSUES' } },
        NOTE = { icon = '󰎞 ', color = 'hint', alt = { 'NOTES', 'INFO', 'INFOS', 'HINT', 'HINTS' } },
    },
    merge_keywords = false, -- use only keywords listed above, don't include defaults
    highlight = {
        before = '',
        keyword = 'wide_bg',
        after = 'fg',
        -- Listing the pattern twice is a workaround. The trailing : shall be optional,
        -- which should work with e.g. :\? or :\= or :\{,1} or some other vim regex magic,
        -- but of course it does not. So let's just pass a table with both
        -- variants and move on with our live.
        pattern = { [[<(KEYWORDS)>:]], [[<(KEYWORDS)>]] }, -- vim syntax
        comments_only = true, -- uses treesitter to match keywords in comments only
    },
    search = {
        pattern = [[\b(KEYWORDS):?\b]], -- ripgrep regex
    }
}
