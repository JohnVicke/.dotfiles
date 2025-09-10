-- Git blame settings
vim.g.gitblame_display_virtual_text = 0
vim.g.gitblame_message_when_not_committed = ""
vim.g.gitblame_message_template = "<author>, <date>"
vim.g.gitblame_date_format = "%r"

local Util = require("lazyvim.util")

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "f-person/git-blame.nvim" },
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on starter/dashboard page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    local git_blame = require("gitblame")
    local icons = require("lazyvim.config").icons

    -- restore laststatus after lazy loading
    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },

        lualine_c = {
          Util.lualine.root_dir(),
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { Util.lualine.pretty_path() },
        },
        lualine_x = {
          { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
          {
            "diff",
            symbols = { added = icons.git.added, modified = icons.git.modified, removed = icons.git.removed },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
              end
            end,
          },
        },
        lualine_y = {},
        lualine_z = {},
      },
    }
  end,
}
