vim.opt.number = false
vim.opt.relativenumber = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.showbreak = " ↪  "
vim.opt.listchars = {
	nbsp = "␣",
	tab = "»┄",
	trail = "·",
	eol = "↵",
	extends = "›",
	precedes = "‹",
}

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.opt.wrap = true
vim.opt.textwidth = 80

vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.laststatus = 3 -- one global status line at the bottom

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.spell = true
vim.opt.spelllang = "en_us,de_20" -- de_20 = new spelling (see spell-german)
vim.opt.spellsuggest = "best,9"

-- keep right click menu for casual copypasta, but remove noob advice entry
vim.cmd([[
	aunmenu PopUp.How-to\ disable\ mouse
	aunmenu PopUp.-1-
]])

-- Integrate with system clipboard
-- On Windows (within WSL) this requires win32yank:
-- scoop install win32yank
-- sudo ln -s /home/yogan/winhome/scoop/shims/win32yank.exe /usr/local/bin/win32yank
vim.opt.clipboard = "unnamedplus"
