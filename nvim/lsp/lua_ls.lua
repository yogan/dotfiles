return {
	settings = {
		Lua = {
			-- See https://github.com/LuaLS/lua-language-server/wiki/Settings#hint
			hint = {
				enable = true,

				-- "Enable"  - Show hint in all tables
				-- "Auto"    - Only show hint when there is more than 3 items or the table is mixed (indexes and keys)
				-- "Disable" - Disable array index hints
				arrayIndex = "Auto",
			},
		},
	},
}
