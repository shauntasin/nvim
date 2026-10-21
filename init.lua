require("config.workflows").setup()
require("config.android").setup()

-- bootstrap lazy.nvim, LazyVim and your plugins
-- Register before startup files are read (VeryLazy is too late for `nvim file.pdf`).
require("config.pdf").setup()
require("config.lazy")
