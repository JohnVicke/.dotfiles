local nnmap = require("johnvicke.keymap").nnoremap

require("gitsigns").setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]h", function()
			if vim.wo.diff then
				return "]h"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "[h", function()
			if vim.wo.diff then
				return "[h"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		-- Actions
		nnmap("<leader>hs", ":Gitsigns stage_hunk<CR>")
		nnmap("<leader>hr", ":Gitsigns reset_hunk<CR>")
		nnmap("<leader>gsb", gs.stage_buffer, { desc = "[G]it [S]tage [B]uffer" })
		nnmap("<leader>guh", gs.undo_stage_hunk, { desc = "[G]it [U]ndo [H]unk" })
		nnmap("<leader>grb", gs.reset_buffer, { desc = "[G]it [R]eset [B]uffer" })
		nnmap("<leader>gph", gs.preview_hunk, { desc = "[G]it [P]review [H]unk" })
		nnmap("<leader>gbl", function()
			gs.blame_line({ full = true })
		end, { desc = "[G]it [B]lame [L]ine" })
		nnmap("<leader>gdt", gs.diffthis, { desc = "[G]it [D]iff [T]his" })
		nnmap("<leader>dt", function()
			gs.diffthis("~")
		end, { desc = "[D]iff [T]his" })
		nnmap("<leader>td", gs.toggle_deleted)

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})
