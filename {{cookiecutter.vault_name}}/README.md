# {{ cookiecutter.vault_name }} — Obsidian Second Brain

A personal knowledge management vault built on **Dataview** queries and YAML properties, designed for AI-assisted workflows with **Claude Code**.

Created by {{ cookiecutter.author_name }}.

## How It Works

Notes are organized by **properties** (YAML metadata), not by folder hierarchy. Every note lives in one flat folder (`notes/`) and is tagged with one or more **categories** (what type it is) and **subjects** (what it's about). Dataview queries in container notes surface the right notes automatically.

This means a single note can appear in multiple views without duplication — solving the "which folder does this go in?" problem.

## Vault Structure

```
{{ cookiecutter.vault_name }}/
├── inbox/              Capture zone — drop anything here for later processing
├── notes/              All knowledge notes — flat, no subfolders
├── journal/            Temporal notes — year-based hierarchy
│   └── YYYY/           One folder per year
│       ├── MM/         Daily entries (YYYY-MM-DD.md)
│       ├── weekly/     Weekly summaries (YYYY-WNN.md)
│       └── monthly/    Monthly reviews (YYYY-MM.md)
├── categories/         Container notes by type
├── subjects/           Container notes by topic
└── system/
    ├── templates/      One template per note type (18 templates)
    ├── attachments/    Images, PDFs, media
    └── pages/          Dashboards and reference docs
```

## Categories (What type of note is this?)

| Category | Use For |
|----------|---------|
| YouTube Videos | Video notes and takeaways |
| Newsletters | Newsletter drafts and editions |
| Literature Notes | Notes from books, articles, papers |
| Permanent Notes | Refined standalone ideas |
| Authors | Notes about thinkers and creators |
| Meetings | Meeting notes and action items |
| SOPs | Standard operating procedures |
| AI Prompts | Prompt templates and AI workflows |
| Projects | Active and archived projects |
| Task Items | Standalone actionable work items linked to projects |
| Tweets | Social media drafts and threads |
| Journal Entries | Daily, weekly, and monthly journal entries |
| Contacts | People and professional contacts |
| Goals | Personal and professional goals |
| Reading List | Books, articles, and content to read |

## Subjects (What is this note about?)

AI, Business, Psychology, Philosophy, Health, Productivity, Creativity

Add new subjects anytime by creating a new container note in `subjects/`.

## Every Note Has Properties

```yaml
---
categories:
  - "[[Literature Notes]]"
subjects:
  - "[[AI]]"
  - "[[Psychology]]"
status: idea
type: literature-note
---
```

- **Categories** and **subjects** use `[[wikilinks]]` — this powers the Dataview queries
- **Status** tracks lifecycle: `idea` → `in-progress` → `ready` → `published` → `archived` (knowledge notes) or `backlog` → `planning` → `active` → `on-hold` → `done` → `archived` (projects)
- **Type** is a machine-readable slug

## Creating Notes

1. Create a new note in `notes/`
2. Apply a template (`Cmd+T` or your template hotkey) — it pre-fills the category and properties
3. Add subjects relevant to the topic
4. Write

For journal entries, use the Periodic Notes command — it creates the file in `journal/YYYY/MM/` with the journal template automatically.

## Using with Claude Code

Every folder contains a `CLAUDE.md` file that gives Claude Code full context about the vault. Open a terminal in the vault root and run Claude Code — it understands the system immediately.

### Automatic Inbox Processing

A startup hook is configured in `.claude/settings.json` that triggers every time you launch Claude Code in this vault. It automatically checks `inbox/` for unprocessed notes and sorts them — assigning categories, subjects, and YAML frontmatter, then moving them to `notes/` (or the appropriate `journal/YYYY/MM/` folder for journal entries).

Just drop files into `inbox/` anytime, and they'll be processed the next time you open Claude Code.

See **[Claude Code Tutorial](system/pages/Claude%20Code%20Tutorial.md)** for a complete walkthrough of AI-assisted workflows.

## Project Management

- **Projects** use a lean lifecycle: `backlog` → `planning` → `active` → `on-hold` → `done` → `archived`
- **Task Items** are standalone actionable notes linked to a project via the `project` property
- **Meetings** link to projects via the `project` property
- **Project Board** dashboard (`system/pages/Project Board.md`) shows active projects, tasks, and meetings
- **Sprint tracking** via the `sprint` property on projects and tasks
- **Calendar view** — Full Calendar plugin renders meetings and dated notes on a visual calendar

## Plugins

**Required (Core):**
- Templates — configured for `system/templates/`
- Bases — native `.base` file views

**Required (Community):**
- Dataview — powers all inline queries in category/subject container pages and dashboards
- Tasks — checkbox metadata and task queries
- Templater — advanced template logic
- Full Calendar — visual calendar view of meetings and dated notes
- Periodic Notes — year-based journal folders for daily, weekly, and monthly notes

## Getting Started

1. Open this folder in Obsidian
2. Enable community plugins: Settings → Community Plugins → Turn on → Enable Dataview, Tasks, Templater, Full Calendar, and Periodic Notes
3. Start capturing — drop files in `inbox/` or create notes directly in `notes/`
4. For AI workflows, open a terminal in the vault root and launch Claude Code

## Extending the System

- **New category** — Create a container note in `categories/` with a Dataview query + a matching template in `system/templates/`
- **New subject** — Create a container note in `subjects/` with a Dataview query
- **New status** — Just start using it in YAML frontmatter
- **New note type** — Create a template in `system/templates/` with the desired YAML properties
