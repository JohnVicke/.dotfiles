local nnoremap = require("johnvicke.keymap").nnoremap
local vnoremap = require("johnvicke.keymap").vnoremap

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

vnoremap("<leader>rf", function()
	require("refactoring").refactor("Extract Function")
end)
