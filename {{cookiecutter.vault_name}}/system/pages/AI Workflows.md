---
type: dashboard
---

# AI Workflows for Claude Code

Copy-paste these prompts into Claude Code (running from the vault root directory) to automate common vault operations.

---

## 1. Create a Note

```
Create a new [type] note titled "[title]" about [topic]. Use the matching template from system/templates/. Add appropriate subjects. Save it in notes/.
```

## 2. Process Inbox

```
Read every file in inbox/. For each file: determine the best category and subjects, add proper YAML frontmatter with [[wikilink]] properties, then move it to notes/. If it's a journal entry, move it to journal/YYYY/MM/ (year-based hierarchy) instead. Show me what you did for each file.
```

## 3. Bulk Update Properties

```
Find all notes in notes/ that mention "[topic]" and add "[[Subject Name]]" to their subjects property if it's not already there. Show me which files were updated.
```

## 4. Write Content From My Knowledge

```
Write a [newsletter/tweet/permanent note] about [topic]. First, read my previous [type] notes for voice and tone. Then search my vault for relevant notes on this topic. Use MY sources and ideas, not generic AI knowledge. Save as a new note with status "ready".
```

## 5. Create a New Category

```
Create a new category called "[Name]":
1. Create categories/[Name].md with a Dataview query filtering the categories property
2. Create system/templates/[Name].md with proper YAML frontmatter
```

## 6. Create a New Subject

```
Create a new subject called "[Name]":
1. Create subjects/[Name].md with a Dataview query filtering the subjects property
```

## 7. Generate Weekly Summary

```
Read all daily journal entries from journal/YYYY/MM/ for this past week. Create a weekly summary in journal/YYYY/weekly/ using the Weekly Summary template. Include highlights, accomplishments, challenges, and key learnings synthesized from the dailies.
```

## 8. Generate Monthly Summary

```
Read all weekly summaries from journal/YYYY/weekly/ for this past month. Create a monthly summary in journal/YYYY/monthly/ using the Monthly Summary template. Synthesize the month's highlights, achievements, lessons, and set priorities for next month.
```
