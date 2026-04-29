---
name: inbox-process
description: Process all files in inbox/ — classify, add YAML frontmatter with [[wikilink]] properties, copy originals to sources/, and move processed versions to notes/ (or journal/YYYY/MM/ for journal entries). Use when user wants to process inbox mid-session.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Inbox Processing

Process all unprocessed files in `inbox/` (excluding CLAUDE.md).

## Current State
- Inbox contents: !`ls inbox/ 2>/dev/null | grep -v CLAUDE.md`

## Steps

1. List all files in `inbox/` (excluding CLAUDE.md)
2. For each file:
   a. Read the file contents
   b. Copy the original to `sources/` (preserve immutable original)
   c. Determine the best category and subjects from existing vault taxonomy
   d. Add YAML frontmatter with `[[wikilink]]` properties, `source-file` linking back to `sources/`
   e. Move processed version to `notes/` (or `journal/YYYY/MM/` for journal entries)
   f. Update today's journal entry with what was processed
   g. Run the Deep Ingestion Cascade for cross-references
3. Rebuild index.md after all files are processed
4. Report what was processed

## Rules
- All knowledge notes go in `notes/` — flat, no subfolders
- Journal entries go in `journal/YYYY/MM/`
- Every note needs: categories, subjects, status, type, created, journal
- Categories and subjects use `[[wikilinks]]`
- Check existing categories and subjects before creating new ones
