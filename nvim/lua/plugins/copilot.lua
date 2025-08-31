return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "InsertEnter",
  opts = {
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<C-l>",
        next = "<M-]>",
        prev = "<M-[>",
      },
    },
  },
}
