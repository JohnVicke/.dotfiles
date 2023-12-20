local builtin = require("telescope.builtin")

return {
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    keys = {
      {
        "<leader>gd",
        function()
          builtin.lsp_definitions()
        end,
        desc = "[G]oto [D]efinitions",
      },
      {
        "<leader>of",
        function()
          builtin.oldfiles()
        end,
        desc = "[O]ld [F]iles",
      },
      {
        "<leader>ff",
        function()
          builtin.find_files()
        end,
        desc = "[F]ind [F]iles",
      },
      {
        "<leader>fr",
        function()
          builtin.lsp_references()
        end,
        desc = "[F]ind [R]eferences",
      },
      {
        "<leader>fs",
        function()
          builtin.lsp_document_symbols()
        end,
        desc = "[F]ind [S]ymbols",
      },
      {
        "<leader>cf",
        function()
          builtin.current_buffer_fuzzy_find()
        end,
        desc = "[C]urrent Fuzzy [F]ind",
      },
    },
  },
}
