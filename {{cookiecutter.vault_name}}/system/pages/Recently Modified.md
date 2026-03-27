---
categories:
  - "[[SOPs]]"
subjects:
  - "[[Productivity]]"
status: published
type: sop
---

# Recently Modified

```dataview
TABLE file.mtime AS "Modified", type AS "Type", status AS "Status", categories AS "Category"
FROM "notes"
SORT file.mtime DESC
LIMIT 25
```
