# Categories

Container notes that answer: "What type of note is this?"

## How It Works

Each `.md` file here is a category container. It contains an embedded Obsidian Dataview query that shows all notes in the vault where this category is linked in the `categories` YAML property.

## Rules

- One container per note type (Newsletter, Literature Note, Project, etc.).
- To create a new category: create a `.md` file here with a Dataview query, then create a matching template in `system/templates/`.
- Notes reference categories via `[[wikilink]]` in their YAML frontmatter.
