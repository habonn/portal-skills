---
name: daily-commit-summary
description: Generate daily task summaries from git commits across multiple repositories. Run at end of workday to create standup reports or timesheets.
---

# Daily Commit Summary Skill

Scan git commits across configured repositories and generate a simple daily task list for standup reports or timesheets.

## When to Use This Skill

Use this skill when the user:

- Asks "what did I do today?"
- Wants a summary of their commits
- Needs to write a standup report
- Asks to "summarize my work"
- Wants to generate a daily task list from commits

## Configuration

Create a config file at `~/.daily-commit-summary.yaml` with your repo paths:

```yaml
# Repositories to scan
repositories:
  - ~/projects/portal-api
  - ~/projects/portal-frontend
  - ~/projects/portal-uam

# Work hours (optional, default 08:00-18:00)
work_hours:
  start: "08:00"
  end: "18:00"

# Your git author email (optional, to filter only your commits)
author: "your.email@example.com"
```

## How to Use

Once configured, just ask:

- "What did I do today?" or "/daily-commit-summary"
- Kiro reads your config and scans ALL repos in one command

## Output Format

Kiro generates a simple task list from commit messages:

### Example 1: Single commit

```
📋 Daily Commit Summary - March 21, 2026 (Saturday)

Tasks
- update gitignore and mock data

---
Total: 1 commit across 5 repositories
```

### Example 2: Multiple commits

```
📋 Daily Commit Summary - March 21, 2026 (Saturday)

Tasks
- add notification preview component
- implement user preference settings
- resolve shadow issue in notification preview
- update gitignore and mock data
- add API endpoint for notification settings
- clean up legacy gateway configuration

---
Total: 6 commits across 5 repositories
```

### Example 3: With repository grouping (optional)

```
📋 Daily Commit Summary - March 21, 2026 (Saturday)

Tasks

backoffice-portal-next:
- add notification preview component
- implement user preference settings
- resolve shadow issue in notification preview
- update gitignore and mock data

portal-backend:
- add API endpoint for notification settings
- clean up legacy gateway configuration

---
Total: 6 commits across 5 repositories
```

## Task Extraction Rules

Kiro extracts the task description from commit messages by:

1. Removing the conventional commit prefix (feat:, fix:, chore:, etc.)
2. Removing ticket references (PROJ-123, #456)
3. Keeping the clean task description

| Commit Message | Extracted Task |
|----------------|----------------|
| `feat: add login page` | add login page |
| `fix(auth): resolve token issue #123` | resolve token issue |
| `chore: update gitignore and mock data` | update gitignore and mock data |
| `PORTAL-456 implement user settings` | implement user settings |

## Workflow Example

User: "/daily-commit-summary" (or "What did I do today?")

1. Kiro reads `~/.daily-commit-summary.yaml` config
2. Scans ALL configured repos for today's commits
3. Extracts task descriptions from commit messages
4. Displays a simple task list
5. Shows total commit count

## Tips

- Ask at end of workday to capture all commits
- Use clear commit messages for better task descriptions
- Provide multiple repo paths if you work across projects
- Ask Kiro to save the summary to a file if needed
