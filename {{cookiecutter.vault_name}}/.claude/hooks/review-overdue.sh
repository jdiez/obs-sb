#!/bin/bash
# SessionStart hook: check if weekly or monthly reviews are overdue
# Self-healing — catches missed Sundays on Monday/Tuesday/etc.

VAULT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
YEAR=$(date +%Y)

# --- Weekly review check ---
# Find the ISO week number of the most recent completed week (last Sunday).
# On macOS, `date -v-sundayj` gives last Sunday; on Linux, `date -d "last sunday"`.
if date -v-1d +%s &>/dev/null; then
  # macOS date
  LAST_SUNDAY=$(date -v-sundayj +%Y-%m-%d)
  LAST_SUNDAY_WEEK=$(date -v-sundayj +%V)
  LAST_SUNDAY_YEAR=$(date -v-sundayj +%G)
else
  # GNU date
  LAST_SUNDAY=$(date -d "last sunday" +%Y-%m-%d)
  LAST_SUNDAY_WEEK=$(date -d "last sunday" +%V)
  LAST_SUNDAY_YEAR=$(date -d "last sunday" +%G)
fi

# If today IS Sunday, the "last completed week" ended yesterday (Saturday),
# so we want THIS week's review (the week ending today).
DOW=$(date +%u)  # 7 = Sunday
if [[ "$DOW" == "7" ]]; then
  LAST_SUNDAY_WEEK=$(date +%V)
  LAST_SUNDAY_YEAR=$(date +%G)
fi

WEEKLY_FILE="${VAULT_ROOT}/journal/${LAST_SUNDAY_YEAR}/weekly/${LAST_SUNDAY_YEAR}-W${LAST_SUNDAY_WEEK}.md"

if [[ ! -f "$WEEKLY_FILE" ]]; then
  echo "⚠️  WEEKLY REVIEW OVERDUE: No weekly summary found for W${LAST_SUNDAY_WEEK} (week ending ${LAST_SUNDAY}). Expected: journal/${LAST_SUNDAY_YEAR}/weekly/${LAST_SUNDAY_YEAR}-W${LAST_SUNDAY_WEEK}.md — Create it by reviewing daily entries from that week."
fi

# --- Monthly review check ---
# On or after the 1st, check if previous month's review exists.
DAY=$(date +%d)
CURRENT_MONTH=$(date +%m)

# Get previous month info
if date -v-1d +%s &>/dev/null; then
  PREV_MONTH=$(date -v-1m +%m)
  PREV_MONTH_YEAR=$(date -v-1m +%Y)
else
  PREV_MONTH=$(date -d "last month" +%m)
  PREV_MONTH_YEAR=$(date -d "last month" +%Y)
fi

MONTHLY_FILE="${VAULT_ROOT}/journal/${PREV_MONTH_YEAR}/monthly/${PREV_MONTH_YEAR}-${PREV_MONTH}.md"

if [[ ! -f "$MONTHLY_FILE" ]]; then
  # Only nag if we're in the first 7 days of a new month (after that, stop nagging)
  if [[ "$DAY" -le 7 ]] || [[ "$CURRENT_MONTH" != "$PREV_MONTH" && "$DAY" -le 7 ]]; then
    echo "⚠️  MONTHLY REVIEW OVERDUE: No monthly summary found for ${PREV_MONTH_YEAR}-${PREV_MONTH}. Expected: journal/${PREV_MONTH_YEAR}/monthly/${PREV_MONTH_YEAR}-${PREV_MONTH}.md — Create it by reviewing weekly summaries and daily entries from that month."
  fi
fi
