---
name: shell-patterns
description: Shell scripting patterns and safety practices
---

## Script Header

```bash
#!/usr/bin/env bash
set -euo pipefail

# -e: Exit on error
# -u: Error on undefined variable
# -o pipefail: Pipe fails if any command fails
```

## Variable Safety

```bash
# Always quote variables
echo "$variable"           # Good
echo $variable             # Bad - word splitting

# Default values
name="${1:-default}"       # Use default if unset/empty
name="${1:?'required'}"    # Error if unset/empty

# Check if set
if [[ -n "${var:-}" ]]; then
  echo "var is set"
fi
```

## Conditionals

```bash
# Use [[ ]] over [ ]
if [[ "$str" == "value" ]]; then
  # String comparison
fi

if [[ -f "$file" ]]; then
  # File exists and is regular file
fi

if [[ -d "$dir" ]]; then
  # Directory exists
fi

if [[ -z "$var" ]]; then
  # Variable is empty
fi

# Command exists
if command -v git &>/dev/null; then
  echo "git is installed"
fi
```

## String Manipulation

```bash
file="/path/to/file.tar.gz"

# Basename (remove path)
echo "${file##*/}"         # file.tar.gz

# Directory (remove filename)
echo "${file%/*}"          # /path/to

# Remove extension
echo "${file%.*}"          # /path/to/file.tar

# Remove all extensions
echo "${file%%.*}"         # /path/to/file

# Replace
echo "${str/old/new}"      # First occurrence
echo "${str//old/new}"     # All occurrences

# Substring
echo "${str:0:5}"          # First 5 chars
echo "${str: -5}"          # Last 5 chars (note space)
```

## Arrays

```bash
# Declaration
arr=("one" "two" "three")

# Access
echo "${arr[0]}"           # First element
echo "${arr[@]}"           # All elements
echo "${#arr[@]}"          # Length

# Iterate
for item in "${arr[@]}"; do
  echo "$item"
done

# Add element
arr+=("four")
```

## Functions

```bash
function do_thing() {
  local input="$1"         # Local variable
  local output
  
  if [[ -z "$input" ]]; then
    echo "Error: input required" >&2
    return 1
  fi
  
  output="processed: $input"
  echo "$output"           # Return via stdout
}

# Capture return value
result=$(do_thing "arg") || exit 1
```

## Error Handling

```bash
# Trap on exit
cleanup() {
  rm -f "$temp_file"
}
trap cleanup EXIT

# Check command success
if ! git pull; then
  echo "git pull failed" >&2
  exit 1
fi

# Or with ||
git pull || { echo "failed" >&2; exit 1; }
```

## Common Patterns

### Read File Line by Line
```bash
while IFS= read -r line; do
  echo "$line"
done < "$file"
```

### Process Arguments
```bash
while [[ $# -gt 0 ]]; do
  case "$1" in
    -v|--verbose) verbose=1; shift ;;
    -f|--file) file="$2"; shift 2 ;;
    *) args+=("$1"); shift ;;
  esac
done
```

### Safe Temp Files
```bash
temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT
```

### Parallel Execution
```bash
# With xargs
find . -name "*.txt" | xargs -P 4 -I {} process {}

# With &
for item in "${items[@]}"; do
  process "$item" &
done
wait
```

## Pipelines

```bash
# Pipe stderr too
command |& other_command

# Save and continue
command | tee output.log | next_command

# Process substitution
diff <(sort file1) <(sort file2)
```

## Debugging

```bash
# Trace execution
set -x                     # Enable
set +x                     # Disable

# Syntax check only
bash -n script.sh

# Static analysis
shellcheck script.sh
```

## Anti-patterns

| Bad | Good |
|-----|------|
| `cd dir && cmd` | `cmd --dir=dir` or subshell |
| `cat file \| grep` | `grep pattern file` |
| `for f in $(ls)` | `for f in *` |
| `[ $var = "x" ]` | `[[ "$var" == "x" ]]` |
| `echo $var` | `echo "$var"` |
