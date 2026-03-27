# Changelog

All notable changes to this project will be documented in this file.

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
