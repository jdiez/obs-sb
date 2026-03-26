---
type: dashboard
---

# Reading List

## To Read

```dataview
TABLE author, subjects
FROM "notes"
WHERE contains(categories, [[categories/Reading List]])
AND status = "to-read"
SORT file.ctime DESC
```

## Currently Reading

```dataview
TABLE author, subjects
FROM "notes"
WHERE contains(categories, [[categories/Reading List]])
AND status = "reading"
SORT file.name ASC
```

## Completed

```dataview
TABLE author, subjects, rating
FROM "notes"
WHERE contains(categories, [[categories/Reading List]])
AND status = "complete"
SORT file.mtime DESC
```
