---
name: vault-conventions
description: Core vault conventions for frontmatter, wikilinks, naming, and templates. Apply automatically when creating or modifying any note in the vault.
user-invocable: false
---

# Vault Conventions

## YAML Frontmatter (required on every note)

```yaml
---
categories:
  - "[[Category Name]]"
subjects:
  - "[[Subject Name]]"
people:
  - "[[Contact Name]]"
status: idea | in-progress | ready | published | archived
type: note-type-slug
created: YYYY-MM-DD
journal: "[[YYYY-MM-DD]]"
---
```

- `categories` link to files in `categories/`
- `subjects` link to files in `subjects/` — topical only, never people
- `people` link to contact notes in `notes/`
- `journal` links to the daily journal entry when this note was created/modified

## File Naming

| Type | Pattern |
|------|---------|
| Contacts | `Full Name.md` |
| Meetings | `Meeting - [Person/Group] - YYYY-MM-DD.md` |
| BMC | `BMC - [Name].md` |
| Journal daily | `YYYY-MM-DD.md` in `journal/YYYY/MM/` |
| Journal weekly | `YYYY-[W]WW.md` in `journal/YYYY/weekly/` |
| Journal monthly | `YYYY-MM.md` in `journal/YYYY/monthly/` |
| Everything else | Descriptive title in `notes/` |

## Structure Rules

- ALL knowledge notes in `notes/` — flat, no subfolders ever
- Journal entries in `journal/YYYY/MM/` — year-based hierarchy
- Organization through properties, never folders
- Templates in `system/templates/` — one per note type

## Calendar Visibility

Notes on Full Calendar need `type: single` plus:
```yaml
title: "Short event name"
date: YYYY-MM-DD
startTime: "HH:MM"
endTime: "HH:MM"
allDay: false
```

## Cognitive Governance

- Literature Notes: identify core claim AND what it argues against
- Permanent Notes: must link 2+ notes from different subjects; idea in one sentence
- Overlapping sources: structure as Confirmed / Challenged / New
- References section: every citation needs a clickable URL

## Auto-Update Journal

When creating or modifying a note, append a brief entry to today's daily journal and add `journal: "[[YYYY-MM-DD]]"` to the note's frontmatter.
