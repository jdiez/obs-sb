---
type: category
---

# SOPs

Standard Operating Procedures and process documents.

```dataview
TABLE status, subjects
FROM "notes"
WHERE contains(categories, [[SOPs]])
SORT file.name ASC
```
