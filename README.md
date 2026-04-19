```
            ●       ●       ●
           ╱│╲     ╱│╲     ╱│╲
          ╱ │ ╲   ╱ │ ╲   ╱ │ ╲
         ●──●──●─●──●──●─●──●──●
          ╲ │ ╱   ╲ │ ╱   ╲ │ ╱
           ╲│╱     ╲│╱     ╲│╱
            ●       ●       ●
           ╱│╲     ╱│╲     ╱│╲
          ╱ │ ╲   ╱ │ ╲   ╱ │ ╲
         ●──●──●─●──●──●─●──●──●

       ┌──────────────────────────┐
       │  obs-sb                   │
       │  Obsidian · Second Brain  │
       │  Cookiecutter Template    │
       └──────────────────────────┘
```

# Obsidian Second Brain — Cookiecutter Template

A [cookiecutter](https://cookiecutter.readthedocs.io/) template for generating an Obsidian vault organized as a second brain using the **Properties** pattern.

## What You Get

- **18 note templates** (Literature Notes, Projects, Tasks, Meetings, Goals, Contacts, and more)
- **16 category containers** with Dataview queries
- **7 starter subject containers** (AI, Business, Psychology, Philosophy, Health, Productivity, Creativity) + add your own via `extra_subjects`
- **Dashboard pages** (Project Board, Reading List, Contacts Board, Goals Board, Meetings This Week, Recently Modified) in both Dataview and Bases formats
- **Dataview Cheatsheet** with 10 ready-to-use queries (recent notes, orphan notes, overdue tasks, and more)
- **Review Checklist** for weekly, monthly, and quarterly reviews
- **Claude Code integration** (optional) with CLAUDE.md context files, automatic inbox processing hooks, auto-journaling on every note change, self-healing review reminders, auto-generated journal reflections, LLM navigation index, wiki lint (orphan/stale detection), raw sources archive, deep ingestion cascades, query-to-note workflow, and cognitive governance rules
- **3 sample notes** (Literature Note, Project, Meeting) showing proper frontmatter patterns
- **CSS snippets** for Dataview table styling
- **Journal scaffolding** with year-based hierarchy (daily, weekly, monthly)
- **Full Calendar support** for meetings and dated tasks
- **Post-generate hook** that initializes git, creates today's journal entry, and prints setup instructions
- **Obsidian plugin configuration** pre-configured for Dataview, Tasks, Templater, Full Calendar, and Periodic Notes

## Usage

```bash
# From a local clone
cookiecutter /path/to/obs-sb

# From GitHub (once published)
# cookiecutter gh:azu-oncology-rd/obs-sb

# Quick test with defaults
make test
```

You'll be prompted for:

| Variable | Default | Description |
|----------|---------|-------------|
| `vault_name` | `my-second-brain` | Name of your vault folder |
| `author_name` | `Your Name` | Your name (used in README) |
| `year` | *(current year)* | Starting year for journal folder structure |
| `extra_subjects` | *(empty)* | Comma-separated subjects to generate (e.g., `Science, Engineering, Finance`) |
| `enable_claude` | `true` | Include Claude Code integration (`.claude/`, `CLAUDE.md`, `.claudeignore`) |

## After Generating

1. Open the generated folder in Obsidian
2. Go to Settings → Community Plugins → Turn on
3. Install and enable: **Dataview**, **Tasks**, **Templater**, **Full Calendar**, **Periodic Notes**
4. Enable the CSS snippet: Settings → Appearance → CSS Snippets → toggle `dataview-tables`
5. Start creating notes using the templates (`Cmd+T`)
6. Delete the `Example - *.md` notes in `notes/` once you've seen the pattern

For AI-assisted workflows, open a terminal in the vault root and run `claude`.

## Architecture

Notes are organized by YAML properties, not folder hierarchy. Every note lives flat in `notes/` and is tagged with categories (what type) and subjects (what topic). Dataview queries in container notes surface the right notes automatically.

See the generated `CLAUDE.md` for full architectural documentation.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding templates, categories, and dashboards.
