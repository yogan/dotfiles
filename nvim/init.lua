-- Settings that should be set before plugins are loaded
require("config.filetype")
require("config.functions")
require("config.keymaps")
require("config.neovide")
require("config.options")

-- Lazy plugins
require("config.lazy")

-- Auto commands go last, since they also do stuff for plugins,
-- which need to be loaded first.
require("config.autocmds")
