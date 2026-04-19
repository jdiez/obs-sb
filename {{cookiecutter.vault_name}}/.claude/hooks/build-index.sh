#!/bin/bash
# SessionStart hook: rebuild index.md from notes/ YAML frontmatter
# Produces a category-organized catalog with one-line summaries for LLM navigation.

VAULT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INDEX_FILE="${VAULT_ROOT}/index.md"
NOTES_DIR="${VAULT_ROOT}/notes"

# Bail if notes/ doesn't exist
if [[ ! -d "$NOTES_DIR" ]]; then
  exit 0
fi

# Count notes (excluding CLAUDE.md)
NOTE_COUNT=0
for f in "$NOTES_DIR"/*.md; do
  [[ "$(basename "$f")" == "CLAUDE.md" ]] && continue
  [[ -f "$f" ]] && NOTE_COUNT=$((NOTE_COUNT + 1))
done

if [[ "$NOTE_COUNT" -eq 0 ]]; then
  exit 0
fi

# Temporary directory for category grouping
TMPDIR_IDX=$(mktemp -d)
trap "rm -rf $TMPDIR_IDX" EXIT

# Parse each note's YAML frontmatter
for note in "$NOTES_DIR"/*.md; do
  BASENAME="$(basename "$note" .md)"
  [[ "$BASENAME" == "CLAUDE" ]] && continue
  [[ ! -f "$note" ]] && continue

  CATEGORY=""
  SUMMARY=""
  STATUS=""
  IN_FM=false
  IN_CATEGORIES=false

  while IFS= read -r line; do
    # Frontmatter delimiters
    if [[ "$line" == "---" ]]; then
      if $IN_FM; then break; fi
      IN_FM=true
      continue
    fi
    $IN_FM || continue

    # Detect section starts
    if [[ "$line" =~ ^categories: ]]; then
      IN_CATEGORIES=true
      continue
    fi

    # End of array: any non-indented, non-dash line
    if $IN_CATEGORIES && [[ "$line" =~ ^[a-zA-Z] ]]; then
      IN_CATEGORIES=false
    fi

    # Capture first category value
    if $IN_CATEGORIES && [[ -z "$CATEGORY" ]]; then
      if [[ "$line" =~ \[\[([^\]]+)\]\] ]]; then
        CATEGORY="${BASH_REMATCH[1]}"
      fi
    fi

    # Capture summary (strip quotes)
    if [[ "$line" =~ ^summary:[[:space:]]*(.+)$ ]]; then
      SUMMARY="${BASH_REMATCH[1]}"
      SUMMARY="${SUMMARY#\"}"
      SUMMARY="${SUMMARY%\"}"
    fi

    # Capture status
    if [[ "$line" =~ ^status:[[:space:]]*(.+)$ ]]; then
      STATUS="${BASH_REMATCH[1]}"
    fi
  done < "$note"

  [[ -z "$CATEGORY" ]] && CATEGORY="Uncategorized"
  [[ -z "$STATUS" ]] && STATUS="?"

  # Build entry line
  if [[ -n "$SUMMARY" ]]; then
    ENTRY="- [[${BASENAME}]] — ${SUMMARY} \`${STATUS}\`"
  else
    ENTRY="- [[${BASENAME}]] \`${STATUS}\`"
  fi

  # Append to category file (replace spaces with underscores for safe filenames)
  SAFE_CAT=$(echo "$CATEGORY" | tr '/ ' '-_')
  echo "$ENTRY" >> "${TMPDIR_IDX}/${SAFE_CAT}.cat"
done

# Build index.md
{
  echo "---"
  echo "type: system"
  echo "---"
  echo ""
  echo "# Vault Index"
  echo ""
  echo "*Auto-generated at session start. ${NOTE_COUNT} notes cataloged.*"
  echo ""

  # Sort categories alphabetically
  CAT_COUNT=0
  while IFS= read -r catfile; do
    [[ -z "$catfile" ]] && continue
    SAFE_NAME="$(basename "$catfile" .cat)"
    # Convert underscores back to spaces for display
    CATNAME="${SAFE_NAME//_/ }"
    COUNT=$(wc -l < "$catfile" | tr -d ' ')
    CAT_COUNT=$((CAT_COUNT + 1))
    echo "## ${CATNAME} (${COUNT})"
    echo ""
    sort "$catfile"
    echo ""
  done < <(find "${TMPDIR_IDX}" -name "*.cat" -print | sort)
} > "$INDEX_FILE"

echo "INDEX: Rebuilt index.md — ${NOTE_COUNT} notes across ${CAT_COUNT} categories."
