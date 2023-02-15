local nnmap = require("johnvicke.keymap").nnoremap

require("todo-comments").setup({
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
})

nnmap("<leader>ft", "<Cmd>TodoTelescope<CR>", { desc = "Telescope [G]o [D]efinition" })
