local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

local nnmap = require("johnvicke.keymap").nnoremap

require("telescope").setup({
	defaults = {
		prompt_prefix = " >",
		color_devicons = true,
		file_sorter = require("telescope.sorters").get_fzy_sorter,
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
		mappings = {
			n = {
				["q"] = actions.close,
				["<S-Enter>"] = actions.select_tab,
			},
		},
	},
	extensions = {
		file_browser = {
			hijack_netrw = true,
			mappings = {
				["i"] = {
					-- your custom insert mode mappings
				},
				["n"] = {
					-- your custom normal mode mappings
				},
			},
		},
	},
	["ui-select"] = {},
})

nnmap("<leader>ff", function()
	builtin.find_files()
end, { desc = "Telescope [F]ind [F]iles" })

nnmap("<leader>fg", function()
	builtin.live_grep()
end, { desc = "Telescope [F]ind [G]rep" })

nnmap("<leader>fr", function()
	builtin.lsp_references()
end, { desc = "Telescope [F]ind [R]eferences" })

nnmap("<leader>fs", function()
	builtin.lsp_document_symbols()
end, { desc = "Telescope [F]ind [S]ymbols" })

nnmap("<leader>cf", function()
	builtin.current_buffer_fuzzy_find()
end, { desc = "Telescope [C]urrent Buffer Fuzzy [F]ind" })

nnmap("gd", function()
	builtin.lsp_definitions()
end, { desc = "Telescope [G]o [D]efinition" })
