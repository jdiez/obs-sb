# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

An Obsidian vault organized as a second brain using the **Properties** pattern. Notes are organized by metadata (YAML properties), not folder hierarchy. Navigation happens through category and subject container notes powered by **Dataview** queries (inline `dataview` code blocks).

## Vault Structure

```
{{ cookiecutter.vault_name }}/
├── inbox/          # Capture zone — unprocessed items land here
├── notes/          # ALL knowledge notes — flat, NO subfolders ever
├── journal/        # Temporal notes — year-based hierarchy
│   └── YYYY/       # One folder per year
│       ├── MM/     # Daily entries per month: YYYY-MM-DD.md
│       ├── weekly/ # Weekly summaries: YYYY-[W]WW.md
│       └── monthly/# Monthly reviews: YYYY-MM.md
├── categories/     # Container notes: "what type of note is this?"
├── subjects/       # Container notes: "what is this note about?"
└── system/         # Engine room
    ├── templates/  # One template per note type
    ├── attachments/# Images, PDFs, media
    └── pages/      # Dashboards
```

## Core Rules

1. **All knowledge notes go in `notes/` — flat, no subfolders.** Organization is through properties, never folders.
2. **Journal entries go in `journal/YYYY/MM/`** — year-based hierarchy, separate from knowledge notes.
3. **Every note has YAML frontmatter** with `categories`, `subjects`, `status`, and `type` properties.
4. **Categories and subjects use `[[wikilinks]]`** in YAML — this powers Dataview queries.
5. **Never create subfolders in `notes/`.** If something needs grouping, create a category or subject.

## YAML Frontmatter Convention

Every note must have this structure:

```yaml
---
categories:
  - "[[Category Name]]"
subjects:
  - "[[Subject Name]]"
status: idea | in-progress | ready | published | archived (knowledge notes)
        backlog | planning | active | on-hold | done | archived (projects)
        todo | in-progress | done | blocked (task items)
type: note-type-slug
---
```

- `categories` — links to files in `categories/` (note type: literature note, newsletter, etc.)
- `subjects` — links to files in `subjects/` (topic: AI, Business, etc.)
- `status` — lifecycle stage
- `type` — machine-readable type slug. **Exception:** Any note that must appear on the Full Calendar (meetings, scheduled tasks, events) uses `type: single`. Use `categories` to distinguish them (e.g., `[[Meetings]]`, `[[Task Items]]`).

### Full Calendar Fields (required for calendar visibility)

Any note with `type: single` **must** include these fields to render on the calendar:

```yaml
type: single
title: "Short event name"        # REQUIRED — without this the event won't render
date: YYYY-MM-DD                 # Event date
startTime: "HH:MM"              # Start time (24h). Omit for all-day events.
endTime: "HH:MM"                # End time (24h). Omit for all-day events.
allDay: false                    # true for all-day, false for timed events
```

**Key:** The `title` field is mandatory for Full Calendar v0.10.7 to display the event. Notes without `title` in frontmatter will not appear on the calendar.

## Working With This Vault

- **Creating notes:** Apply a template from `system/templates/` — it pre-fills the correct category and properties.
- **Processing inbox:** Read files in `inbox/`, assign categories/subjects, move to `notes/`.
- **Bulk updates:** Update properties across multiple notes using Grep to find targets, then Edit.
- **Journal summaries:** Read daily entries from `journal/YYYY/MM/` for a date range, produce weekly/monthly summary.
- **Project management:** Projects, task items, and meetings are linked via `project` property. Projects have a `collaborators` field — use `[[Contact Name]]` wikilinks to link relevant contacts. See `system/pages/Project Board.md` for the dashboard. Projects use lean statuses: `backlog` → `planning` → `active` → `on-hold` → `done` → `archived`.
- **Dashboards are dual-format:** Every new dashboard in `system/pages/` must be created as both a `.md` file (Dataview queries) and a `.base` file (Obsidian Bases). Both coexist — Dataview and Bases run in parallel.
- **Never modify `.obsidian/workspace.json`** — it changes with UI state.

## Plugins

- **Core:** Templates, Graph, Backlinks, Sync, Bases (`.base` files only)
- **Community (required):** dataview (powers all inline queries in category/subject pages), obsidian-tasks-plugin, templater-obsidian, obsidian-full-calendar (visual calendar from note dates), periodic-notes (year-based journal folders for daily/weekly/monthly)

## Session Start Checklist

1. Check `inbox/` for unprocessed notes
2. Surface today's calendar items (meetings, tasks with today's date)
3. Flag overdue tasks (due-date past, status not done)
4. If Sunday: prompt for weekly review
5. If 1st of month: prompt for monthly review

## Review Cycles

- **Weekly review (Sunday):** Read all daily journal entries for the week from `journal/YYYY/MM/`. Produce `journal/YYYY/weekly/YYYY-[W]WW.md` summarizing highlights, accomplishments, challenges, learnings, and next priorities. Cross-reference completed tasks and meetings.
- **Monthly review (1st of month):** Read all weekly summaries + daily entries. Produce `journal/YYYY/monthly/YYYY-MM.md` with goals progress, achievements, lessons learned. Compare against active Goals notes.

## Planning

- **Goals → Projects → Tasks:** Goals define outcomes. Projects are the work to achieve them. Task Items are atomic steps within projects. Link them: tasks have `project: "[[Project]]"`, projects reference goals in their body or subjects.
- **Daily planning:** At session start, check today's calendar items (tasks/meetings with today's date) and surface them. Flag overdue tasks (due-date < today, status != done).
- **Weekly planning:** During weekly review, identify tasks without due dates on active projects. Suggest priorities for the coming week based on project status and goal deadlines.

## Learning

- **Lessons → Permanent Notes:** When weekly/monthly reviews reveal recurring themes or validated insights, extract them into Permanent Notes in `notes/` with appropriate subjects.
- **Retrospectives:** When a project moves to `done`, create a retrospective section summarizing: what worked, what didn't, what to do differently. Tag with `[[Retrospectives]]` subject.
- **Reading integration:** Literature notes should link to relevant projects/goals via subjects when applicable, creating a feedback loop between learning and doing.

## Status Hygiene

- Tasks at `todo` with a past `due-date` should be flagged, not silently ignored.
- Projects at `active` with no `todo`/`in-progress` tasks may need attention.
- Goals past `target-date` with status != `done` should surface in reviews.

## Template Reference

| Template         | type slug         | category         | calendar? |
|------------------|-------------------|------------------|-----------|
| Meeting          | single            | Meetings         | yes       |
| Task Item        | single            | Task Items       | yes       |
| Project          | project           | Projects         | no        |
| Goal             | goal              | Goals            | no        |
| Literature Note  | literature-note   | Literature Notes | no        |
| Reading List Item| reading-list-item | Reading List     | no        |
| Permanent Note   | permanent-note    | Permanent Notes  | no        |
| YouTube Video    | youtube-video     | YouTube Videos   | no        |
| Newsletter       | newsletter        | Newsletters      | no        |
| Author           | author            | Authors          | no        |
| AI Prompt        | ai-prompt         | AI Prompts       | no        |
| SOP              | sop               | SOPs             | no        |
| Tweet            | tweet             | Tweets           | no        |
| Contact          | contact           | Contacts         | no        |
| General Note     | note              | (varies)         | no        |
| Daily Journal    | daily             | Journal Entries  | no        |
| Weekly Summary   | weekly            | Journal Entries  | no        |
| Monthly Summary  | monthly           | Journal Entries  | no        |

## Existing Categories

Contacts, Literature Notes, Meetings, Projects, Task Items, YouTube Videos, Newsletters, Permanent Notes, Authors, SOPs, AI Prompts, Tweets, Journal Entries, Goals, Reading List

## Existing Subjects

AI, Business, Psychology, Philosophy, Health, Productivity, Creativity

## File Naming

- Contacts: `Full Name.md` (e.g., `Diana Vega.md`). Use `aliases` in frontmatter for alternate names.
- Meetings: `Meeting - [Person/Group] - YYYY-MM-DD.md`
- Tasks: descriptive title, no date prefix
- Literature notes: title of the source
- Journal daily: `YYYY-MM-DD.md` (handled by periodic-notes)
- Journal weekly: `YYYY-[W]WW.md`
- Journal monthly: `YYYY-MM.md`

## Keeping This File Current

This CLAUDE.md is loaded every session — no hook needed. When creating a new category, subject, or template, update the corresponding list above in the same operation. Stale registries cause duplicates.

## Files to Ignore

- `.env` — gitignored, never commit secrets
- `.obsidian/workspace.json` — volatile UI state
- `system/attachments/` — binary files, keep out of diffs when possible
