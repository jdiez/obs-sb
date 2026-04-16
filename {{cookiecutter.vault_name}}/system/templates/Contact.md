---
categories:
  - "[[Contacts]]"
subjects: []
status: active
type: contact
email: ""
company: ""
role: ""
created: {{date:YYYY-MM-DD}}
---

# {{title}}

## Related Notes

```dataview
TABLE status, categories, date
FROM "notes"
WHERE contains(people, this.file.link)
SORT date DESC
```
