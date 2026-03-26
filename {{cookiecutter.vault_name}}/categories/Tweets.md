---
type: category
---

# Tweets

Tweet drafts, threads, and social media content.

```dataview
TABLE status, subjects
FROM "notes"
WHERE contains(categories, [[Tweets]])
SORT file.name ASC
```
