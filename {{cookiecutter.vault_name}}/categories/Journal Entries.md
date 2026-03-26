---
type: category
---

# Journal Entries

Daily, weekly, and monthly journal entries.

```dataview
TABLE status
FROM "journal"
WHERE contains(categories, [[Journal Entries]])
SORT file.name DESC
```
