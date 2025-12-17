vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
vim.g.db_ui_execute_on_save = 0
vim.g.omni_sql_no_default_maps = 1

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sql', 'mysql', 'plsql' },
  callback = function(args)
    vim.bo[args.buf].omnifunc = 'db#completion'
  end,
})

nnoremap("<leader>D", "<Cmd>DBUIToggle<CR>")
nnoremap("<leader>r", "<Cmd>DBUIRunLastStatement<CR>")
