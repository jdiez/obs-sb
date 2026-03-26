---
categories:
  - "[[SOPs]]"
subjects:
  - "[[AI]]"
  - "[[Productivity]]"
status: published
type: sop
---

# Claude Code Tutorial — Working with Your Vault

This tutorial walks through how to use Claude Code as your AI-powered vault assistant. Claude Code reads the `CLAUDE.md` files in each folder, so it already understands the vault architecture from the first prompt.

## Setup

1. Open a terminal and navigate to your vault root:
   ```bash
   cd /path/to/your-vault
   ```
2. Launch Claude Code:
   ```bash
   claude
   ```
3. That's it. Claude Code reads `CLAUDE.md` automatically and understands the folder structure, properties system, and conventions.

### Automatic Inbox Processing on Startup

A session start hook is configured in `.claude/settings.json`. Every time you launch Claude Code in this vault, it automatically:

1. Checks `inbox/` for unprocessed files
2. Reads each file and determines the best category and subjects
3. Adds proper YAML frontmatter with `[[wikilink]]` properties
4. Moves processed files to `notes/` (or `journal/YYYY/MM/` for journal entries)
5. Reports what was processed

This means you can drop raw captures, quick notes, or unorganized files into `inbox/` at any time — from your phone, another app, or manually — and they'll be sorted automatically the next time you open Claude Code.

**To customize this behavior**, edit `.claude/settings.json`. The hook is a `SessionStart` event that injects a processing instruction into Claude's context. You can modify the prompt to change how files are categorized or add additional startup tasks.

---

## Workflow 1: Create a Note

Ask Claude Code to create any type of note. It will use the correct template and save it in the right place.

**Example prompts:**

```
Create a literature note titled "Thinking Fast and Slow" about the book by Daniel Kahneman.
Add subjects AI and Psychology.
```

```
Create a new project note for "Website Redesign" with subjects Business and Creativity.
```

```
Create a permanent note titled "The Compound Effect of Writing" about how daily writing builds expertise over time.
```

**What happens:** Claude creates the file in `notes/`, applies the matching template, fills in the YAML frontmatter with the correct category and subjects, and adds any content you described.

---

## Workflow 2: Process Your Inbox

Drop raw files, quick captures, or unorganized notes into `inbox/`. Then ask Claude to sort them.

**Prompt:**

```
Process my inbox. For each file in inbox/, determine the best category and subjects,
add proper YAML frontmatter, and move it to notes/. Show me what you did for each file.
```

**What happens:** Claude reads each file, figures out what type of note it is, assigns categories and subjects as `[[wikilinks]]`, and moves it to `notes/` (or `journal/YYYY/MM/` if it's a journal entry). Your inbox ends up empty.

---

## Workflow 3: Bulk Update Properties

When you realize a bunch of notes should share a subject or need a property change, let Claude handle it in seconds.

**Example prompts:**

```
Find all notes that mention "GPT" or "LLM" and make sure they have the subject [[AI]].
Show me which files were updated.
```

```
Change the status of all newsletter notes currently set to "idea" to "in-progress".
```

```
Add the subject [[Psychology]] to every literature note that mentions "cognitive bias",
"mental model", or "heuristic".
```

---

## Workflow 4: Write Content From Your Knowledge

Claude doesn't just write generic content — it reads YOUR notes and writes in YOUR voice.

**Prompt:**

```
Write a newsletter about the intersection of AI and creativity.
First, read my previous newsletters to match my voice and tone.
Then search my vault for relevant notes on these subjects.
Use MY sources and ideas, not generic AI knowledge.
Set the status to "ready" when done.
```

---

## Workflow 5: Create a New Category

When you need a new type of note that doesn't exist yet.

**Prompt:**

```
Create a new category called "Podcasts":
1. Create the container note in categories/ with a Dataview query
2. Create a template in system/templates/ with the right YAML frontmatter
```

---

## Workflow 6: Create a New Subject

**Prompt:**

```
Create a new subject called "Finance" with a Dataview query that shows all notes tagged with it.
```

---

## Workflow 7: Generate a Weekly Summary

**Prompt:**

```
Read all my daily journal entries from this past week.
Create a weekly summary in journal/YYYY/weekly/ using the Weekly Summary template.
Highlight key accomplishments, challenges, and learnings.
```

---

## Workflow 8: Generate a Monthly Summary

**Prompt:**

```
Read all weekly summaries from this past month.
Create a monthly summary in journal/YYYY/monthly/ using the Monthly Summary template.
Include an overview, goals progress, achievements, and priorities for next month.
```

---

## Workflow 9: Manage Projects

### Create a Project

```
Create a project note called "API Redesign" with subject Business.
Set priority to high and status to planning.
```

### Create Task Items

```
Create 3 task items for the "API Redesign" project:
1. "Define endpoint schema" - due next Friday, high priority
2. "Write integration tests" - due in 2 weeks, medium priority
3. "Update API documentation" - due in 2 weeks, low priority
```

### Link a Meeting

```
Create a meeting note for today's API Redesign kickoff.
Attendees: Alice, Bob, Carol. Link it to the API Redesign project.
```

---

## The Daily Workflow

### Morning
1. Open Obsidian, hit the Periodic Notes command — your journal entry is created
2. Jot down your plan for the day

### Throughout the Day
3. Capture ideas, meeting notes, or content drafts — use templates or drop raw files in `inbox/`
4. When you have a few minutes, ask Claude: *"Process my inbox"*

### Evening
5. Update your daily journal with what you did, decisions made, and reflections

### Weekly (Sunday or Monday)
7. Ask Claude to generate your weekly summary

### Monthly (Last day of month)
8. Ask Claude to generate your monthly summary

---

## Tips

- **Be specific in prompts.** "Create a literature note about X" works better than "make a note."
- **Reference your existing content.** "Read my previous newsletters" gives Claude context for better results.
- **Let Claude maintain properties.** Offload tagging and organizing entirely.
- **Add subjects generously.** A note can have as many subjects as relevant.
- **Grow the system.** Need a new category? A new subject? Ask Claude to create it.
