local function session_name()
    local session_ok, session = pcall(require, 'possession.session')
    if not session_ok or not session.session_name then
        return ''
    end
    return ' ' .. session.session_name
end

require('lualine').setup {
    extensions = { 'nvim-tree', 'quickfix' },
    sections = {
        lualine_a = { session_name },
        lualine_c = {
            {
                'filename',
                path = 1,
                symbols = {
                    modified = '',
                    readonly = '󰷤',
                    unnamed  = '',
                    newfile  = '',
                }
            }
        },
    },
}
