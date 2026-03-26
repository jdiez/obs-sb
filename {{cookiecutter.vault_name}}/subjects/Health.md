---
type: subject
---

# Health

Physical health, wellness, fitness, and nutrition.

```dataview
TABLE status, categories
FROM "notes"
WHERE contains(subjects, [[Health]])
SORT file.name ASC
```
