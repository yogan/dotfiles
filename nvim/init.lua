-- Settings that should be set before plugins are loaded
require("yogan.filetype")
require("yogan.functions")
require("yogan.keymaps")
require("yogan.neovide")
require("yogan.options")

-- Lazy plugins
require("config.lazy")

-- Auto commands go last, since they also do stuff for plugins, which need
-- to be loaded first.
require("yogan.autocmds")
