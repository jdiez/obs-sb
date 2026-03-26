---
type: category
---

# Authors

Notes about authors, thinkers, and creators.

```dataview
TABLE status, subjects
FROM "notes"
WHERE contains(categories, [[Authors]])
SORT file.name ASC
```
