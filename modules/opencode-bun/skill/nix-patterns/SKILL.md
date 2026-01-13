---
name: nix-patterns
description: Nix and Home Manager idioms for dotfiles configuration
---

## Formatting

- Use `alejandra` formatter (`just fmt` or `nix fmt .`)
- camelCase for variables and function arguments
- snake_case for config keys following external conventions

## Structure

```nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  myVar = "value";
  scripts = map (name: pkgs.writeShellScriptBin name ...) scriptFiles;
in {
  home.packages = [ pkgs.foo ] ++ scripts;
}
```

- Group related configurations together
- Use `let ... in` for complex expressions
- Prefer functional patterns
- Use `with pkgs;` sparingly, only when improves readability

## Commands

| Command | Purpose |
|---------|---------|
| `just build` | Validate config without switching |
| `just rebuild` | Apply configuration |
| `just fmt` | Format all Nix files |
| `just check` | Validate flake |
| `just update` | Update flake inputs |

## Common Patterns

### Script from file
```nix
pkgs.writeShellScriptBin "my-script" (builtins.readFile ./scripts/my-script.sh)
```

### Optional config
```nix
lib.mkIf config.programs.foo.enable {
  home.packages = [ pkgs.bar ];
}
```

### Overlay
```nix
nixpkgs.overlays = [
  (final: prev: {
    myPkg = prev.myPkg.override { ... };
  })
];
```
