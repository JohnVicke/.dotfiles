{pkgs, ...}:
pkgs.writeShellScriptBin "opencode" ''
  #!/bin/bash
  export PATH="${pkgs.bun}/bin:$PATH"

  # Install opencode if not present
  if [ ! -f "$HOME/.bun/bin/opencode" ]; then
    ${pkgs.bun}/bin/bun add -g opencode-ai@latest
  fi

  # Run opencode
  exec "$HOME/.bun/bin/opencode" "$@"
''
