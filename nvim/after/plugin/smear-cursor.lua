require("smear_cursor").setup({
	stiffness = 0.8, --							[0, 1]  default: 0.6
	trailing_stiffness = 0.5, --				[0, 1]  default: 0.3
	distance_stop_animating = 0.5, --			> 0		default: 0.1
	legacy_computing_symbols_support = false,
	smear_insert_mode = false,
})
