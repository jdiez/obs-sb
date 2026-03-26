---
type: dashboard
---

# Project Board

## Active Projects

```dataview
TABLE priority, start-date, target-date, sprint
FROM "notes"
WHERE contains(categories, [[Projects]])
AND status = "active"
SORT priority DESC
```

## Planning

```dataview
TABLE priority, start-date, target-date
FROM "notes"
WHERE contains(categories, [[Projects]])
AND status = "planning"
```

## On Hold

```dataview
TABLE priority, start-date
FROM "notes"
WHERE contains(categories, [[Projects]])
AND status = "on-hold"
```

## Backlog

```dataview
TABLE priority, start-date
FROM "notes"
WHERE contains(categories, [[Projects]])
AND status = "backlog"
```

## Upcoming Tasks

```dataview
TABLE priority, project, due-date, assigned-to, sprint
FROM "notes"
WHERE contains(categories, [[Task Items]])
AND status != "done"
SORT due-date ASC
```

## Upcoming Meetings

```dataview
TABLE date, time, project, attendees
FROM "notes"
WHERE contains(categories, [[Meetings]])
AND status = "planned"
AND date >= date(today)
SORT date ASC
```

## Recent Meetings

```dataview
TABLE date, project, attendees
FROM "notes"
WHERE contains(categories, [[Meetings]])
AND status = "complete"
SORT date DESC
LIMIT 10
```

## Completed Projects

```dataview
TABLE priority, start-date, end-date
FROM "notes"
WHERE contains(categories, [[Projects]])
AND status = "done"
```
