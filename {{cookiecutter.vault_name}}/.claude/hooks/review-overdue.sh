#!/bin/bash
# SessionStart hook: check if weekly or monthly reviews are overdue
# Self-healing — catches missed weeks, auto-generates missing summaries.

VAULT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# --- Weekly review check ---
# Find ALL missing weekly summaries since the last one that exists.
# Walk backwards from the current completed week up to 12 weeks.

DOW=$(date +%u)  # 1=Mon, 7=Sun

# Calculate the last Sunday (end of last completed week)
if [[ "$DOW" == "7" ]]; then
  DAYS_BACK=0
else
  DAYS_BACK=$DOW
fi

# Use perl for reliable cross-platform date arithmetic
get_date_offset() {
  local base_date="$1"  # YYYY-MM-DD
  local offset_days="$2"
  perl -MPOSIX -e '
    my ($y,$m,$d) = split(/-/, $ARGV[0]);
    my $t = mktime(0,0,12,$d,$m-1,$y-1900) + $ARGV[1]*86400;
    my @lt = localtime($t);
    printf "%04d-%02d-%02d\n", $lt[5]+1900, $lt[4]+1, $lt[3];
  ' "$base_date" "$offset_days"
}

get_iso_week() {
  local d="$1"  # YYYY-MM-DD
  perl -MPOSIX -e '
    my ($y,$m,$d) = split(/-/, $ARGV[0]);
    my $t = mktime(0,0,12,$d,$m-1,$y-1900);
    my @lt = localtime($t);
    my $yday = $lt[7];  # 0-based day of year
    my $wday = ($lt[6] + 6) % 7;  # 0=Mon, 6=Sun
    my $week = int(($yday - $wday + 10) / 7);
    my $iso_year = $y;
    if ($week < 1) { $iso_year--; $week = 52; }
    elsif ($week > 52) {
      my $jan1_wday = (localtime(mktime(0,0,12,1,0,$y-1900+1)))[6];
      $jan1_wday = ($jan1_wday + 6) % 7;
      if ($jan1_wday <= 3) { $iso_year++; $week = 1; }
    }
    printf "%04d %02d\n", $iso_year, $week;
  ' "$d"
}

TODAY=$(date +%Y-%m-%d)
LAST_SUNDAY=$(get_date_offset "$TODAY" "-$DAYS_BACK")

# Get the ISO week/year for last Sunday
read LATEST_YEAR LATEST_WEEK <<< "$(get_iso_week "$LAST_SUNDAY")"

MISSING_WEEKS=()

for i in $(seq 0 11); do
  # Calculate the Sunday of this week (end of week)
  WEEK_OFFSET=$(( DAYS_BACK + i * 7 ))
  WEEK_SUNDAY=$(get_date_offset "$TODAY" "-$WEEK_OFFSET")
  read CHECK_YEAR CHECK_WEEK <<< "$(get_iso_week "$WEEK_SUNDAY")"

  WEEKLY_FILE="${VAULT_ROOT}/journal/${CHECK_YEAR}/weekly/${CHECK_YEAR}-W${CHECK_WEEK}.md"

  if [[ -f "$WEEKLY_FILE" ]]; then
    break
  fi

  # Calculate Monday of this week (Sunday - 6 days)
  WEEK_MONDAY=$(get_date_offset "$WEEK_SUNDAY" "-6")

  # Check if any daily entries exist for this week (Mon-Sun)
  HAS_ENTRIES=false
  for d in $(seq 0 6); do
    DAY_DATE=$(get_date_offset "$WEEK_MONDAY" "$d")
    DAY_YEAR="${DAY_DATE%%-*}"
    DAY_MONTH="${DAY_DATE:5:2}"
    if [[ -f "${VAULT_ROOT}/journal/${DAY_YEAR}/${DAY_MONTH}/${DAY_DATE}.md" ]]; then
      HAS_ENTRIES=true
      break
    fi
  done

  if $HAS_ENTRIES; then
    MISSING_WEEKS+=("W${CHECK_WEEK}:${CHECK_YEAR}")
  fi
done

# Report missing weeks in chronological order with auto-generate instruction
if [[ ${#MISSING_WEEKS[@]} -gt 0 ]]; then
  REVERSED=()
  for ((i=${#MISSING_WEEKS[@]}-1; i>=0; i--)); do
    REVERSED+=("${MISSING_WEEKS[$i]}")
  done

  WEEK_LIST=""
  for entry in "${REVERSED[@]}"; do
    WEEK_NUM="${entry%%:*}"
    WEEK_YEAR="${entry##*:}"
    WEEK_LIST="${WEEK_LIST}  - journal/${WEEK_YEAR}/weekly/${WEEK_YEAR}-${WEEK_NUM}.md\n"
  done

  echo "WEEKLY REVIEW AUTO-GENERATE: ${#MISSING_WEEKS[@]} weekly summary(ies) missing since last existing summary:"
  echo -e "$WEEK_LIST"
  echo "Generate each missing weekly summary by reading the daily journal entries for that week. Use the Weekly Summary template format. Process them in chronological order. Do not ask — just generate them."
fi

# --- Monthly review check ---
DAY=$(date +%d)

if date -v-1d +%s &>/dev/null; then
  PREV_MONTH=$(date -v-1m +%m)
  PREV_MONTH_YEAR=$(date -v-1m +%Y)
else
  PREV_MONTH=$(date -d "last month" +%m)
  PREV_MONTH_YEAR=$(date -d "last month" +%Y)
fi

MONTHLY_FILE="${VAULT_ROOT}/journal/${PREV_MONTH_YEAR}/monthly/${PREV_MONTH_YEAR}-${PREV_MONTH}.md"

if [[ ! -f "$MONTHLY_FILE" ]]; then
  if [[ "$DAY" -le 7 ]]; then
    DAILY_DIR="${VAULT_ROOT}/journal/${PREV_MONTH_YEAR}/${PREV_MONTH}"
    DAILY_COUNT=0
    if [[ -d "$DAILY_DIR" ]]; then
      DAILY_COUNT=$(ls "$DAILY_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
    fi

    if [[ "$DAILY_COUNT" -gt 0 ]]; then
      echo "MONTHLY REVIEW AUTO-GENERATE: No monthly summary for ${PREV_MONTH_YEAR}-${PREV_MONTH}. ${DAILY_COUNT} daily entries found in journal/${PREV_MONTH_YEAR}/${PREV_MONTH}/. Generate journal/${PREV_MONTH_YEAR}/monthly/${PREV_MONTH_YEAR}-${PREV_MONTH}.md now by reading all daily entries and weekly summaries from that month. Use the Monthly Summary template. Do not ask — just generate it."
    else
      echo "MONTHLY REVIEW OVERDUE: No monthly summary found for ${PREV_MONTH_YEAR}-${PREV_MONTH}. Expected: journal/${PREV_MONTH_YEAR}/monthly/${PREV_MONTH_YEAR}-${PREV_MONTH}.md — No daily entries found to generate from."
    fi
  fi
fi
