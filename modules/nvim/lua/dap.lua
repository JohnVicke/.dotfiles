local dap = require("dap")
local dapui = require("dapui")

-- Setup DAP UI
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        { id = "repl", size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size = 0.25,
      position = "bottom",
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
})

-- Setup virtual text
require("nvim-dap-virtual-text").setup({
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false,
  virt_text_pos = "eol",
})

-- Auto open/close DAP UI
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- Signs for breakpoints
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

-- Highlight groups
vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f5a623" })
vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })
vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e4d3d" })
vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#5c6370" })

-- vscode-js-debug adapter configuration
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "js-debug",
    args = { "${port}" },
  },
}

dap.adapters["pwa-chrome"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "js-debug",
    args = { "${port}" },
  },
}

-- Alias for convenience
dap.adapters["node"] = dap.adapters["pwa-node"]
dap.adapters["chrome"] = dap.adapters["pwa-chrome"]

-- Helper function to get the root directory
local function get_root_dir()
  local root_patterns = { "package.json", "tsconfig.json", ".git" }
  local root = vim.fs.find(root_patterns, { upward = true, path = vim.fn.getcwd() })[1]
  if root then
    return vim.fn.fnamemodify(root, ":h")
  end
  return vim.fn.getcwd()
end

-- Shared JS/TS debug configurations
local js_debug_configs = {
  -- Node.js: Launch current file
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = get_root_dir,
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "**/node_modules/**" },
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
  },
  -- Node.js: Launch dist/index.js (for compiled TS projects)
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch dist/index.js",
    program = "${workspaceFolder}/dist/index.js",
    cwd = get_root_dir,
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "**/node_modules/**" },
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
  },
  -- Node.js: Attach to dynamic port (prompts for port)
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to port (prompt)",
    port = function()
      return tonumber(vim.fn.input("Port: ", "9229"))
    end,
    cwd = get_root_dir,
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "**/node_modules/**" },
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
  },
  -- Node.js: Attach to port 9229 (default)
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to port 9229",
    port = 9229,
    cwd = get_root_dir,
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "**/node_modules/**" },
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
  },
  -- Node.js: Attach to running process (pick from list)
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to Node process (pick)",
    processId = require("dap.utils").pick_process,
    cwd = get_root_dir,
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "**/node_modules/**" },
  },
  -- Node.js: Launch file with arguments
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file with arguments",
    program = "${file}",
    args = function()
      local args_string = vim.fn.input("Arguments: ")
      return vim.split(args_string, " +")
    end,
    cwd = get_root_dir,
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "**/node_modules/**" },
  },
  -- Bun: Launch current file
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file (Bun)",
    runtimeExecutable = "bun",
    runtimeArgs = { "run" },
    program = "${file}",
    cwd = get_root_dir,
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "**/node_modules/**" },
  },
  -- Bun: Attach (default port 6499)
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to Bun (port 6499)",
    port = 6499,
    cwd = get_root_dir,
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "**/node_modules/**" },
  },
  -- Chrome: Attach to browser
  {
    type = "pwa-chrome",
    request = "attach",
    name = "Attach to Chrome (port 9222)",
    port = 9222,
    webRoot = get_root_dir,
    sourceMaps = true,
  },
  -- Chrome: Launch URL
  {
    type = "pwa-chrome",
    request = "launch",
    name = "Launch Chrome against localhost",
    url = function()
      return vim.fn.input("URL: ", "http://localhost:3000")
    end,
    webRoot = get_root_dir,
    sourceMaps = true,
  },
}

-- Register configurations for all JS/TS filetypes
local js_based_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
  "typescript.tsx",
  "javascript.jsx",
}

for _, language in ipairs(js_based_languages) do
  dap.configurations[language] = js_debug_configs
end

-- Helper: Clear all breakpoints
local function dap_clear_breakpoints()
  dap.clear_breakpoints()
  vim.notify("All breakpoints cleared", vim.log.levels.INFO)
end

-- Helper: Full DAP reset (terminate + clear + close UI)
local function dap_reset()
  dap.terminate()
  dap.clear_breakpoints()
  dapui.close()
  vim.notify("DAP reset: session terminated, breakpoints cleared, UI closed", vim.log.levels.INFO)
end

-- Helper: Smart continue that handles missing filetype configs
local function dap_smart_continue()
  local filetype = vim.bo.filetype

  -- If we have a config for this filetype, just continue
  if dap.configurations[filetype] then
    dap.continue()
    return
  end

  -- Fallback: check if it looks like a JS/TS file by extension
  local filename = vim.fn.expand("%:t")
  local ext = vim.fn.expand("%:e")
  local js_extensions = { "ts", "tsx", "js", "jsx", "mjs", "cjs", "mts", "cts" }

  for _, js_ext in ipairs(js_extensions) do
    if ext == js_ext then
      -- Use typescript configurations as fallback
      vim.notify("Using TypeScript config for ." .. ext .. " file", vim.log.levels.INFO)
      dap.configurations[filetype] = js_debug_configs
      dap.continue()
      return
    end
  end

  -- Last resort: offer to use JS/TS configs anyway
  local choice = vim.fn.confirm(
    "No DAP config for filetype '" .. filetype .. "'. Use JavaScript/TypeScript configs?",
    "&Yes\n&No",
    1
  )
  if choice == 1 then
    dap.configurations[filetype] = js_debug_configs
    dap.continue()
  end
end

-- Keybindings
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Breakpoints
keymap("n", "<leader>db", dap.toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "Toggle breakpoint" }))
keymap("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Condition: "))
end, vim.tbl_extend("force", opts, { desc = "Set conditional breakpoint" }))
keymap("n", "<leader>dp", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
end, vim.tbl_extend("force", opts, { desc = "Set log point" }))

-- Clear/Reset
keymap("n", "<leader>dX", dap_clear_breakpoints, vim.tbl_extend("force", opts, { desc = "Clear all breakpoints" }))
keymap("n", "<leader>dR", dap_reset, vim.tbl_extend("force", opts, { desc = "Reset DAP (clear all + terminate + close)" }))

-- Execution control
keymap("n", "<leader>dc", dap_smart_continue, vim.tbl_extend("force", opts, { desc = "Continue / Start debugging" }))
keymap("n", "<leader>di", dap.step_into, vim.tbl_extend("force", opts, { desc = "Step into" }))
keymap("n", "<leader>do", dap.step_over, vim.tbl_extend("force", opts, { desc = "Step over" }))
keymap("n", "<leader>dO", dap.step_out, vim.tbl_extend("force", opts, { desc = "Step out" }))
keymap("n", "<leader>dl", dap.run_last, vim.tbl_extend("force", opts, { desc = "Run last configuration" }))
keymap("n", "<leader>dt", dap.terminate, vim.tbl_extend("force", opts, { desc = "Terminate debug session" }))
keymap("n", "<leader>dr", dap.repl.toggle, vim.tbl_extend("force", opts, { desc = "Toggle REPL" }))

-- DAP UI
keymap("n", "<leader>du", dapui.toggle, vim.tbl_extend("force", opts, { desc = "Toggle DAP UI" }))
keymap("n", "<leader>de", dapui.eval, vim.tbl_extend("force", opts, { desc = "Evaluate expression" }))
keymap("v", "<leader>de", dapui.eval, vim.tbl_extend("force", opts, { desc = "Evaluate selection" }))

-- Hover (show variable value)
keymap({ "n", "v" }, "<leader>dh", function()
  require("dap.ui.widgets").hover()
end, vim.tbl_extend("force", opts, { desc = "Hover (show value)" }))

-- Scopes (show all variables in scope)
keymap("n", "<leader>ds", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end, vim.tbl_extend("force", opts, { desc = "Show scopes" }))

-- User commands for convenience
vim.api.nvim_create_user_command("DapClear", dap_clear_breakpoints, { desc = "Clear all DAP breakpoints" })
vim.api.nvim_create_user_command("DapReset", dap_reset, { desc = "Reset DAP completely" })
