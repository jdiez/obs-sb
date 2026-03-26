---
type: category
---

# Reading List

Articles, books, blog posts, and other content to read or in progress.

## To Read

```dataview
TABLE author, subjects
FROM "notes"
WHERE contains(categories, [[Reading List]])
AND status = "to-read"
SORT file.name ASC
```

## Reading

```dataview
TABLE author, subjects
FROM "notes"
WHERE contains(categories, [[Reading List]])
AND status = "reading"
SORT file.name ASC
```

## Completed

```dataview
TABLE author, subjects, rating
FROM "notes"
WHERE contains(categories, [[Reading List]])
AND status = "complete"
SORT file.name DESC
```
