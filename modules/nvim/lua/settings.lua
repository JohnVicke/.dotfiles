vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])

vim.o.winborder = "rounded"
vim.o.tabstop = 2
vim.o.wrap = false
vim.o.cursorcolumn = false
vim.o.ignorecase = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.signcolumn = "yes"
vim.o.pumblend = 0

vim.g.mapleader = " "

inoremap("kj", "<ESC>")
nnoremap("<leader>q", ":quit<CR>")
nnoremap("<leader>x", ":qa<CR>")
nnoremap("<leader>w", ":write<CR>")
nnoremap("<leader>y", '"+y')
vnoremap("<leader>y", '"+y')
nnoremap("<C-u>", "<C-u>zz")
nnoremap("<C-d>", "<C-d>zz")
vnoremap("<leader>64", "c<c-r>=system('base64 --decode', @\")<cr><esc>")

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
	end,
})

vim.cmd(":hi statusline guibg=NONE")
