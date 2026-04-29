---
name: weekly-review
description: Run the weekly review — read all daily journal entries for the week, produce a weekly summary with highlights, accomplishments, challenges, learnings, and next priorities. Use on Sundays or when user asks for weekly review.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Weekly Review

Generate a weekly summary from daily journal entries.

## Current State
- Current week: !`date +%Y-W%V`
- Today: !`date +%Y-%m-%d`
- Branch: !`git branch --show-current`

## Steps

1. Determine the week range (Monday to Sunday)
2. Read all daily journal entries from `journal/YYYY/MM/` for the date range
3. Produce `journal/YYYY/weekly/YYYY-[W]WW.md` containing:
   - Highlights and accomplishments
   - Challenges encountered
   - Key learnings
   - Cross-references to completed tasks and meetings
   - Next week priorities
4. Apply Cognitive Governance checks:
   - Surface at least one tension or contradiction between notes/ideas encountered
   - Identify one belief that was updated and what updated it
5. Semantic checks (Wiki Lint):
   - Missing cross-references (notes sharing 2+ subjects but not linking)
   - Concept candidates (terms in 3+ notes without their own note)
   - Contradictions between notes
6. Check for notes without due dates on active projects — suggest priorities
7. Update index.md with the new weekly summary
