---
categories:
  - "[[SOPs]]"
subjects:
  - "[[Productivity]]"
status: published
type: sop
---

# Goals Board

```dataview
TABLE status AS "Status", target-date AS "Target", subjects AS "Topics"
FROM "notes"
WHERE type = "goal"
SORT status ASC, target-date ASC
```
