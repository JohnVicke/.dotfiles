{pkgs, ...}:
pkgs.writeShellScriptBin "opencode" ''
  #!/bin/bash
  export PATH="${pkgs.bun}/bin:$PATH"

  if [ ! -f "$HOME/.bun/bin/opencode" ]; then
    ${pkgs.bun}/bin/bun add -g opencode-ai@latest
  fi

  exec "$HOME/.bun/bin/opencode" "$@"
''
