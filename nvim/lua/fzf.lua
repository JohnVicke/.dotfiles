local fzf = require("fzf-lua")
fzf.setup({
	winopts = {
		height  = 0.90,
		width   = 0.90,
		row     = 0.99,
		col     = 0.5,
		border  = "rounded",
		preview = {
			layout = "horizontal",
			horizontal = "right:60%",
			flip_columns = 120,
		},
	},
	fzf_opts = {
		['--layout'] = 'reverse-list',
	},
})
fzf.register_ui_select()

nnoremap("<leader>ff", fzf.files)
nnoremap("<leader><Space>", fzf.files)
nnoremap("<leader>fg", fzf.live_grep)
nnoremap("<leader>fb", fzf.builtin)
nnoremap("<leader>fw", fzf.grep_cword)
