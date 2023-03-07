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
		nnmap("<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "[H]unk [S]tage" })
		nnmap("<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "[H]unk [R]eset" })
		nnmap("<leader>sb", gs.stage_buffer, { desc = "[S]tage [B]uffer" })
		nnmap("<leader>uh", gs.undo_stage_hunk, { desc = "[U]ndo [H]unk" })
		nnmap("<leader>rb", gs.reset_buffer, { desc = "[R]eset [B]uffer" })
		nnmap("<leader>ph", gs.preview_hunk, { desc = "[P]review [H]unk" })
		nnmap("<leader>bl", function()
			gs.blame_line({ full = true })
		end, { desc = "[B]lame [L]ine" })
		nnmap("<leader>dt", gs.diffthis, { desc = "[D]iff [T]his" })
		nnmap("<leader>td", gs.toggle_deleted, { desc = "[T]oggle [D]eleted" })

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})
