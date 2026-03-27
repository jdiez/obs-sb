#!/usr/bin/env python3
"""Post-generate hook: initializes the new vault after cookiecutter renders it."""

import os
import shutil
import subprocess
from datetime import date

# ---------- remove .claude/ if disabled ----------
enable_claude = "{{ cookiecutter.enable_claude }}" == "True"
if not enable_claude:
    shutil.rmtree(".claude", ignore_errors=True)
    for f in ["CLAUDE.md", ".claudeignore"]:
        if os.path.exists(f):
            os.remove(f)

# ---------- generate extra subject files ----------
extra_subjects = "{{ cookiecutter.extra_subjects }}".strip()
if extra_subjects:
    for subj in [s.strip() for s in extra_subjects.split(",") if s.strip()]:
        filepath = os.path.join("subjects", f"{subj}.md")
        if not os.path.exists(filepath):
            with open(filepath, "w") as f:
                f.write(f"""---
type: subject
---

# {subj}

```dataview
TABLE status, categories
FROM "notes"
WHERE contains(subjects, [[{subj}]])
SORT file.name ASC
```
""")

# ---------- first daily journal entry ----------
today = date.today()
journal_dir = os.path.join("journal", str(today.year), f"{today.month:02d}")
os.makedirs(journal_dir, exist_ok=True)

journal_file = os.path.join(journal_dir, f"{today}.md")
if not os.path.exists(journal_file):
    with open(journal_file, "w") as f:
        f.write(f"""---
categories:
  - "[[Journal Entries]]"
subjects: []
status: complete
type: daily
date: {today}
---

# {today}

## What I Did Today

- Created this vault from the obs-sb template

## Key Decisions

-

## Reflections

## Tomorrow's Focus

-
""")

# ---------- git init ----------
subprocess.run(["git", "init", "-q"], check=True)
subprocess.run(["git", "add", "."], check=True)
subprocess.run(
    ["git", "commit", "-q", "-m", "Initial vault generated from obs-sb template"],
    check=True,
)

# ---------- welcome message ----------
vault_name = "{{ cookiecutter.vault_name }}"
claude_hint = ""
if enable_claude:
    claude_hint = f"""
For AI-assisted workflows:
  cd {vault_name} && claude"""

print(
    f"""
✅  Vault "{vault_name}" is ready!

Next steps:
  1. Open the folder in Obsidian
  2. Settings → Community Plugins → Turn on
  3. Install: Dataview, Tasks, Templater, Full Calendar, Periodic Notes
  4. Start creating notes with Cmd+T (templates){claude_hint}
"""
)
