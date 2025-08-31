vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf
  if opts.buf and type(opts.buf) == "number" and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }
  local win = vim.api.nvim_open_win(buf, true, win_config)
  return { buf = buf, win = win }
end

local function toggle_terminal()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.fn.termopen(vim.o.shell)
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

local function run_docker_in_floating_term()
  local handle = io.popen("docker ps --format '{{.Names}}'")
  if not handle then
    vim.notify("Failed to list Docker containers", vim.log.levels.ERROR)
    return
  end
  local result = handle:read("*a")
  handle:close()

  local containers = vim.split(result, "\n", { trimempty = true })
  if #containers == 0 then
    vim.notify("No running Docker containers found", vim.log.levels.WARN)
    return
  end

  require("fzf-lua").fzf_exec(containers, {
    prompt = "Select Container> ",
    actions = {
      ["default"] = function(selected)
        if selected and #selected > 0 then
          local container_name = selected[1]
          if not vim.api.nvim_win_is_valid(state.floating.win) then
            state.floating = create_floating_window()
          end

          if vim.bo[state.floating.buf].buftype ~= "terminal" then
            local cmd = string.format("docker exec -it %s sh", vim.fn.shellescape(container_name))
            vim.fn.termopen(cmd)
          end
        end
      end,
    },
  })
end

local function run_npm_script()
  local package_json_path = vim.fn.findfile("package.json", vim.fn.getcwd() .. ";")
  if not package_json_path or package_json_path == "" then
    vim.notify("No package.json found in the current directory or its parents.", vim.log.levels.WARN)
    return
  end

  local file = io.open(package_json_path, "r")
  if not file then
    vim.notify("Failed to open package.json.", vim.log.levels.ERROR)
    return
  end
  local content = file:read("*a")
  file:close()

  local ok, json = pcall(vim.fn.json_decode, content)
  if not ok or not json or not json.scripts or vim.tbl_isempty(json.scripts) then
    vim.notify("No scripts found in package.json.", vim.log.levels.WARN)
    return
  end

  local scripts = {}
  table.insert(scripts, "install")
  for script_name, _ in pairs(json.scripts) do
    table.insert(scripts, script_name)
  end
  table.sort(scripts)

  require("fzf-lua").fzf_exec(scripts, {
    prompt = "Select npm script> ",
    actions = {
      ["default"] = function(selected)
        if selected and #selected > 0 then
          local script_name = selected[1]

          local run = script_name == "install" and "" or "run"

          if not vim.api.nvim_win_is_valid(state.floating.win) then
            state.floating = create_floating_window()
          end

          if vim.bo[state.floating.buf].buftype ~= "terminal" then
            local cmd = string.format("pnpm %s %s", run, vim.fn.shellescape(script_name))
            vim.fn.termopen(cmd)
          else
            -- If a terminal is already open, send the command to it
            local chan = vim.api.nvim_buf_get_var(state.floating.buf, "terminal_job_id")
            if chan and vim.api.nvim_get_chan_info(chan) then
              local cmd = string.format("pnpm %s %s\n", run, vim.fn.shellescape(script_name))
              vim.api.nvim_chan_send(chan, cmd)
            else
              vim.notify("Floating terminal is not running a shell.", vim.log.levels.ERROR)
            end
          end
        end
      end,
    },
  })
end

vim.api.nvim_create_user_command("NpmRun", run_npm_script, {})
vim.api.nvim_create_user_command("FloatTerminal", toggle_terminal, {})
vim.api.nvim_create_user_command("DockerExec", run_docker_in_floating_term, {})

vim.keymap.set({ "n", "t" }, "<leader>tn", run_npm_script)
vim.keymap.set({ "n", "t" }, "<leader>tt", toggle_terminal)
vim.keymap.set({ "n", "t" }, "<leader>td", run_docker_in_floating_term)
