# List all available commands
default:
    @just --list

# Add a new npm package via node2nix
add-node package:
    jq '. += ["{{package}}"] | unique' node_packages/package.json > node_packages/package.json.tmp && mv node_packages/package.json.tmp node_packages/package.json
    cd node_packages && node2nix -i package.json
    sed -i '/node_packages\."opencode-ai"/a\      node_packages."{{package}}"' modules/home.nix
    nix fmt .
    @echo "Added {{package}}. Run 'just rebuild' to apply changes."

# Remove an npm package
remove-node package:
    jq 'del(.[] | select(. == "{{package}}"))' node_packages/package.json > node_packages/package.json.tmp && mv node_packages/package.json.tmp node_packages/package.json
    cd node_packages && node2nix -i package.json
    sed -i '/node_packages\."{{package}}"/d' modules/home.nix
    nix fmt .
    @echo "Removed {{package}}. Run 'just rebuild' to apply changes."

# Rebuild and switch to new home-manager configuration
rebuild:
    home-manager switch --flake .

# Roll back to previous home-manager generation
rollback:
    home-manager switch --rollback

# Build without switching (test configuration)
build:
    home-manager build --flake .

# Format all nix files
fmt:
    nix fmt .

# Check flake and show configuration
check:
    nix flake check
    nix flake show

# Update flake inputs
update:
    nix flake update

# Update specific input
update-input input:
    nix flake lock --update-input {{input}}

# Clean old generations (keeps last N)
clean-generations n="5":
    home-manager expire-generations "-{{n}} days"
    nix-collect-garbage

# Show current generation
show-generation:
    home-manager generations | head -n 5
