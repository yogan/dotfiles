local alpha = require("alpha")
local theme = require("alpha.themes.startify")

local query = require("possession.query")
local get_layout = function()
	return query.alpha_workspace_layout({}, theme.button, { others_name = "ﮛ Sessions" })
end
local utils = require("possession.utils")
local function session()
	return {
		type = "group",
		val = utils.throttle(get_layout, 5000),
	}
end

table.insert(theme.config.layout, 5, session())

alpha.setup(theme.config)
