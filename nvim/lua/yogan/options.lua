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
vim.opt.colorcolumn = "+1,+20"

vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.laststatus = 3 -- one global status line at the bottom

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.spelllang = "en_us,de_20" -- de_20 = new spelling (see spell-german)
vim.opt.spellsuggest = "best,9"
