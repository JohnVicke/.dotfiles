# AGENTS.md - Development Guidelines for Agentic Coding Tools

This document provides guidelines for agentic coding tools working in this dotfiles repository. It covers build/lint/test commands, code style guidelines, and development conventions.

## Build, Lint, and Test Commands

### Primary Development Commands
- **Build and test configuration**: `just build` - Builds the Home Manager configuration without switching
- **Apply configuration**: `just rebuild` - Builds and switches to the new Home Manager configuration
- **Format Nix files**: `just fmt` - Formats all Nix files using alejandra (Nix formatter)
- **Check configuration**: `just check` - Validates flake and shows configuration
- **Update dependencies**: `just update` - Updates all flake inputs
- **Update specific input**: `just update-input <input-name>` - Updates a specific flake input

### Development Shell
Enter the development environment with:
```bash
nix develop
```
This provides access to `alejandra`, `home-manager`, `just`, and `node2nix`.

### Linting and Formatting
- **Nix formatting**: `nix fmt .` or `just fmt` - Formats all Nix files
- **Nix checking**: `nix flake check` - Validates the flake configuration
- **No explicit test framework** - This is a configuration repository, so testing primarily involves validating that the Home Manager configuration builds successfully

### Adding/Removing Node Packages
- **Add package**: `just add-node <package-name>` - Adds an npm package via node2nix
- **Remove package**: `just remove-node <package-name>` - Removes an npm package

## Code Style Guidelines

### Nix Code Style
- **Formatter**: Use `alejandra` (automatically applied via `just fmt`)
- **Naming conventions**:
  - Use `camelCase` for variable names and function arguments
  - Use `snake_case` for configuration keys when following external conventions
  - Package names follow Nix naming conventions
- **Structure**:
  - Group related configurations together
  - Use `let ... in` blocks for complex expressions
  - Prefer functional programming patterns
  - Use `with pkgs;` sparingly, only when it improves readability
- **Imports**: Keep imports organized and grouped logically
- **Documentation**: Use comments sparingly, prefer self-documenting code

Example Nix style:
```nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  scriptFiles = builtins.attrNames (builtins.readDir ./scripts);
  scripts = map (name: pkgs.writeShellScriptBin name (builtins.readDir ./scripts/${name})) scriptFiles;
in {
  home.packages = [ /* packages */ ] ++ scripts;
}
```

### Lua Code Style (Neovim Configuration)
- **Formatting**: 2-space indentation (configured in settings.lua)
- **Naming conventions**:
  - Use `snake_case` for variables and functions
  - Use `PascalCase` for module names and constructors
  - Local variables preferred over global
- **Structure**:
  - Use local functions for encapsulation
  - Prefer functional programming where appropriate
  - Group related functionality in modules
- **Error handling**: Use `pcall` for potentially failing operations
- **Types**: No explicit typing (Lua is dynamically typed)
- **Imports**: Use `local` declarations for required modules

Example Lua style:
```lua
local function select_preferred_client(bufnr, method)
  local filetype = vim.bo[bufnr].filetype
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  -- Implementation
end

local function smart_format(bufnr)
  vim.lsp.buf.format({
    bufnr = bufnr,
    async = true,
    filter = function(client)
      return select_preferred_client(bufnr, "textDocument/formatting") ~= nil
    end,
  })
end
```

### Shell Script Style
- **Shebang**: Use `#!/usr/bin/env bash` for portability
- **Error handling**: Use `set -euo pipefail` when appropriate, but check usage in existing scripts
- **Variable naming**: Use `snake_case` for variables
- **Quotes**: Always quote variables to prevent word splitting
- **Testing**: Use `[[ ]]` for conditional expressions (bash-specific)
- **Comments**: Brief, actionable comments when needed

Example shell script style:
```bash
#!/usr/bin/env bash

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s "$selected_name" -c "$selected"
  exit 0
fi
```

### General Guidelines
- **Comments**: Use comments sparingly - prefer self-documenting code
- **No trailing whitespace**: Automatic handling via editor config
- **Line length**: No strict limit, but keep lines readable
- **Empty lines**: Use strategically to separate logical blocks

## Git Conventions

### Commit Messages
- **Style**: Concise, imperative mood (e.g., "Add dark mode toggle", not "Added dark mode toggle")
- **Focus on "why"**: Explain the purpose rather than just "what" changed
- **Length**: Keep under 72 characters for the first line
- **Aliases**: Use provided git aliases for common operations:
  - `git fu`: Fix up last commit and force push
  - `git oops`: Amend commit without changing message
  - `git wip`: Create WIP commit and push (skips hooks)

### Branching Strategy
- **Default branch**: `main`
- **Stacked PRs**: Use git aliases for stacked pull request workflow:
  - `git stack <branch-name>`: Create new branch stacked on current
  - `git update-from-parent`: Rebase current branch onto its parent
  - `git parent-merged`: Handle parent branch merge
  - `git show-stack`: Display branch stack

### Configuration
- **User**: Viktor Malmedal <38523983+johnvicke@users.noreply.github.com>
- **Default push**: `simple` with `autoSetupRemote`
- **Pull strategy**: Fast-forward only (`ff = only`)
- **Work-specific config**: Separate config for `~/dev/anyfin/` directory

## Development Workflow

1. **Make changes** to configuration files
2. **Format code**: Run `just fmt` to format Nix files
3. **Test changes**: Run `just build` to validate configuration
4. **Apply changes**: Run `just rebuild` to apply configuration
5. **Commit**: Use descriptive commit messages following conventions above

## Special Considerations

- **No explicit testing framework**: Validation happens through successful Home Manager builds
- **No Cursor rules**: No `.cursorrules` file found
- **No Copilot instructions**: No `.github/copilot-instructions.md` file found
- **Mixed languages**: Repository contains Nix, Lua, and shell scripts - follow language-specific guidelines above
- **Configuration management**: Changes affect system configuration - test thoroughly before applying

## Tool Integration

- **LSP**: Lua LSP configured with custom globals (`vim`, `nmap`, `nnoremap`)
- **Formatting**: alejandra for Nix, no explicit Lua formatter configured
- **Git integration**: diff-so-fancy, bat for enhanced git experience
- **Search tools**: ripgrep, fd available in development shell

Remember: This is a personal dotfiles repository. Changes here affect the user's development environment, so exercise caution and test thoroughly.