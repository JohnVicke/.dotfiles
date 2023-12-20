local vnoremap = require("johnvicke.keymap").vnoremap
local nnoremap = require("johnvicke.keymap").nnoremap

require("refactoring").setup({
	prompt_func_return_type = {
		go = false,
		java = false,
		cpp = false,
		c = false,
		h = false,
		hpp = false,
		cxx = false,
	},
	prompt_func_param_type = {
		go = false,
		java = false,
		cpp = false,
		c = false,
		h = false,
		hpp = false,
		cxx = false,
	},
	printf_statements = {},
	print_var_statements = {},
})

vnoremap("<leader>re", function()
	require("refactoring").refactor("Extract Function")
end, { desc = "[R]efactor [E]xtract [F]unction" })

vnoremap("<leader>rfe", function()
	require("refactoring").refactor("Extract Function To File")
end, { desc = "[R]efactor [Function] [E]xtract to [F]ile" })

nnoremap("<leader>rb", function()
	require("refactoring").refactor("Extract Block")
end, { desc = "[R]efactor [B]lock" })

nnoremap("<leader>rfb", function()
	require("refactoring").refactor("Extract Block To File")
end, { desc = "[R]efactor to [F]ile [B]lock " })
