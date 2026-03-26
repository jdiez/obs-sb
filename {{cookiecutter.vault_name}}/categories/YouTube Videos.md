---
type: category
---

# YouTube Videos

All video notes in the vault.

```dataview
TABLE status, subjects
FROM "notes"
WHERE contains(categories, [[YouTube Videos]])
SORT file.name ASC
```
