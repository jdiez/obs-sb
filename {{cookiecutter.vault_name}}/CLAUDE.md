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
├── sources/        # Immutable originals — raw documents before processing
├── categories/     # Container notes: "what type of note is this?"
├── subjects/       # Container notes: "what is this note about?"
├── index.md        # Auto-generated vault catalog (human-readable) — DO NOT edit manually
├── index.yaml      # Auto-generated machine-readable catalog (agent drilldown) — DO NOT edit manually
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
6. **Auto-update today's journal on every note change.** Whenever a note is created or modified, append a brief entry to today's daily journal (`journal/YYYY/MM/YYYY-MM-DD.md`) summarizing what was added or changed. Use `[[wikilinks]]` to link to the note being referenced (e.g., `[[Note Title|display text]]`). Create the journal file from template if it doesn't exist. This happens automatically — no explicit request needed.
7. **Every note links to its journal entry.** When creating or modifying a note, add a `journal` property in the YAML frontmatter linking to today's daily journal: `journal: "[[YYYY-MM-DD]]"`. This creates a bidirectional link between the note and the journal entry that recorded its creation/change.
8. **Preserve originals in `sources/`.** When processing inbox items, copy the raw original to `sources/` before transforming. The processed note in `notes/` gets a `source-file` YAML property linking back: `source-file: "[[sources/Original Filename]]"`. Never modify files in `sources/`.
9. **Keep index.md current.** After creating or modifying a note, update the corresponding entry in `index.md` (add new entries, update summaries). Both `index.md` and `index.yaml` are fully rebuilt on session start and on every note write, but should be kept accurate during a session.

## YAML Frontmatter Convention

Every note must have this structure:

```yaml
---
categories:
  - "[[Category Name]]"
subjects:
  - "[[Subject Name]]"
people:
  - "[[Contact Name]]"
status: idea | in-progress | ready | published | archived (knowledge notes)
        backlog | planning | active | on-hold | done | archived (projects)
        todo | in-progress | done | blocked (task items)
type: note-type-slug
created: YYYY-MM-DD
---
```

- `categories` — links to files in `categories/` (note type: literature note, newsletter, etc.)
- `subjects` — links to files in `subjects/` (topic: AI, Business, etc.). **Subjects are topical only** — never put people here.
- `people` — links to contact notes in `notes/` (people involved: attendees, collaborators, etc.). Use `[[Contact Name]]` wikilinks.
- `status` — lifecycle stage
- `created` — date the note was created (auto-filled by Templater's `{% raw %}{{date:YYYY-MM-DD}}{% endraw %}`)
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
- **Processing inbox:** Read files in `inbox/`. First, copy the original to `sources/`. Then assign categories/subjects, add YAML frontmatter with `source-file` property, and move the processed version to `notes/`.
- **Bulk updates:** Update properties across multiple notes using Grep to find targets, then Edit.
- **Journal summaries:** Read daily entries from `journal/YYYY/MM/` for a date range, produce weekly/monthly summary.
- **Project management:** Projects, task items, and meetings are linked via `project` property. Projects use the `people` property — use `[[Contact Name]]` wikilinks to link relevant contacts. See `system/pages/Project Board.md` for the dashboard. Projects use lean statuses: `backlog` → `planning` → `active` → `on-hold` → `done` → `archived`.
- **Dashboards are dual-format:** Every new dashboard in `system/pages/` must be created as both a `.md` file (Dataview queries) and a `.base` file (Obsidian Bases). Both coexist — Dataview and Bases run in parallel.
- **Never modify `.obsidian/workspace.json`** — it changes with UI state.

## Plugins

- **Core:** Templates, Graph, Backlinks, Sync, Bases (`.base` files only)
- **Community (required):** dataview (powers all inline queries in category/subject pages), obsidian-tasks-plugin, templater-obsidian, obsidian-full-calendar (visual calendar from note dates), periodic-notes (year-based journal folders for daily/weekly/monthly)

## Agent Skills (`.claude/skills/`)

Installed from [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) (Agent Skills spec):

| Skill | Use When |
|-------|----------|
| `obsidian-markdown` | Creating/editing `.md` files — wikilinks, embeds, callouts, properties, block IDs |
| `obsidian-bases` | Creating/editing `.base` files — filters, formulas, views, summaries |
| `json-canvas` | Creating/editing `.canvas` files — nodes, edges, groups |
| `obsidian-cli` | Interacting with running Obsidian instance — read, search, plugin dev |
| `defuddle` | Extracting clean markdown from web pages (prefer over WebFetch for HTML) |

Custom vault skills (project-specific):

| Skill | Use When |
|-------|----------|
| `vault-conventions` | Frontmatter, wikilinks, naming, templates — vault-specific rules |
| `inbox-process` | Processing new items in `inbox/` |
| `weekly-review` | Generating weekly summaries |
| `vault-research` | Researching a topic from vault notes, ingesting sources, or building synthesis |

## Session Start Checklist

0. (Automatic) `index.md` and `index.yaml` are rebuilt from `notes/` frontmatter
1. Check `inbox/` for unprocessed notes
2. Surface today's calendar items (meetings, tasks with today's date)
3. Flag overdue tasks (due-date past, status not done)
4. If Sunday: prompt for weekly review
5. If 1st of month: prompt for monthly review
6. Generate previous day's journal reflections (if empty) — read "What I Did Today" from yesterday's journal entry and populate empty Reflections (cross-cutting insights, key learnings, connections between work items, strategic implications — use `###` subheadings per theme) and Key Decisions (non-trivial decisions with reasoning). Skip if yesterday's journal doesn't exist or sections are already populated.

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

## Query-to-Note Workflow

When answering a question that meets ANY of these criteria, offer to create a permanent note from the answer:
- Synthesizes information from **3 or more** existing notes
- Reveals a **non-obvious connection** between notes from different subjects
- Produces an **original framework, taxonomy, or comparison** not found in any single source
- Answers a question the user is likely to ask again

**How to offer:** After delivering the answer, append: *"This synthesis spans [N] sources and could be a useful permanent note. Want me to save it as `[Suggested Title]`?"*

**If accepted:** Create a note in `notes/` using the Permanent Note template. Set `subjects` from the source notes' subjects. Add a `## Synthesis Sources` section linking to each source note with `[[wikilinks]]`. Set `status: ready`.

## Cognitive Governance

Epistemic quality rules that ensure the vault accumulates genuine understanding, not just information.

### Literature Notes
- Must identify the **core claim** of the source AND **what it argues against** (the counterfactual or prior consensus it challenges). If the source doesn't argue against anything, state that explicitly.
- When ingesting a source that overlaps with existing notes, state explicitly: what is **confirmed**, what is **challenged**, and what is **new**.

### Permanent Notes
- Must link to **2 or more notes from different subjects**. A permanent note that only connects within one subject is probably still a literature note.
- The "Idea" section must be expressible in **one sentence**. If it takes a paragraph, it needs splitting.

### Weekly Reflections
- Must surface at least one **tension or contradiction** between notes or ideas encountered that week. If none exist, say so explicitly — but look harder first.
- Should identify one **belief that was updated** during the week and what updated it.

### Ingestion of Overlapping Sources
- When processing a new source that covers a topic already in the vault, structure the analysis as:
  1. **Confirmed:** What does this source corroborate from existing notes?
  2. **Challenged:** What does this source contradict or qualify?
  3. **New:** What information or perspective is genuinely novel?
- Link to the existing notes being confirmed/challenged using `[[wikilinks]]`.

## Machine-Readable Index (index.yaml)

Alongside `index.md`, the vault maintains `index.yaml` — a machine-readable catalog optimized for agent progressive drilldown retrieval. Agents should read `index.yaml` first (scan titles + summaries), then open only the notes needed to answer a question. This keeps context window usage minimal.

The file is auto-generated by `build-index.sh` at session start and on every note write. Never edit manually.

**Progressive drilldown pattern:** `index.yaml` → relevant note(s) → follow wikilinks → synthesize. Never load all notes at once.

## Open Questions

Notes can track unresolved research questions via an `## Open Questions` section. When a note has open questions, add `open-questions: true` to its frontmatter. The `system/pages/Open Questions.md` dashboard surfaces all notes with open questions via Dataview.

Use open questions to:
- Track unknowns surfaced during research
- Identify gaps that need future investigation
- Feed weekly review with research priorities

## Comparisons

For structured side-by-side analyses, use the Comparison template (`type: comparison`, category `[[Comparisons]]`). Comparisons differ from Permanent Notes in that they:
- Compare 2+ specific items (tools, frameworks, approaches)
- Use a dimensions table for systematic analysis
- Include a verdict/synthesis section with context-dependent recommendations
- Track the `compared-items` in YAML frontmatter

## Deep Ingestion Cascade

When a new note is created (not modified), perform a scoped cascade to update related existing notes:

### Trigger
- Fires after creating a new note in `notes/` (not journal entries, not inbox items).

### Cascade Steps
1. **Identify candidates:** Find notes in `index.md` that share **2 or more subjects** with the new note. If the new note has only 1 subject, find notes sharing that subject AND having a `summary` that overlaps thematically.
2. **Filter:** Only update notes with status `ready` or `in-progress`. Never touch `archived` notes. Maximum **5 notes** per cascade.
3. **For each candidate:**
   - Add a cross-reference in the candidate's `## Connections` or `## Related Notes` section: `- [[New Note Title]] — one-line reason for the link`
   - If the new note introduces a concept that the candidate discusses but doesn't name, add a brief mention.
   - Do NOT rewrite existing content. Only append cross-references.
4. **Update index.md** to reflect any summary changes.
5. **Journal the cascade:** In today's journal entry, note which notes were updated and why, under the new note's journal log.

### Limits
- Never cascade from a cascade (no recursive updates).
- If more than 5 candidates match, pick the 5 with the most subject overlap.
- If unsure whether a cross-reference is valuable, skip it. Err on the side of fewer, higher-quality links.

## Wiki Lint

Structural and semantic health-checks that run periodically to maintain vault integrity.

### Automatic Checks (SessionStart hook)
The `wiki-lint.sh` hook runs at session start and reports:
- **Orphan notes:** Notes with no inbound `[[wikilinks]]` from other notes (categories/subjects/index.md are excluded). Consider adding cross-references or archiving.
- **Stale in-progress:** Notes stuck at `status: in-progress` for 30+ days. Update status or add new content.

### Semantic Checks (LLM-driven, during reviews)
During weekly or monthly reviews, also check for:
- **Missing cross-references:** Notes sharing 2+ subjects but not linking to each other. Add cross-references where the connection is substantive.
- **Concept candidates:** Terms or ideas mentioned in 3+ notes that lack their own note or subject page. Offer to create a Permanent Note or subject container.
- **Contradictions:** Notes making incompatible claims about the same topic. Flag in the weekly review and create a resolution note if warranted.

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
| Comparison       | comparison        | Comparisons      | no        |
| General Note     | note              | (varies)         | no        |
| Daily Journal    | daily             | Journal Entries  | no        |
| Weekly Summary   | weekly            | Journal Entries  | no        |
| Monthly Summary  | monthly           | Journal Entries  | no        |

## Existing Categories

Comparisons, Contacts, Literature Notes, Meetings, Projects, Task Items, YouTube Videos, Newsletters, Permanent Notes, Authors, SOPs, AI Prompts, Tweets, Journal Entries, Goals, Reading List

## Existing Subjects

AI, Business, Psychology, Philosophy, Health, Productivity, Creativity

## File Naming

- Contacts: `Full Name.md` (e.g., `Diana Vega.md`). Use `aliases` in frontmatter for alternate names.
- Meetings: `Meeting - [Person/Group] - YYYY-MM-DD.md`
- Tasks: descriptive title, no date prefix
- Comparisons: descriptive title (e.g., `LangGraph vs CrewAI — Comparison for Multi-Agent Orchestration.md`)
- Literature notes: title of the source
- Journal daily: `YYYY-MM-DD.md` (handled by periodic-notes)
- Journal weekly: `YYYY-[W]WW.md`
- Journal monthly: `YYYY-MM.md`

## Table of Contents in Notes

- Every note with **5 or more `##` headings** must include a `## Table of Contents` section immediately after the H1 title.
- Use Obsidian wikilink heading syntax: `[[#Heading Name]]` — this is the only format that works for internal navigation in Obsidian.
- Use a numbered list for top-level sections (`##`), with tab-indented sub-items for subsections (`###`).
- The TOC heading names must match the actual heading text exactly (case-sensitive, including special characters).

Example:

```markdown
## Table of Contents

1. [[#Overview]]
2. [[#Architecture]]
	- [[#Components]]
	- [[#Data Flow]]
3. [[#References]]
```

## References in Notes

- When a note cites external sources (papers, articles, tools), include a `## References` section at the bottom.
- Every reference must include a clickable URL/link — never cite without a link.
- Format: `- [Title](URL) — one-line summary of relevance`

## Keeping This File Current

This CLAUDE.md is loaded every session — no hook needed. When creating a new category, subject, or template, update the corresponding list above in the same operation. Stale registries cause duplicates.

## Files to Ignore

- `.env` — gitignored, never commit secrets
- `.obsidian/workspace.json` — volatile UI state
- `system/attachments/` — binary files, keep out of diffs when possible
