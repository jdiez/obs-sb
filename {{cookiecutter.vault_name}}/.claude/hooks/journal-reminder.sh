#!/bin/bash
# PostToolUse hook: remind Claude to update today's journal after note changes
# Fires on Write/Edit of files in notes/ directory

# Get the file path from the tool input
FILE_PATH="${CLAUDE_TOOL_INPUT_FILE_PATH:-}"

# Only trigger for files in the notes/ directory
if [[ "$FILE_PATH" == *"/notes/"* ]] || [[ "$FILE_PATH" == notes/* ]]; then
  TODAY=$(date +%Y-%m-%d)
  YEAR=$(date +%Y)
  MONTH=$(date +%m)
  JOURNAL_PATH="journal/${YEAR}/${MONTH}/${TODAY}.md"
  BASENAME=$(basename "$FILE_PATH" .md)

  echo "JOURNAL UPDATE REQUIRED: You just created/modified [[${BASENAME}]]. Append a brief entry to ${JOURNAL_PATH} summarizing what was added or changed. Create the journal file from template if it doesn't exist. Do this now before continuing."
fi
