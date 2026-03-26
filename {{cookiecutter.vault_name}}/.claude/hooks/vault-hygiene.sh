#!/bin/bash
# Vault Hygiene Check — runs on Claude session start
# Detects unexpected files/folders at the vault root and warns.

VAULT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# Allowed root-level entries (dirs and files)
ALLOWED=(
  ".claude"
  ".claudeignore"
  ".git"
  ".gitignore"
  ".obsidian"
  ".env"
  "CLAUDE.md"
  "README.md"
  "categories"
  "inbox"
  "journal"
  "notes"
  "subjects"
  "system"
)

unexpected=()

for item in "$VAULT_ROOT"/*  "$VAULT_ROOT"/.*; do
  basename="$(basename "$item")"

  # Skip . and ..
  [[ "$basename" == "." || "$basename" == ".." ]] && continue

  # Check against allowed list
  found=false
  for allowed in "${ALLOWED[@]}"; do
    if [[ "$basename" == "$allowed" ]]; then
      found=true
      break
    fi
  done

  if [[ "$found" == "false" ]]; then
    if [[ -d "$item" ]]; then
      unexpected+=("$basename/")
    else
      unexpected+=("$basename")
    fi
  fi
done

if [[ ${#unexpected[@]} -gt 0 ]]; then
  echo "VAULT HYGIENE: ${#unexpected[@]} unexpected item(s) found at vault root:"
  for item in "${unexpected[@]}"; do
    echo "  - $item"
  done
  echo ""
  echo "These are not part of the vault structure. Decide what to do with them (delete, move to notes/, move to inbox/, or add to allowed list)."
else
  echo "Vault root is clean — no unexpected files or folders."
fi
