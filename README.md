# Obsidian Second Brain — Cookiecutter Template

A [cookiecutter](https://cookiecutter.readthedocs.io/) template for generating an Obsidian vault organized as a second brain using the **Properties** pattern.

## What You Get

- **18 note templates** (Literature Notes, Projects, Tasks, Meetings, Goals, Contacts, and more)
- **16 category containers** with Dataview queries
- **7 starter subject containers** (AI, Business, Psychology, Philosophy, Health, Productivity, Creativity)
- **Dashboard pages** (Project Board, Reading List, Contacts Board) in both Dataview and Bases formats
- **Claude Code integration** with CLAUDE.md context files, automatic inbox processing hooks, and auto-journaling on every note change
- **Journal scaffolding** with year-based hierarchy (daily, weekly, monthly)
- **Full Calendar support** for meetings and dated tasks
- **Obsidian plugin configuration** pre-configured for Dataview, Tasks, Templater, Full Calendar, and Periodic Notes

## Usage

```bash
# From a local clone
cookiecutter /path/to/obs-sb

# From GitHub (once published)
# cookiecutter gh:your-username/obs-sb
```

You'll be prompted for:

| Variable | Default | Description |
|----------|---------|-------------|
| `vault_name` | `my-second-brain` | Name of your vault folder |
| `author_name` | `Your Name` | Your name (used in README) |
| `year` | `2026` | Starting year for journal folder structure |

## After Generating

1. Open the generated folder in Obsidian
2. Go to Settings → Community Plugins → Turn on
3. Install and enable: **Dataview**, **Tasks**, **Templater**, **Full Calendar**, **Periodic Notes**
4. Start creating notes using the templates (`Cmd+T`)

For AI-assisted workflows, open a terminal in the vault root and run `claude`.

## Architecture

Notes are organized by YAML properties, not folder hierarchy. Every note lives flat in `notes/` and is tagged with categories (what type) and subjects (what topic). Dataview queries in container notes surface the right notes automatically.

See the generated `CLAUDE.md` for full architectural documentation.
