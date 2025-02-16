return {
  "neovim/nvim-lspconfig",
  opts = {
    inlayHints = false,
    servers = {
      tsserver = {
        inlayHints = false,
        keys = {
          {
            "<leader>oi",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.organizeImports" },
                },
              })
            end,
            desc = "Organize imports",
          },
          {
            "<leader>cu",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.removeUnused.ts" },
                  diagnostics = {},
                },
              })
            end,
            desc = "Remove Unused Imports",
          },
        },
      },
    },
  },
}
