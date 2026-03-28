# Contributing to obs-sb

Thanks for your interest in improving the Obsidian Second Brain template!

## Quick Start

```bash
# Clone the repo
git clone https://github.com/azu-oncology-rd/obs-sb.git
cd obs-sb

# Test by generating a vault
cookiecutter . --no-input

# Or with custom variables
cookiecutter . vault_name=test-vault
```

## Guidelines

- **Templates** go in `{{cookiecutter.vault_name}}/system/templates/`
- **Categories** go in `{{cookiecutter.vault_name}}/categories/`
- **Subjects** go in `{{cookiecutter.vault_name}}/subjects/`
- **Dashboards** need both `.md` (Dataview) and `.base` (Obsidian Bases) files
- Every note needs proper YAML frontmatter — see `CLAUDE.md` for the convention

## Adding a New Note Template

1. Create the template in `system/templates/`
2. Add the matching category in `categories/` if it doesn't exist
3. Add a row to the Template Reference table in `CLAUDE.md`
4. Update `Existing Categories` in `CLAUDE.md`
5. Test: generate a vault and verify the template works in Obsidian

## Testing

After any change, run `cookiecutter . --no-input` and verify:

- The vault generates without errors
- Open in Obsidian — no plugin errors in console
- Dataview queries render (requires Dataview plugin installed)
- New/changed templates have valid YAML frontmatter

## Commit Messages

Use imperative mood: "Add meeting template", "Fix YAML frontmatter in Goal template".
