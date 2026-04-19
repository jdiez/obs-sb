#!/bin/bash
# SessionStart hook: check if previous day's journal has empty Reflections/Key Decisions
# Prompts Claude to auto-generate substantive reflections from the day's work log.

VAULT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# Get yesterday's date (cross-platform)
if date -v-1d +%s &>/dev/null; then
  # macOS date
  YESTERDAY=$(date -v-1d +%Y-%m-%d)
  YESTERDAY_YEAR=$(date -v-1d +%Y)
  YESTERDAY_MONTH=$(date -v-1d +%m)
else
  # GNU date
  YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
  YESTERDAY_YEAR=$(date -d "yesterday" +%Y)
  YESTERDAY_MONTH=$(date -d "yesterday" +%m)
fi

JOURNAL_FILE="${VAULT_ROOT}/journal/${YESTERDAY_YEAR}/${YESTERDAY_MONTH}/${YESTERDAY}.md"

# Only proceed if yesterday's journal exists
if [[ ! -f "$JOURNAL_FILE" ]]; then
  exit 0
fi

# Check if the file has a "What I Did Today" section with content
if ! grep -q "^## What I Did Today" "$JOURNAL_FILE"; then
  exit 0
fi

# Check if Reflections section is empty or missing
# "Empty" means either: no ## Reflections section, or ## Reflections followed by
# only blank lines / placeholder dashes before the next ## heading or EOF
NEEDS_REFLECTIONS=false
NEEDS_DECISIONS=false

if ! grep -q "^## Reflections" "$JOURNAL_FILE"; then
  NEEDS_REFLECTIONS=true
elif grep -q "^## Reflections" "$JOURNAL_FILE"; then
  # Extract content between ## Reflections and the next ## heading
  REFLECTIONS_CONTENT=$(sed -n '/^## Reflections/,/^## /{/^## Reflections/d;/^## /d;p;}' "$JOURNAL_FILE" | sed '/^$/d' | sed '/^-$/d' | sed '/^- *$/d')
  if [[ -z "$REFLECTIONS_CONTENT" ]]; then
    NEEDS_REFLECTIONS=true
  fi
fi

if ! grep -q "^## Key Decisions" "$JOURNAL_FILE"; then
  NEEDS_DECISIONS=true
elif grep -q "^## Key Decisions" "$JOURNAL_FILE"; then
  DECISIONS_CONTENT=$(sed -n '/^## Key Decisions/,/^## /{/^## Key Decisions/d;/^## /d;p;}' "$JOURNAL_FILE" | sed '/^$/d' | sed '/^-$/d' | sed '/^- *$/d')
  if [[ -z "$DECISIONS_CONTENT" ]]; then
    NEEDS_DECISIONS=true
  fi
fi

if [[ "$NEEDS_REFLECTIONS" == "true" ]] || [[ "$NEEDS_DECISIONS" == "true" ]]; then
  SECTIONS=""
  if [[ "$NEEDS_REFLECTIONS" == "true" ]] && [[ "$NEEDS_DECISIONS" == "true" ]]; then
    SECTIONS="Reflections and Key Decisions sections"
  elif [[ "$NEEDS_REFLECTIONS" == "true" ]]; then
    SECTIONS="Reflections section"
  else
    SECTIONS="Key Decisions section"
  fi

  echo "JOURNAL REFLECTIONS: Yesterday's journal (${YESTERDAY}) has empty ${SECTIONS}. Read the 'What I Did Today' section from journal/${YESTERDAY_YEAR}/${YESTERDAY_MONTH}/${YESTERDAY}.md and generate substantive content: Reflections should cover cross-cutting insights, key learnings, connections between work items, and strategic implications — use ### subheadings for each reflection theme. Key Decisions should list non-trivial decisions made and the reasoning behind them. Do not ask — just generate them."
fi
