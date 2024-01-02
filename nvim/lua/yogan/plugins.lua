-- auto install packer if not installed
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1',
            'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

-- Automatically sync plugins when this file (packer.lua) is written
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require('packer.util').float { border = 'rounded' }
        end
    }
}

-- Load the actual plugins
return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Color scheme, status line, icons, indent guides, trailing whitespace
    -- Config for all of those in after/plugin/colors.lua (cross dependencies)
    use 'EdenEast/nightfox.nvim'
    use 'nvim-lualine/lualine.nvim'
    use 'kyazdani42/nvim-web-devicons' -- also used by nvim-tree
    use 'lukas-reineke/indent-blankline.nvim'
    use 'ntpeters/vim-better-whitespace'

    -- Comments.nvim
    use 'numToStr/Comment.nvim'
    use 'JoosepAlviste/nvim-ts-context-commentstring' -- for jsx/tsx support

    -- Bufferline and close buffers (config for both: after/plugin/buffer.lua)
    use { 'akinsho/bufferline.nvim', tag = 'v3.*',
        requires = 'nvim-tree/nvim-web-devicons' }
    use 'kazhala/close-buffers.nvim'

    -- File explorer
    use {
        'nvim-tree/nvim-tree.lua',
        -- nighly is actually weekly, see:
        -- https://github.com/nvim-tree/nvim-tree.lua/issues/1193#issuecomment-1120178402
        tag = 'nightly'
    }

    -- Git
    use 'lewis6991/gitsigns.nvim'

    -- Automatically set indentation settings
    use 'nmac427/guess-indent.nvim'

    -- Better folding
    use {
        "kevinhwang91/nvim-ufo",
        requires = {
            "kevinhwang91/promise-async",
            {
                -- This replaces ugly -/+/1/2/… fold column entries with nice
                -- clickable icons. See:
                -- https://github.com/kevinhwang91/nvim-ufo/issues/4#issuecomment-1411582218
                -- (and vim.opt.fillchars in ufo.lua)
                "luukvbaal/statuscol.nvim",
                config = function()
                    local builtin = require("statuscol.builtin")
                    require("statuscol").setup({
                        relculright = true,
                        segments = {
                            { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
                            { text = { "%s" }, click = "v:lua.ScSa" },
                            { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
                        },
                    })
                end

            }
        }
    }

    -- Start screen
    use {
        'goolord/alpha-nvim',
        requires = { 'nvim-tree/nvim-web-devicons' },
    }

    -- Session management
    use {
        'jedrzejboczar/possession.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
    }

    -- Telescope fuzzy thingy
    use {
        'nvim-telescope/telescope.nvim', branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use 'nvim-telescope/telescope-symbols.nvim'

    -- Todo comments
    use {
        'folke/todo-comments.nvim',
        requires = 'nvim-lua/plenary.nvim',
    }

    -- Treesitter
    -- NOTE for Windows: Treesitter requires a C compiler. This one works fine:
    -- https://github.com/skeeto/w64devkit (unzip somewhere, add bin/ to PATH)
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    use 'nvim-treesitter/playground'
    use 'nvim-treesitter/nvim-treesitter-context'

    -- Harpoon (jump around and shit)
    -- NOTE: https://github.com/toppair/reach.nvim might be nicer
    use 'theprimeagen/harpoon'

    -- Surround (there are alternatives and stuff, but this seems fine)
    use {
        'kylechui/nvim-surround',
        tag = '*', -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require('nvim-surround').setup()
        end
    }

    -- Leap (similar to EasyMotion)
    use 'ggandor/leap.nvim'

    -- Shows not only key mappings, but also registers, marks, etc.
    use {
        'folke/which-key.nvim',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
            require('which-key').setup()
        end
    }

    -- Undo tree
    use 'mbbill/undotree'

    -- LSP & Friends
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            -- Snippet Collection (Optional)
            { 'rafamadriz/friendly-snippets' },
        }
    }
    -- additional functionality for typescript server (rename file, update imports, etc.)
    use 'jose-elias-alvarez/typescript.nvim'

    -- formatter
    use 'stevearc/conform.nvim'

    -- Trouble: project wide diagnostics
    use {
        'folke/trouble.nvim',
        requires = 'nvim-tree/nvim-web-devicons',
    }

    -- GitHub Copilot
    use 'github/copilot.vim'

    -- Find and display URLs (:UrlView)
    -- :UrlView packer shows URLs of all installed packer plugins
    use 'axieax/urlview.nvim'

    -- Zen mode (toggle buffer to full-screen floating window)
    use 'folke/zen-mode.nvim'
    use 'folke/twilight.nvim' -- integrates with Zen mode, dim inactive areas

    -- Just for fun
    use 'eandrju/cellular-automaton.nvim'

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
