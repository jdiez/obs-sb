---
type: system
---

# Open Questions

*Questions and unknowns surfaced during research that warrant future investigation.*

## Unresolved Questions

```dataview
TABLE WITHOUT ID
  link(file.link, file.name) AS "Note",
  open-questions AS "Questions",
  file.mtime AS "Modified"
FROM "notes"
WHERE open-questions
SORT file.mtime DESC
```

## How to Use

- Add an `## Open Questions` section to any note when you encounter unknowns during research
- Add `open-questions: true` to YAML frontmatter to surface the note here
- Review this page during weekly reviews to decide which questions to pursue
- When a question is resolved, remove it from the note's section (or move to a new note)
