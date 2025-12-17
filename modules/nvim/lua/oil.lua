require("oil").setup({
	default_file_explorer = true,
	skip_confirm_for_simple_edits = false,
	float = {
		padding = 2,
		max_width = 0.8,
		max_height = 0,
		border = nil,
		win_options = {
			winblend = 0,
		},
		get_win_title = nil,
		preview_split = "auto",
		override = function(conf)
			return conf
		end,
	},
})

nnoremap("<leader>e", ":Oil --float<CR>")
