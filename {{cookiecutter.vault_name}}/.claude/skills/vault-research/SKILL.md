---
name: vault-research
description: Research a topic using existing vault notes as context, optionally appending external sources. Outputs governed notes with proper frontmatter. Use when researching a topic, comparing sources, or building synthesis from vault contents.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent, WebFetch
---

# Vault Research

Research a topic by querying existing vault knowledge, appending new sources, or initializing a new research context. Outputs vault-governed notes (proper frontmatter, flat in notes/, cross-referenced).

## Modes

The skill routes requests into one of three modes:

### Query Mode (default)

Answer a question from existing vault notes without ingesting new sources.

**Progressive drilldown retrieval:**
1. Read `index.yaml` first — scan titles and summaries for relevant notes
2. Read the most relevant note(s) identified from the index
3. Follow `[[wikilinks]]` in those notes to find deeper context
4. Only open additional notes if the answer isn't yet complete

**Output:** Direct answer with `[[wikilink]]` citations to source notes. If the synthesis meets the Query-to-Note threshold (3+ sources, non-obvious connection, original framework), offer to save as a Permanent Note.

### Append Mode

Add new external sources to the vault's knowledge on a topic.

**Trigger:** User provides URLs, papers, repos, or files to ingest.

**Steps:**
1. Fetch/read each source (use `defuddle` for web pages, Read for local files)
2. For each source, create a Literature Note in `notes/` with:
   - Proper YAML frontmatter (categories, subjects, status, type, source)
   - Core claim + what it argues against (Cognitive Governance)
   - Key ideas extracted
   - Open Questions section for unknowns surfaced
3. If sources overlap with existing notes, apply the overlap protocol:
   - **Confirmed:** What corroborates existing knowledge
   - **Challenged:** What contradicts or qualifies existing knowledge
   - **New:** What is genuinely novel
4. Run Deep Ingestion Cascade for cross-references
5. Update today's journal

### Init Mode

Start structured research on a new topic when no relevant notes exist.

**Trigger:** User asks to research a topic and vault has < 2 relevant notes.

**Steps:**
1. Search `index.yaml` to confirm the topic is underserved
2. Create a seed Permanent Note outlining:
   - What is known (from any existing notes)
   - What needs to be learned (Open Questions)
   - Suggested sources to investigate
3. Output the seed note path and next steps

## Conventions

- All output notes go in `notes/` — flat, no subfolders, no working-dir
- Every note gets proper frontmatter per vault-conventions
- Use existing categories and subjects — don't create new ones without checking
- Comparisons between 2+ items → use the Comparison template
- Single-source analysis → use Literature Note template
- Cross-source synthesis → use Permanent Note template
- Always add `open-questions: true` to frontmatter if Open Questions section has content
- Update today's journal with what was researched

## Progressive Drilldown Pattern

```
User question
    │
    ▼
index.yaml (scan titles + summaries)
    │
    ├── Answer found in summaries? → respond with citations
    │
    ▼
Read top 2-3 relevant notes
    │
    ├── Answer complete? → respond with citations
    │
    ▼
Follow [[wikilinks]] to related notes
    │
    ▼
Synthesize answer from all sources
```

This pattern keeps context window usage minimal. Never load all notes — always start from the index and drill down only as needed.
