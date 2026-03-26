---
type: category
---

# Goals

Personal and professional goals with tracking.

```dataview
TABLE status, subjects, priority, target-date
FROM "notes"
WHERE contains(categories, [[Goals]])
SORT status ASC
```
