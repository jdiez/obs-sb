#!/bin/bash
# SessionEnd hook: warn if there are uncommitted changes in the vault

VAULT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$VAULT_ROOT" || exit 0

# Check for any uncommitted changes (staged, unstaged, or untracked)
STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
UNSTAGED=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

TOTAL=$((STAGED + UNSTAGED + UNTRACKED))

if [[ "$TOTAL" -gt 0 ]]; then
  echo "⚠️  UNCOMMITTED CHANGES: ${TOTAL} file(s) not committed (${STAGED} staged, ${UNSTAGED} modified, ${UNTRACKED} untracked). Consider committing before ending the session."
fi
