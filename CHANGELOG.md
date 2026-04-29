# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2026-04-29

### Added

- **Skills** (3 new Claude Code skills in `.claude/skills/`):
  - `inbox-process`: User-invocable skill (`/inbox-process`) for mid-session inbox processing — classifies files, adds YAML frontmatter, copies originals to `sources/`, moves processed versions to `notes/`, runs Deep Ingestion Cascade
  - `weekly-review`: User-invocable skill (`/weekly-review`) for generating weekly summaries from daily journal entries — highlights, challenges, learnings, cognitive governance checks, wiki lint semantic checks
  - `vault-conventions`: Claude-only background skill (not user-invocable) that provides vault convention context — frontmatter structure, file naming, cognitive governance rules, calendar visibility requirements
- **Subagents** (2 new Claude Code agents in `.claude/agents/`):
  - `vault-linker`: Runs the Deep Ingestion Cascade in parallel — finds notes sharing 2+ subjects with a new note and adds cross-references to up to 5 related existing notes without consuming main conversation context
  - `note-reviewer`: Read-only quality assurance agent that reviews notes against vault conventions and cognitive governance rules — checks frontmatter, core claims, cross-references, reference URLs, and orphan status
- **PreToolUse hooks** (template protection): Blocks Edit and Write operations on `system/templates/` files, requiring explicit user approval before modifying templates
- **PostToolUse hooks** (auto-rebuild index): Automatically rebuilds `index.md` when any file in `notes/` is created or modified via Write or Edit, keeping the LLM navigation index current during sessions
- `journal-reminder.sh` hook: PostToolUse hook that prompts Claude to update today's journal whenever a note in `notes/` is changed (previously only in root `.claude/` for project development, now in the generated vault template)

### Changed

- `.claude/settings.json`: expanded from SessionStart/SessionEnd-only hooks to include PreToolUse (template protection) and PostToolUse (journal reminders + index rebuild) hooks
- Fixed Jinja2 rendering error for `{{date:YYYY-MM-DD}}` in CLAUDE.md by wrapping Templater syntax in `{% raw %}` tags

## [1.9.0] - 2026-04-19

### Added

- **Journal-to-Note Bidirectional Linking** (Core Rule #7): every note gets a `journal` YAML property linking to the daily journal entry that recorded its creation/change, creating bidirectional navigation between notes and their temporal context.
- **Raw Sources Archive** (`sources/` directory): immutable archive for original documents. Inbox processing now copies originals to `sources/` before transforming to `notes/`. Core Rule #8 in CLAUDE.md. `source-file` YAML property links processed notes back to their original.
- **LLM Navigation Index** (`build-index.sh` SessionStart hook): auto-generates `index.md` at vault root cataloging all notes by category with one-line summaries. Enables fast LLM navigation without glob/grep. Core Rule #9 in CLAUDE.md.
- **Wiki Lint** (`wiki-lint.sh` SessionStart hook): structural health-check detecting orphan notes (no inbound links) and stale in-progress notes (30+ days). CLAUDE.md documents additional LLM-driven semantic checks during reviews.
- **Query-to-Note Workflow** (CLAUDE.md section): when an answer synthesizes 3+ sources or reveals non-obvious connections, offer to save as a permanent note with synthesis sources.
- **Cognitive Governance** (CLAUDE.md section + template updates): epistemic quality rules for Literature Notes (core claim + what it argues against), Permanent Notes (cross-subject linking), Weekly Reflections (tensions/contradictions, updated beliefs), and overlapping source ingestion (confirmed/challenged/new structure).
- **Deep Ingestion Cascade** (CLAUDE.md section): when a new note is created, update up to 5 related existing notes with cross-references. Scoped to avoid over-updating.
- Updated Literature Note, Permanent Note, and Weekly Summary templates with cognitive governance scaffolding

## [1.8.0] - 2026-04-19

### Added

- Journal reflections SessionStart hook (`.claude/hooks/journal-reflections.sh`): checks at session start whether yesterday's journal entry has empty Reflections or Key Decisions sections, prompts Claude to auto-generate substantive content from the "What I Did Today" log — cross-cutting insights, key learnings, connections between work items, strategic implications, and non-trivial decisions with reasoning
- Wired `journal-reflections.sh` into template's `.claude/settings.json` as a SessionStart hook
- Session Start Checklist item #6 in CLAUDE.md: documents the journal reflections auto-generation behavior

## [1.7.0] - 2026-03-30

### Added

- "References in Notes" rule in root `CLAUDE.md` and `notes/CLAUDE.md`: every external citation must include a `## References` section with clickable URLs in `[Title](URL) — summary` format

## [1.6.0] - 2026-03-30

### Added

- Uncommitted changes SessionEnd hook (`.claude/hooks/uncommitted-changes.sh`): warns at session end if there are staged, modified, or untracked files not yet committed
- Wired `uncommitted-changes.sh` into template's `.claude/settings.json` as a SessionEnd hook

## [1.5.0] - 2026-03-30

### Added

- Review overdue SessionStart hook (`.claude/hooks/review-overdue.sh`): checks at session start whether weekly or monthly journal reviews are overdue, prompts creation if missing. Self-healing — catches missed Sundays on Monday/Tuesday/etc.
- Wired `review-overdue.sh` into template's `.claude/settings.json` as a SessionStart hook

## [1.4.0] - 2026-03-28

### Added

- Journal reminder hook (`.claude/hooks/journal-reminder.sh`): PostToolUse hook that prompts Claude to update today's journal whenever a note in `notes/` is created or modified via Write or Edit
- `.claude/settings.json` with PostToolUse hook wiring for Write and Edit matchers

## [1.3.0] - 2026-03-28

### Added

- `people` YAML property on Meeting, Task Item, and Project templates — separates person references from topical subjects
- `people` property documented in CLAUDE.md frontmatter convention with "subjects are topical only" guidance

### Changed

- Project template: `collaborators` property replaced with `people` for consistency across all note types
- Contact card template: Dataview query uses `contains(people, this.file.link)` instead of `contains(subjects, this.file.link)`
- CLAUDE.md: project management section references `people` instead of `collaborators`
- `cookiecutter.json`: `year` default now uses `{% now 'local', '%Y' %}` for dynamic current year instead of hardcoded value
- README: `year` variable table shows *(current year)* as default
- CONTRIBUTING.md: removed hardcoded year from example command

## [1.2.0] - 2026-03-27

### Added

- Post-generate hook (`hooks/post_gen_project.py`): auto-runs `git init`, creates today's journal entry, prints setup instructions
- Dataview Cheatsheet page with 10 ready-to-use queries (recent notes, orphans, overdue tasks, meetings this week, etc.)
- CSS snippets directory (`.obsidian/snippets/dataview-tables.css`) for Dataview table styling
- New cookiecutter variables: `extra_subjects` (comma-separated) and `enable_claude` (boolean)
- 3 new Obsidian Bases dashboards: Goals Board, Meetings This Week, Recently Modified (both `.md` and `.base`)
- Review Checklist page with weekly, monthly, and quarterly review checklists
- 3 sample notes (Example Literature Note, Example Project, Example Meeting) demonstrating proper frontmatter
- `.github/` directory: issue templates (bug report, feature request), PR template
- `CONTRIBUTING.md` with guidelines for adding templates and testing
- `Makefile` with `new-vault`, `test`, and `clean` targets

## [1.1.0] - 2026-03-27

### Added

- Auto-journal core rule: today's daily journal is automatically updated whenever a note is created or modified — no explicit request needed (CLAUDE.md Core Rule #6)

## [1.0.0] - 2026-03-26

### Added

- Initial cookiecutter template for Obsidian second brain vault
- `cookiecutter.json` with variables: `vault_name`, `author_name`, `year`
- 18 note templates (Literature Note, Meeting, Task Item, Project, Goal, Contact, etc.)
- 15 category container notes with Dataview queries
- 7 starter subject container notes (AI, Business, Psychology, Philosophy, Health, Productivity, Creativity)
- Dashboard pages: Project Board, Reading List, Contacts Board, AI Workflows, Claude Code Tutorial
- Obsidian Bases (`.base`) files for Project Board, Contacts Board, Reading List, and AI subject
- Obsidian plugin configuration (Dataview, Tasks, Templater, Full Calendar, Periodic Notes)
- Claude Code integration: CLAUDE.md files at root and subfolders, `.claude/settings.json` with session start hook, vault hygiene hook
- Journal directory scaffolding with year-based hierarchy (12 months + weekly + monthly)
- `_copy_without_render` protection for Obsidian Templater `{{title}}`/`{{date:...}}` syntax
