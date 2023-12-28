vim.opt.shortmess:append("c")
vim.opt.errorbells = false
vim.opt.smartcase = true
vim.opt.showmatch = true
vim.opt.showmode = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.hidden = true
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.list = false
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.laststatus = 2
vim.opt.scrolloff = 5
vim.opt.ttimeoutlen = 50
vim.opt.ignorecase = true
vim.opt.wildignorecase = true
vim.opt.smarttab = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = ""
vim.opt.guicursor = ""

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })
