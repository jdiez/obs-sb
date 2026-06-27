---
type: category
---

# Comparisons

*Structured side-by-side analyses of tools, approaches, frameworks, or concepts.*

```dataview
TABLE WITHOUT ID
  link(file.link, file.name) AS "Comparison",
  subjects AS "Subjects",
  status AS "Status",
  file.mtime AS "Modified"
FROM "notes"
WHERE contains(categories, [[Comparisons]])
SORT file.mtime DESC
```
