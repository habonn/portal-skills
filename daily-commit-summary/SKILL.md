---
name: daily-commit-summary
description: Generate daily task summaries by analyzing git commits across multiple repositories. Kiro analyzes commit patterns and generates meaningful work descriptions.
---

# Daily Commit Summary Skill

Scan git commits across configured repositories, analyze them, and generate a meaningful daily task summary for standup reports or timesheets.

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

## CRITICAL: Output Format

**IMPORTANT: Kiro MUST ALWAYS generate a "Tasks" section FIRST by analyzing and rewriting commits into clear, human-readable sentences.**

The Tasks section is the PRIMARY output. It should:
1. Analyze all commits from the day
2. Rewrite technical commit messages into clear task descriptions
3. Group related commits into single tasks
4. Present as a consolidated daily task summary

### Required Output Structure

```
📋 Daily Commit Summary
Date: [Day], [Month] [Date], [Year] (08:00 - now)

---

## ✅ Tasks (Analyzed from commits)

- [Clear sentence describing what was accomplished]
- [Clear sentence describing what was accomplished]
- [Clear sentence describing what was accomplished]

---

## 📝 Commits Detail

🚀 [repository-name]

| Type | Commit | Hash | Time |
|------|--------|------|------|
| fix | description | hash | HH:MM |
| chore | description | hash | HH:MM |

📊 Summary by Type

| Type | Count |
|------|-------|
| fix | X |
| chore | X |
| Total | X |

📁 Repositories with No Activity Today
- repo-1
- repo-2

---

[Brief closing comment]
```

### Example: Your Actual Commits → Analyzed Tasks

**Raw commits from today:**
```
b0b0352 fix(notification-template): update mock Thai name to include month (20:30)
551c5ef chore: update gitignore and mock data (12:50)
f344b80 [] (WIP/empty commit)
```

**CORRECT Output with Tasks section:**

```
📋 Daily Commit Summary
Date: Saturday, March 21, 2026 (08:00 - now)

---

## ✅ Tasks (Analyzed from commits)

- Fixed notification template to correctly display Thai month names in mock data
- Updated project configuration files (gitignore) and mock data for testing

---

## 📝 Commits Detail

🚀 backoffice-portal-next

| Type | Commit | Hash | Time |
|------|--------|------|------|
| 🔧 fix | notification-template: update mock Thai name to include month | b0b0352 | 20:30 |
| 🔨 chore | update gitignore and mock data | 551c5ef | 12:50 |

Note: Commit f344b80 appears to have an empty/malformed message.

📊 Summary by Type

| Type | Count |
|------|-------|
| � fix | 1 |
| 🔨 chore | 1 |
| Total | 3 |

📁 Repositories with No Activity Today
- portal-uam
- portal-cube
- portal-backend
- portal-backend-cms

---

Looks like a light day focused on the backoffice-portal-next project with notification template fixes and housekeeping updates.
```

## Task Analysis Rules

**Kiro MUST analyze commits and rewrite them as clear task sentences:**

### How to Convert Commits → Tasks

| Commit Type | Raw Commit | Analyzed Task Sentence |
|-------------|------------|------------------------|
| fix | `fix(notification-template): update mock Thai name to include month` | Fixed notification template to correctly display Thai month names |
| chore | `chore: update gitignore and mock data` | Updated project configuration and mock data |
| feat | `feat(auth): add login page` | Implemented login page for user authentication |
| refactor | `refactor(api): simplify error handling` | Refactored API error handling for better maintainability |
| docs | `docs(readme): update installation steps` | Updated installation documentation in README |

### Grouping Related Commits

Multiple commits about the same feature should be combined into ONE task:

**Raw commits:**
```
feat(auth): add login page
feat(auth): add password validation
fix(auth): resolve token refresh issue
```

**Analyzed as ONE task:**
```
- Implemented user authentication with login page, password validation, and token refresh fix
```

### Task Writing Guidelines

1. **Start with action verb**: "Fixed", "Implemented", "Updated", "Refactored", "Added"
2. **Be specific**: Include what was changed and why if clear from commit
3. **Human-readable**: Write for standup reports, not for developers reading code
4. **Consolidate**: Group related work into single tasks
5. **Skip noise**: Empty commits or WIP can be noted but not listed as tasks

## Conventional Commits Integration

This skill understands Conventional Commits format (see `commit/SKILL.md`):

```
<type>(<scope>): <description>
```

### Commit Types → Task Language

| Type | Task Prefix |
|------|-------------|
| `feat` | "Implemented" / "Added" / "Created" |
| `fix` | "Fixed" / "Resolved" / "Corrected" |
| `docs` | "Updated documentation for" / "Documented" |
| `style` | "Improved styling" / "Fixed formatting" |
| `refactor` | "Refactored" / "Restructured" / "Improved" |
| `perf` | "Optimized" / "Improved performance of" |
| `test` | "Added tests for" / "Improved test coverage" |
| `build` | "Updated build configuration" / "Upgraded" |
| `ci` | "Updated CI/CD pipeline" |
| `chore` | "Updated" / "Maintained" / "Cleaned up" |

## Workflow

User: "/daily-commit-summary"

1. Read `~/.daily-commit-summary.yaml` config
2. Scan ALL configured repos for today's commits
3. **ANALYZE commits and generate Tasks section FIRST**
4. Show commit details below
5. Display summary

## Tips

- The Tasks section is for standup reports - make it readable
- Group related commits into single meaningful tasks
- Use clear action verbs
- Skip empty/WIP commits from tasks (but note them in details)
