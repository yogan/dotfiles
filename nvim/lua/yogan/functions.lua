vim.api.nvim_create_user_command("Qa", function(opts)
	if opts.bang then
		vim.cmd("silent qa!")
	else
		vim.cmd("silent qa")
	end
end, { bang = true })
