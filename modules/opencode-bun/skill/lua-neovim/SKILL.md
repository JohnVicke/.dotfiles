---
name: lua-neovim
description: Lua patterns for Neovim configuration
---

## API Namespaces

| Namespace | Purpose |
|-----------|---------|
| `vim.api.nvim_*` | Neovim API functions |
| `vim.fn.*` | Vimscript functions |
| `vim.opt` | Options (`:set` equivalent) |
| `vim.g` | Global variables |
| `vim.b` | Buffer variables |
| `vim.keymap` | Key mappings |
| `vim.lsp` | LSP client |
| `vim.treesitter` | Treesitter integration |

## Common Patterns

### Keymaps
```lua
-- Basic
vim.keymap.set('n', '<leader>f', ':find ', { desc = 'Find file' })

-- With callback
vim.keymap.set('n', '<leader>w', function()
  vim.cmd('write')
end, { silent = true })

-- Buffer-local
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })

-- Multiple modes
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
```

### Options
```lua
-- Global
vim.opt.number = true
vim.opt.tabstop = 2

-- Local (buffer/window aware)
vim.opt_local.spell = true

-- Append to list options
vim.opt.wildignore:append({ '*.o', '*.pyc' })

-- Check value
if vim.opt.filetype:get() == 'lua' then ... end
```

### Autocommands
```lua
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.ts', '*.tsx' },
  callback = function(args)
    vim.lsp.buf.format({ bufnr = args.buf })
  end,
  group = vim.api.nvim_create_augroup('FormatOnSave', { clear = true }),
})
```

### User Commands
```lua
vim.api.nvim_create_user_command('Format', function(opts)
  vim.lsp.buf.format({ async = opts.bang })
end, { bang = true, desc = 'Format buffer' })
```

### LSP Setup
```lua
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    
    -- Buffer-local keymaps
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  end,
})
```

## Error Handling

```lua
-- Protected call
local ok, result = pcall(function()
  return risky_operation()
end)

if not ok then
  vim.notify('Error: ' .. result, vim.log.levels.ERROR)
  return
end

-- For requires
local ok, module = pcall(require, 'some-plugin')
if not ok then return end
```

## Debugging

```lua
-- Print table contents
print(vim.inspect(some_table))

-- Notification
vim.notify('Debug message', vim.log.levels.INFO)

-- Check messages
:messages

-- Health check
:checkhealth

-- View loaded modules
:lua print(vim.inspect(package.loaded))
```

## Performance

```lua
-- Lazy require
local function get_telescope()
  return require('telescope.builtin')
end

-- vim.schedule for non-blocking
vim.schedule(function()
  expensive_operation()
end)

-- vim.defer_fn for delayed execution
vim.defer_fn(function()
  do_later()
end, 100) -- ms

-- Cache expensive computations
local cached_value = nil
local function get_value()
  if cached_value == nil then
    cached_value = expensive_computation()
  end
  return cached_value
end
```

## Common Gotchas

| Gotcha | Solution |
|--------|----------|
| `nil` in table removes key | Use `vim.NIL` for explicit null |
| String indexing is bytes | Use `vim.str_utfindex` for UTF-8 |
| `vim.fn` returns vim types | Wrap with `vim.fn.eval` if needed |
| Autocmd runs multiple times | Use `once = true` or proper groups |
| Options don't update immediately | Use `vim.schedule` after setting |

## Module Pattern

```lua
-- lua/my-plugin/init.lua
local M = {}

local defaults = {
  option = true,
}

M.setup = function(opts)
  M.config = vim.tbl_deep_extend('force', defaults, opts or {})
end

M.do_thing = function()
  if M.config.option then
    -- ...
  end
end

return M
```
