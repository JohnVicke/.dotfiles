# Neovim DAP (Debug Adapter Protocol) Setup

Debug TypeScript, JavaScript, and Node.js applications directly in Neovim.

## Keybindings

### Breakpoints
| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Set conditional breakpoint |
| `<leader>dp` | Set log point (prints message without stopping) |
| `<leader>dX` | Clear all breakpoints |

### Execution Control
| Key | Action |
|-----|--------|
| `<leader>dc` | Continue / Start debugging |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>dl` | Run last configuration |
| `<leader>dt` | Terminate session |

### UI & Inspection
| Key | Action |
|-----|--------|
| `<leader>du` | Toggle DAP UI |
| `<leader>dr` | Toggle REPL |
| `<leader>de` | Evaluate expression (works in visual mode too) |
| `<leader>dh` | Hover - show value under cursor |
| `<leader>ds` | Show all variables in scope |
| `<leader>dR` | Full reset (terminate + clear + close UI) |

### Commands
- `:DapClear` - Clear all breakpoints
- `:DapReset` - Full reset

---

## Debug Configurations

When you press `<leader>dc`, you'll see these options:

| Configuration | Use Case |
|---------------|----------|
| Launch file | Debug current file with Node.js |
| Launch dist/index.js | Debug compiled TypeScript project |
| Attach to port (prompt) | Attach to any port (asks for port number) |
| Attach to port 9229 | Attach to default Node.js inspect port |
| Attach to Node process (pick) | Pick from running Node processes |
| Launch file with arguments | Debug with CLI arguments |
| Launch file (Bun) | Debug current file with Bun |
| Attach to Bun (port 6499) | Attach to Bun's default debug port |
| Attach to Chrome (port 9222) | Debug frontend in Chrome |
| Launch Chrome against localhost | Opens Chrome and attaches |

---

## Debugging Node.js

### Method 1: Attach to Running Process

Start your app with the `--inspect` flag:

```bash
# Default port 9229
node --inspect dist/index.js

# Custom port (useful when 9229 is taken)
node --inspect=9230 dist/index.js

# Random available port (check output for port number)
node --inspect=0 dist/index.js

# Break on first line (pauses immediately)
node --inspect-brk dist/index.js
```

Then in Neovim:
1. Open a source file and set breakpoints with `<leader>db`
2. Press `<leader>dc`
3. Select "Attach to port 9229" or "Attach to port (prompt)"

### Method 2: Launch Directly

1. Open the file you want to debug
2. Set breakpoints with `<leader>db`
3. Press `<leader>dc`
4. Select "Launch file"

---

## Debugging Bun

### Attach to Running Process

```bash
# Default port 6499
bun --inspect src/index.ts

# Break on first line
bun --inspect-brk src/index.ts

# Custom port
bun --inspect=6500 src/index.ts
```

Then attach with "Attach to Bun (port 6499)" or "Attach to port (prompt)".

### Launch Directly

1. Open your TypeScript file
2. `<leader>dc` → "Launch file (Bun)"

---

## Debugging in Chrome (Frontend)

### Step 1: Start Chrome with Remote Debugging

```bash
# Linux
google-chrome --remote-debugging-port=9222

# macOS
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222

# Or create an alias in your shell config:
alias chrome-debug='google-chrome --remote-debugging-port=9222'
```

### Step 2: Navigate to Your App

Open your app in Chrome (e.g., `http://localhost:3000`)

### Step 3: Attach from Neovim

1. Open your source file
2. Set breakpoints with `<leader>db`
3. `<leader>dc` → "Attach to Chrome (port 9222)"

---

## Example package.json Scripts

Add these to your `package.json` for convenient debugging:

```json
{
  "scripts": {
    "dev": "node --watch dist/index.js",
    
    "dev:debug": "node --inspect --enable-source-maps dist/index.js",
    
    "dev:debug:brk": "node --inspect-brk --enable-source-maps dist/index.js",
    
    "dev:debug:watch": "node --inspect --enable-source-maps --watch dist/index.js",
    
    "dev:debug:port": "node --inspect=${DEBUG_PORT:-9229} --enable-source-maps dist/index.js"
  }
}
```

### With environment variables (dotenv)

```json
{
  "scripts": {
    "with-env": "dotenv -e .env --",
    "dev:debug": "pnpm with-env node --inspect --enable-source-maps dist/index.js"
  }
}
```

### With pino-pretty (for readable logs)

```json
{
  "scripts": {
    "dev:debug": "node --inspect --enable-source-maps dist/index.js | pino-pretty"
  }
}
```

### Using a custom port

```bash
# Use port 9230 instead of default 9229
DEBUG_PORT=9230 pnpm dev:debug:port
```

---

## TypeScript Source Maps

For debugging TypeScript, ensure source maps are enabled in `tsconfig.json`:

```json
{
  "compilerOptions": {
    "sourceMap": true,
    "inlineSources": true
  }
}
```

And use `--enable-source-maps` when running Node:

```bash
node --enable-source-maps --inspect dist/index.js
```

---

## Tips & Tricks

### 1. Log Points (Non-Breaking Breakpoints)

Use `<leader>dp` to set a log point. It prints a message when hit but doesn't pause execution. Useful for debugging without stopping the app.

```
# Example log message (use {expression} for interpolation):
User logged in: {user.email}
```

### 2. Conditional Breakpoints

Use `<leader>dB` to set breakpoints that only trigger when a condition is true:

```
user.role === 'admin'
count > 100
```

### 3. Evaluate Expressions

- In normal mode: `<leader>de` then type an expression
- In visual mode: Select code, then `<leader>de` to evaluate it

### 4. Quick Variable Inspection

Hover over any variable and press `<leader>dh` to see its value.

### 5. Watch Expressions

In the DAP UI sidebar, the "watches" panel lets you add expressions to monitor continuously.

### 6. Restart Debugging Quickly

Use `<leader>dl` to re-run the last debug configuration without selecting again.

### 7. Clean Slate

If things get weird, use `<leader>dR` or `:DapReset` to clear everything and start fresh.

---

## Troubleshooting

### "No configuration found for ``"

The file's filetype wasn't detected. This can happen with:
- Scratch buffers
- Files without extensions
- Unusual file extensions

**Fix**: The config now auto-detects by extension. If it still fails, you'll be prompted to use JS/TS configs.

### Breakpoints Not Hitting

1. **Check source maps**: Ensure `sourceMap: true` in tsconfig.json
2. **Check paths**: The source file path must match what's in the source map
3. **Rebuild**: Make sure you've compiled after adding breakpoints

### Can't Attach to Process

1. **Check the port**: Is the process running with `--inspect`?
2. **Check port conflicts**: Try a different port with `--inspect=9230`
3. **Check firewall**: Ensure localhost:PORT is accessible

### UI Not Opening

The DAP UI should open automatically. If not:
- Press `<leader>du` to toggle it manually
- Check `:messages` for errors

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                      Neovim                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │
│  │   nvim-dap  │  │ nvim-dap-ui │  │ virtual-text    │  │
│  │   (client)  │  │   (UI)      │  │ (inline values) │  │
│  └──────┬──────┘  └─────────────┘  └─────────────────┘  │
└─────────┼───────────────────────────────────────────────┘
          │ DAP Protocol
          ▼
┌─────────────────────┐
│   vscode-js-debug   │  ← Debug adapter (from nixpkgs)
│   (js-debug)        │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│  Node.js / Bun /    │  ← Your application
│  Chrome DevTools    │
└─────────────────────┘
```
