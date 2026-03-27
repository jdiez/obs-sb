---
categories:
  - "[[SOPs]]"
subjects:
  - "[[Productivity]]"
status: published
type: sop
---

# Meetings This Week

```dataview
TABLE date AS "Date", startTime AS "Start", endTime AS "End", status AS "Status"
FROM "notes"
WHERE type = "single" AND contains(categories, [[Meetings]])
  AND date >= date(today) - dur(date(today).weekday days)
  AND date <= date(today) - dur(date(today).weekday days) + dur(6 days)
SORT date ASC, startTime ASC
```
