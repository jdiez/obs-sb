---
type: category
---

# Task Items

Standalone actionable work items linked to projects.

```dataview
TABLE status, priority, project, due-date, assigned-to
FROM "notes"
WHERE contains(categories, [[Task Items]])
SORT status ASC
```
