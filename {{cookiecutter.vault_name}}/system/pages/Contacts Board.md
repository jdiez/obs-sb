---
type: dashboard
---

# Contacts Board

## All Contacts

```dataview
TABLE company, role, email, subjects AS "Interests"
FROM "notes"
WHERE contains(categories, [[Contacts]])
SORT file.name ASC
```

## Contacts by Company/Context

```dataview
TABLE WITHOUT ID
  file.link AS "Contact",
  company,
  role
FROM "notes"
WHERE contains(categories, [[Contacts]])
GROUP BY company
SORT company ASC
```

## Shared Subjects

```dataview
TABLE WITHOUT ID
  file.link AS "Contact",
  subjects AS "Subjects"
FROM "notes"
WHERE contains(categories, [[Contacts]])
SORT file.name ASC
```
