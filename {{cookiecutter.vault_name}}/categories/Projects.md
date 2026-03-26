---
type: category
---

# Projects

Active and archived project notes.

```dataview
TABLE status, priority, start-date, target-date, sprint
FROM "notes"
WHERE contains(categories, [[Projects]])
SORT status ASC
```
