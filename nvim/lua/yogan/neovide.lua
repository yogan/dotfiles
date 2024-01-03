if not vim.g.neovide then
	return
end

vim.keymap.set({ "i", "c" }, "<S-Insert>", "<C-R>+")

vim.opt.guifont = "VictorMono Nerd Font:h12"

vim.g.neovide_cursor_vfx_mode = "pixiedust" -- cursor goes brrr
vim.g.neovide_hide_mouse_when_typing = true

-- transparency in percent
vim.opt.pumblend = 20
vim.opt.winblend = 20

-- blurring of background in transparent floats
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0
