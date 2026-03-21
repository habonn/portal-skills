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

## Output Format

Kiro MUST analyze commits and generate a **Tasks** section with meaningful summaries.

### Required Output Structure

```
📋 Daily Commit Summary — [Day], [Month] [Date], [Year]

## Tasks
- [Analyzed task 1]
- [Analyzed task 2]
- [Analyzed task 3]

---

## Commits Detail

[repository-name]

| Type | Count |
|------|-------|
| feat | X |
| fix | X |

Commits:
- `hash` **type(scope)**: message
- `hash` **type**: message

---

Total: X commits in Y repositories
```

### Example 1: Based on your actual commits

**Raw commits:**
```
b0b0352 fix(notification-template): update mock Thai name to include month
551c5ef chore: update gitignore and mock data
f344b80 [] (WIP/empty commit)
```

**Analyzed output:**
```
📋 Daily Commit Summary — Saturday, March 21, 2026

## Tasks
- Fixed notification template to display Thai month names correctly
- Updated project configuration and mock data

---

## Commits Detail

backoffice-portal-next

| Type | Count |
|------|-------|
| fix | 1 |
| chore | 1 |
| other | 1 |

Commits:
- `b0b0352` **fix(notification-template)**: update mock Thai name to include month
- `551c5ef` **chore**: update gitignore and mock data
- `f344b80` [] (WIP/empty commit)

Repositories with no commits today:
- portal-uam
- portal-cube
- portal-backend
- portal-backend-cms

---

Total: 3 commits in 1 active repository
```

### Example 2: Multiple related commits (grouped & summarized)

**Raw commits:**
```
a1b2c3d feat(notification): add preview component
e4f5g6h feat(notification): implement settings API
i7j8k9l fix(notification): resolve shadow issue
m1n2o3p style(notification): adjust card padding
```

**Analyzed output:**
```
📋 Daily Commit Summary — Saturday, March 21, 2026

## Tasks
- Implemented notification preview feature with settings API
- Fixed notification UI styling (shadow and padding issues)

---

## Commits Detail
...
```

### Example 3: Mixed work across repos

**Raw commits:**
```
# backoffice-portal-next
a1b2c3d feat(auth): add login page
e4f5g6h feat(auth): implement password reset

# portal-backend
m1n2o3p feat(auth): add OAuth2 endpoints
q4r5s6t refactor(auth): clean up middleware
```

**Analyzed output:**
```
📋 Daily Commit Summary — Saturday, March 21, 2026

## Tasks
- Implemented authentication system (login page, password reset, OAuth2 APIs)
- Refactored auth middleware for better maintainability

---

## Commits Detail
...
```

## Analysis Rules

Kiro analyzes commits by:

1. **Grouping related commits** - Commits about the same feature/area are combined
2. **Identifying the main work** - Focus on what was accomplished, not individual changes
3. **Summarizing intent** - Convert technical commits into business-readable tasks
4. **Removing noise** - Chore/style commits are summarized briefly or grouped

### Conventional Commits Integration

This skill understands Conventional Commits format (see `commit/SKILL.md`):

```
<type>(<scope>): <description>
```

#### Commit Types & Task Analysis

| Type | Description | Task Summary Style |
|------|-------------|-------------------|
| `feat` | New feature | "Implemented [feature]" / "Added [functionality]" |
| `fix` | Bug fix | "Fixed [issue]" / "Resolved [problem]" |
| `docs` | Documentation | "Updated documentation for [area]" |
| `style` | Code style | Grouped with related changes or "Fixed styling issues" |
| `refactor` | Code refactor | "Refactored [area] for [benefit]" |
| `perf` | Performance | "Improved performance of [area]" |
| `test` | Tests | "Added tests for [feature]" |
| `build` | Build/deps | "Updated build configuration" / "Upgraded dependencies" |
| `ci` | CI/CD | "Updated CI/CD pipeline" |
| `chore` | Maintenance | "Updated project configuration" |

#### Scope-Based Grouping

Commits with the same scope are grouped together:

```
feat(auth): add login page
feat(auth): add password reset
fix(auth): resolve token refresh issue
```
→ **Task:** "Implemented authentication system with login and password reset"

### Commit Analysis Examples

| Raw Commits | Analyzed Task |
|-------------|---------------|
| `chore: update gitignore and mock data` | Updated project configuration and test data |
| `feat(auth): add login page` + `feat(auth): add auth API` + `fix(auth): token issue` | Implemented user authentication system |
| `refactor(user): clean up service` + `perf(user): optimize queries` | Refactored user service for better performance |
| `docs(readme): update install` + `docs(api): add endpoints` | Updated project documentation |
| `fix(button): alignment` + `style(button): adjust padding` | Fixed button UI styling issues |

## Workflow Example

User: "/daily-commit-summary" (or "What did I do today?")

1. Kiro reads `~/.daily-commit-summary.yaml` config
2. Scans ALL configured repos for today's commits
3. **Analyzes and groups related commits**
4. **Generates meaningful task descriptions**
5. Displays a clean summary ready for standup

## Tips

- Ask at end of workday to capture all commits
- Related commits across repos will be grouped together
- Use conventional commit prefixes for better analysis
- Ask Kiro to adjust the summary if needed
