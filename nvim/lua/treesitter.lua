local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
	ensure_installed = {},
	ignore_install = {},
	modules = {},
	auto_install = false,
	sync_install = false,
	highlight = { enable = true },
	indent = { enable = true },
})
