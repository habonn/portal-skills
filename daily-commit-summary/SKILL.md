---
name: daily-commit-summary
description: Generate daily task summaries from git commits across multiple repositories. Run at end of workday to create standup reports or timesheets.
---

# Daily Commit Summary Skill

Scan git commits across configured repositories and generate a daily task summary for standup reports or timesheets.

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

Or ask without config:

- "Summarize my commits"
- "Check commits across ~/projects/portal-api and ~/projects/portal-frontend"

Kiro will run git commands, analyze the commits, and generate a formatted summary.

## Output Format

Kiro generates a Markdown summary like this:

```markdown
# Daily Summary: 2024-01-15

**Period:** 08:00 - 18:00
**Total Commits:** 5 across 2 repositories

## Summary
Implemented user authentication and fixed cart bugs.

## Project: portal-api
**Commits:** 3

### Features
- Implemented OAuth2 login flow (AUTH-123)
- Added password reset endpoint

### Bug Fixes
- Fixed null pointer in user validation (#456)

## Project: portal-frontend
**Commits:** 2

### Features
- Added login page component

### Documentation
- Updated API integration docs
```

## Commit Categorization

Commits are automatically categorized based on Conventional Commits prefixes:

| Prefix | Category |
|--------|----------|
| `feat:`, `feature:` | Features |
| `fix:`, `bugfix:` | Bug Fixes |
| `refactor:` | Refactoring |
| `docs:`, `documentation:` | Documentation |
| `test:`, `tests:` | Testing |
| `chore:` | Chores |
| `style:` | Style |
| `perf:` | Performance |
| (other) | Other |

## Ticket Reference Extraction

Kiro extracts ticket references from commit messages:

- **Jira-style:** `PROJ-123`, `ABC-456`
- **GitHub issues:** `#123`, `#456`
- **Bracketed:** `[TICKET]`, `[WIP]`

## Workflow Example

User: "/daily-commit-summary" (or "What did I do today?")

1. Kiro reads `~/.daily-commit-summary.yaml` config
2. Scans ALL configured repos for today's commits
3. Analyzes and categorizes the commits
4. Displays a formatted summary
5. Offers to save to file if needed

User: "Summarize my commits for the standup"

1. Kiro scans commits from work start time to now
2. Groups by project and category
3. Formats output for easy copy/paste to standup notes

## Tips

- Ask at end of workday to capture all commits
- Provide multiple repo paths if you work across projects
- Ask Kiro to save the summary to a file if needed
