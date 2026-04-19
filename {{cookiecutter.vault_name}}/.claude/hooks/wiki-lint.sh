#!/bin/bash
# SessionStart hook: wiki structural lint
# Detects orphan notes and stale in-progress items.

VAULT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
NOTES_DIR="${VAULT_ROOT}/notes"

# Bail if notes/ is empty
[[ ! -d "$NOTES_DIR" ]] && exit 0

ORPHAN_COUNT=0
ORPHAN_LIST=""
STALE_COUNT=0
STALE_LIST=""

# --- Orphan detection ---
# A note is "orphan" if no other note in notes/ links to it via [[wikilink]].

for note in "$NOTES_DIR"/*.md; do
  [[ "$(basename "$note")" == "CLAUDE.md" ]] && continue
  [[ ! -f "$note" ]] && continue
  BASENAME="$(basename "$note" .md)"

  # Search for [[BASENAME]] or [[BASENAME| in all notes/ files (excluding self and CLAUDE.md)
  LINK_COUNT=$(grep -rl "\[\[${BASENAME}\]\]\|\[\[${BASENAME}|" "$NOTES_DIR" 2>/dev/null \
    | grep -v "$(basename "$note")" \
    | grep -v "CLAUDE.md" \
    | wc -l | tr -d ' ')

  if [[ "$LINK_COUNT" -eq 0 ]]; then
    ORPHAN_COUNT=$((ORPHAN_COUNT + 1))
    ORPHAN_LIST="${ORPHAN_LIST}  - ${BASENAME}\n"
  fi
done

# --- Stale in-progress detection ---
# Notes with status: in-progress and created date > 30 days ago

# Get threshold date (cross-platform)
if date -v-30d +%Y-%m-%d &>/dev/null 2>&1; then
  THRESHOLD=$(date -v-30d +%Y-%m-%d)
else
  THRESHOLD=$(date -d "30 days ago" +%Y-%m-%d)
fi

for note in "$NOTES_DIR"/*.md; do
  [[ "$(basename "$note")" == "CLAUDE.md" ]] && continue
  [[ ! -f "$note" ]] && continue
  BASENAME="$(basename "$note" .md)"

  STATUS=""
  CREATED=""
  IN_FM=false

  while IFS= read -r line; do
    if [[ "$line" == "---" ]]; then
      if $IN_FM; then break; fi
      IN_FM=true
      continue
    fi
    $IN_FM || continue
    [[ "$line" =~ ^status:[[:space:]]*(.+)$ ]] && STATUS="${BASH_REMATCH[1]}"
    [[ "$line" =~ ^created:[[:space:]]*([0-9]{4}-[0-9]{2}-[0-9]{2}) ]] && CREATED="${BASH_REMATCH[1]}"
  done < "$note"

  if [[ "$STATUS" == "in-progress" && -n "$CREATED" && "$CREATED" < "$THRESHOLD" ]]; then
    STALE_COUNT=$((STALE_COUNT + 1))
    STALE_LIST="${STALE_LIST}  - ${BASENAME} (created ${CREATED})\n"
  fi
done

# --- Output ---
if [[ "$ORPHAN_COUNT" -gt 0 ]] || [[ "$STALE_COUNT" -gt 0 ]]; then
  OUTPUT="WIKI LINT:"

  if [[ "$ORPHAN_COUNT" -gt 0 ]]; then
    OUTPUT="${OUTPUT}\n\nORPHAN NOTES (${ORPHAN_COUNT} with no inbound links from other notes):\n${ORPHAN_LIST}Consider adding cross-references from related notes, or archiving if no longer relevant."
  fi

  if [[ "$STALE_COUNT" -gt 0 ]]; then
    OUTPUT="${OUTPUT}\n\nSTALE IN-PROGRESS (${STALE_COUNT} notes in-progress for 30+ days):\n${STALE_LIST}Consider updating status to ready, archived, or adding new content."
  fi

  echo -e "$OUTPUT"
fi
