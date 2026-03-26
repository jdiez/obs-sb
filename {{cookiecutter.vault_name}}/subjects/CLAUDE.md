# Subjects

Container notes that answer: "What is this note about?"

## How It Works

Each `.md` file here is a subject container. It contains an embedded Obsidian Dataview query that shows all notes in the vault where this subject is linked in the `subjects` YAML property.

## Rules

- One container per topic (AI, Business, Health, etc.).
- A note can have multiple subjects — it will appear in all relevant subject containers.
- To create a new subject: create a `.md` file here with a Dataview query filtering the `subjects` property.
