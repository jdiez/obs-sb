---
type: category
---

# Contacts

People and professional contacts.

```dataview
TABLE subjects AS "Company/Context", status
FROM "notes"
WHERE contains(categories, [[Contacts]])
SORT file.name ASC
```
