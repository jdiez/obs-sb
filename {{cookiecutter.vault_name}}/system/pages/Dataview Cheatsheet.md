---
categories:
  - "[[SOPs]]"
subjects:
  - "[[Productivity]]"
status: published
type: sop
---

# Dataview Cheatsheet

Copy-paste these queries into any note. They render as live tables/lists in Obsidian.

---

## Recently Created Notes

```dataview
TABLE file.ctime AS "Created", type AS "Type", status AS "Status"
FROM "notes"
SORT file.ctime DESC
LIMIT 15
```

## Recently Modified Notes

```dataview
TABLE file.mtime AS "Modified", type AS "Type", status AS "Status"
FROM "notes"
SORT file.mtime DESC
LIMIT 15
```

## Orphan Notes (No Subjects)

```dataview
LIST
FROM "notes"
WHERE !subjects OR length(subjects) = 0
SORT file.name ASC
```

## Tasks Due This Week

```dataview
TABLE date AS "Due", status AS "Status", project AS "Project"
FROM "notes"
WHERE type = "single" AND categories = [[Task Items]]
  AND date >= date(today) AND date <= date(today) + dur(7 days)
SORT date ASC
```

## Overdue Tasks

```dataview
TABLE date AS "Due", status AS "Status", project AS "Project"
FROM "notes"
WHERE type = "single" AND categories = [[Task Items]]
  AND date < date(today) AND status != "done"
SORT date ASC
```

## Notes by Category

```dataview
TABLE length(rows) AS "Count"
FROM "notes"
FLATTEN categories AS cat
GROUP BY cat
SORT length(rows) DESC
```

## Notes by Subject

```dataview
TABLE length(rows) AS "Count"
FROM "notes"
FLATTEN subjects AS sub
GROUP BY sub
SORT length(rows) DESC
```

## All Projects by Status

```dataview
TABLE status AS "Status", subjects AS "Topics"
FROM "notes"
WHERE type = "project"
SORT status ASC
```

## Meetings This Week

```dataview
TABLE date AS "Date", startTime AS "Start", endTime AS "End"
FROM "notes"
WHERE type = "single" AND categories = [[Meetings]]
  AND date >= date(today) AND date <= date(today) + dur(7 days)
SORT date ASC, startTime ASC
```

## Notes Without Status

```dataview
LIST
FROM "notes"
WHERE !status
SORT file.name ASC
```
