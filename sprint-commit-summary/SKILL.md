---
name: sprint-commit-summary
description: Generate sprint commit summaries by analyzing git commits across a 2-week sprint period. Supports date range input like "6-17" for quick sprint specification.
---

# Sprint Commit Summary Skill

Generate a sprint summary by analyzing git commits across a 2-week sprint period and transforming them into clear, human-readable task descriptions grouped by day.

## When to Use This Skill

- "Sprint summary"
- "What did I do this sprint?"
- "Sprint commit summary 6-17"
- "Summarize sprint from June 6 to June 17"
- "/sprint-commit-summary"

## Configuration

Uses the same config as daily-commit-summary:

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

## Sprint Schedule

- **Sprint duration**: 2 weeks (Monday to Friday × 2)
- **Demo day**: Every Friday (end of sprint)
- **Date input format**: `<start_day>-<end_day>` of current month, or full dates

### Date Input Examples

| User Input | Interpreted As |
|------------|---------------|
| `6-17` | June 6 → June 17 (current year, current month context) |
| `6/6-6/17` | June 6 → June 17 |
| `2026-06-06 to 2026-06-17` | June 6, 2026 → June 17, 2026 |
| `last sprint` | Previous 2-week sprint (calculate from current date, ending last Friday) |
| `this sprint` | Current sprint in progress |

### ⚠️ Date Parsing Rules

1. If user gives just `6-17`, infer the month from context (current month or ask if ambiguous)
2. If user gives `6/6-6/17`, parse as month/day
3. Always confirm the interpreted date range before running
4. Sprint should typically span **10 working days** (2 weeks)

---

## 🚨 CRITICAL: EXECUTION STEPS (MUST FOLLOW IN ORDER)

**STEP 0: Parse date range** → Interpret the user's sprint date input

- Confirm: "Sprint period: [Start Date] → [End Date] (10 working days)"
- If ambiguous, ask the user to clarify

**STEP 1: Read config** → Load `~/.daily-commit-summary.yaml` for repositories and author

**STEP 2: Collect commits for ENTIRE sprint** → Run git log for the full date range

### ⚠️ IMPORTANT: Git Command Format

**NEVER use `cd` to change directory before running git commands.**

✅ CORRECT (use git -C flag):
```bash
git -C /absolute/path/to/repo log --author="email" --since="YYYY-MM-DD 08:00" --until="YYYY-MM-DD 23:59" --pretty=format:"%ad | %h %s" --date=format:"%Y-%m-%d %a" 2>/dev/null || echo "REPO_NOT_FOUND"
```

**Always use `git -C <path>` to specify the repository path directly.**

**STEP 3: TRANSFORM commits to tasks** → This is MANDATORY!
- Take each commit message
- Rewrite it as a human-readable task sentence
- Use action verbs: Fixed, Implemented, Updated, etc.
- Group related commits into single tasks

**STEP 4: Output sprint summary** → Follow the required output format below

---

## ⚠️ MANDATORY OUTPUT REQUIREMENTS

1. **Sprint overview header** with date range and total stats
2. **Sprint Task Summary** section — ALL tasks transformed (not raw commits)
3. **Day-by-day breakdown** — commits grouped by date
4. **Repository breakdown** — commit counts per repo
5. **Sprint stats** — total commits, active days, most active day

---

## Required Output Format

```
🏃 Sprint Commit Summary
Sprint: [Start Date] → [End Date] (2 weeks)
Demo: Friday, [Demo Date]
Author: [author email]

---

## 📋 Sprint Task Summary

### Week 1 ([Start Date] → [Friday of Week 1])

- [Transformed task sentence 1]
- [Transformed task sentence 2]
- [Transformed task sentence 3]

### Week 2 ([Monday of Week 2] → [End Date])

- [Transformed task sentence 4]
- [Transformed task sentence 5]

---

## 📅 Day-by-Day Breakdown

### [Day 1 - Monday, Date]
**[repo-name]** (X commits)
- 🔧 abc1234 fix(scope): description
- ✨ def5678 feat(scope): description

### [Day 2 - Tuesday, Date]
**[repo-name]** (X commits)
- 🔨 ghi9012 chore(scope): description

### [Day 3 - Wednesday, Date]
_No commits_

... (continue for all working days)

---

## 📊 Sprint Statistics

| Metric | Value |
|--------|-------|
| Total Commits | XX |
| Active Days | X / 10 |
| Most Active Day | [Day, Date] (XX commits) |
| Top Repository | [repo-name] (XX commits) |

### Commits by Repository

| Repository | Commits |
|------------|---------|
| repo-1 | XX |
| repo-2 | XX |
| repo-3 | 0 |

### Commits by Type

| Type | Count | Emoji |
|------|-------|-------|
| feat | XX | ✨ |
| fix | XX | 🔧 |
| chore | XX | 🔨 |
| refactor | XX | ♻️ |
| docs | XX | 📝 |
| test | XX | 🧪 |
| style | XX | 💄 |
| perf | XX | ⚡ |
| build | XX | 📦 |
| ci | XX | 🔄 |

---

Total: XX commits across X repositories in 2-week sprint 🎉
```

---

## 🔄 TRANSFORMATION RULES

Reference: Uses Conventional Commits format from #[[file:commit/SKILL.md]]

Parse commits using Conventional Commits format: `<type>(<scope>): <description>`

For EACH commit, transform it:

| Raw Commit | → | Transformed Task |
|------------|---|------------------|
| `feat(auth): add login with Google` | → | Implemented Google login authentication |
| `fix(cart): resolve quantity update issue` | → | Fixed cart quantity update issue |
| `refactor(api): simplify error handling` | → | Refactored API error handling for better maintainability |

### Task Writing Rules

1. **Start with action verb**: Fixed, Implemented, Updated, Refactored, Added
2. **Be descriptive**: Expand abbreviations, add context
3. **Human-readable**: Write for sprint review/demo presentations
4. **Group related**: Combine multiple commits about same feature into ONE task
5. **Skip empty**: Don't include WIP/empty commits like `[]` as tasks
6. **Week grouping**: Separate tasks by Week 1 and Week 2

### Sprint Grouping Example

**Multiple related commits across days:**
```
Mon: feat(auth): add login page
Tue: feat(auth): add password validation
Wed: fix(auth): resolve token issue
Thu: test(auth): add login unit tests
```

**→ ONE sprint task:**
```
- Implemented complete user authentication system with login page, password validation, and unit tests
```

---

## Commit Type → Emoji Mapping

| Type | Emoji | Task Action Words |
|------|-------|-------------------|
| `feat` | ✨ | Implemented, Added, Created |
| `fix` | 🔧 | Fixed, Resolved, Corrected |
| `docs` | 📝 | Updated documentation, Documented |
| `style` | 💄 | Fixed styling, Improved formatting |
| `refactor` | ♻️ | Refactored, Restructured, Improved |
| `perf` | ⚡ | Optimized, Improved performance |
| `test` | 🧪 | Added tests for, Improved test coverage |
| `build` | 📦 | Updated build, Upgraded dependencies |
| `ci` | 🔄 | Updated CI/CD, Configured pipeline |
| `chore` | 🔨 | Updated, Maintained, Cleaned up |
| `revert` | ⏪ | Reverted, Rolled back |

---

## Checklist Before Responding

Before showing output, verify:

- [ ] Date range is confirmed with user
- [ ] "Sprint Task Summary" section is present with Week 1 / Week 2 grouping
- [ ] Tasks are TRANSFORMED (not raw commit messages)
- [ ] Tasks use clear action verbs
- [ ] Related commits across days are grouped into single tasks
- [ ] Day-by-day breakdown shows all 10 working days (even if no commits)
- [ ] Sprint statistics table is included
- [ ] Repository breakdown is included
- [ ] Empty/WIP commits like `[]` are excluded from tasks

---

## Example Interaction

**User**: "sprint summary 6-17"

**Agent**:
1. Parse → Sprint: June 6 → June 17, 2026
2. Confirm → "Sprint period: Friday, June 6 → Wednesday, June 17 (10 working days). Proceeding..."
3. Read config → get repos and author
4. Run git log for each repo with `--since="2026-06-06 08:00" --until="2026-06-17 23:59"`
5. Transform commits → group by feature/area
6. Output full sprint summary

**User**: "last sprint"

**Agent**:
1. Calculate → Current date minus 2 weeks, find the Monday-Friday boundaries
2. Confirm → "Last sprint: May 26 → June 6, 2026. Proceeding..."
3. Continue with steps 3-6 above
