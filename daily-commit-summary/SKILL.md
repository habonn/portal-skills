---
name: daily-commit-summary
description: Generate daily task summaries by analyzing git commits. MUST include analyzed Tasks section.
---

# Daily Commit Summary Skill

Generate a daily task summary by analyzing git commits and rewriting them into clear, human-readable task descriptions.

## When to Use This Skill

- "What did I do today?"
- "Summarize my commits"
- "Daily commit summary"
- "/daily-commit-summary"

## Configuration

`~/.daily-commit-summary.yaml`:

```yaml
repositories:
  - ~/projects/portal-api
  - ~/projects/portal-frontend
work_hours:
  start: "08:00"
  end: "18:00"
author: "your.email@example.com"
```

---

## ⚠️ MANDATORY OUTPUT REQUIREMENTS

**YOU MUST ALWAYS INCLUDE THE "✅ Tasks" SECTION.**

This section analyzes raw commits and rewrites them as clear task sentences. This is the PRIMARY purpose of this skill - not just listing commits.

---

## Required Output Format

```
📋 Daily Commit Summary
Date: [Day], [Month] [Date], [Year] (08:00 - now)

---

✅ Tasks (Analyzed from commits)

- [Analyzed task sentence 1]
- [Analyzed task sentence 2]

---

[Rest of commit details...]
```

---

## Example

**Input (raw commits):**
```
b0b0352 fix(notification-template): update mock Thai name to include month
551c5ef chore: update gitignore and mock data
f344b80 []
```

**Required Output:**

```
📋 Daily Commit Summary
Date: Saturday, March 21, 2026 (08:00 - now)

---

✅ Tasks (Analyzed from commits)

- Fixed notification template to correctly display Thai month names in mock data
- Updated project configuration files (gitignore) and mock data for testing

---

📊 Commits Detail

backoffice-portal-next (3 commits)

🔧 fix
- b0b0352 fix(notification-template): update mock Thai name to include month

🔨 chore
- 551c5ef chore: update gitignore and mock data

❓ other
- f344b80 []

Other Repositories

| Repository | Commits |
|------------|---------|
| portal-uam | 0 |
| portal-cube | 0 |
| portal-backend | 0 |
| portal-backend-cms | 0 |

Total: 3 commits today 🎉
```

---

## How to Analyze Commits → Tasks

| Raw Commit | Analyzed Task |
|------------|---------------|
| `fix(notification-template): update mock Thai name to include month` | Fixed notification template to correctly display Thai month names in mock data |
| `chore: update gitignore and mock data` | Updated project configuration files (gitignore) and mock data for testing |
| `feat(auth): add login page` | Implemented login page for user authentication |
| `refactor(api): simplify error handling` | Refactored API error handling for better maintainability |

### Task Writing Rules

1. **Start with action verb**: Fixed, Implemented, Updated, Refactored, Added
2. **Be descriptive**: Expand abbreviations, add context
3. **Human-readable**: Write for standup reports
4. **Group related**: Combine multiple commits about same feature
5. **Skip empty**: Don't include WIP/empty commits as tasks

### Grouping Example

**Multiple related commits:**
```
feat(auth): add login page
feat(auth): add password validation  
fix(auth): resolve token issue
```

**→ ONE analyzed task:**
```
- Implemented user authentication system with login page and password validation
```

---

## Commit Type → Task Language

| Type | Use These Words |
|------|-----------------|
| feat | Implemented, Added, Created |
| fix | Fixed, Resolved, Corrected |
| refactor | Refactored, Restructured, Improved |
| chore | Updated, Maintained, Cleaned up |
| docs | Updated documentation, Documented |
| test | Added tests for, Improved test coverage |
| perf | Optimized, Improved performance |
| style | Fixed styling, Improved formatting |

---

## Checklist Before Responding

Before showing output, verify:

- [ ] ✅ Tasks section is present at the TOP
- [ ] Tasks are analyzed/rewritten (not raw commit messages)
- [ ] Tasks use clear action verbs
- [ ] Related commits are grouped
- [ ] Empty/WIP commits excluded from tasks

**If the Tasks section is missing, the output is INCOMPLETE.**
