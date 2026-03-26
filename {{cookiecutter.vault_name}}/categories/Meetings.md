---
type: category
---

# Meetings

Meeting notes, agendas, and action items.

```dataview
TABLE date, project, status
FROM "notes"
WHERE contains(categories, [[Meetings]])
SORT date DESC
```
