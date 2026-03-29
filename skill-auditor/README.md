# Skill Auditor

Auto-generate custom SKILL.md files by analyzing your repository's structure, dependencies, and architecture.

## Why Use This

**Problem:** Generic skill files don't understand your specific project. AI suggests wrong patterns.

**Solution:** Skill Auditor scans your repo and generates a custom skill file with:
- Your exact tech stack and versions
- Your architecture pattern (Clean, Hexagonal, MVC, etc.)
- Your project-specific rules

**Result:** AI gives correct suggestions for YOUR project, not generic advice.

## Installation

```bash
# In your project directory
npx skills add habonn/portal-skills@skill-auditor
```

That's it! Now use `/skill-audit` in Kiro.

**Optional - Install hooks for auto-updates:**
```bash
curl -fsSL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh | bash -s -- skill-auditor
```

Hooks will prompt you to update skill file when dependencies or configs change.

## Usage

In Kiro:
```
/skill-audit
```

Or natural language:
```
audit my repo
analyze project
```

## What It Does

1. **Scans** dependency files (package.json, go.mod, etc.)
2. **Detects** architecture pattern from folder structure
3. **Analyzes** infrastructure (Docker, CI/CD, database)
4. **Generates** custom SKILL.md with project-specific rules
5. **Saves** to `.kiro/skills/[project-name]/SKILL.md`

## Example Output

For a Go project with Clean Architecture:

```markdown
## Tech Stack
- Go 1.22
- Chi router, sqlx

## Architecture Pattern
**Clean Architecture**

Rules:
- ✅ Keep business logic in domain layer
- ❌ Don't import infrastructure into domain

## Project-Specific Rules
- Use standard library where possible
- Return errors, don't panic
```

## Hooks

Automatically prompts to update skill file when:
- Dependencies change (package.json, go.mod)
- Config changes (.eslintrc, tsconfig.json)
- Infrastructure changes (Dockerfile, .gitlab-ci.yml)

## Multi-Repo Usage

```bash
# Project 1: Go service
cd ~/projects/payment-service
/skill-audit  # Generates Go + Clean Architecture skill

# Project 2: Payload CMS
cd ~/projects/company-portal
/skill-audit  # Generates Payload CMS skill

# AI adapts automatically when you switch projects
```

## Configuration (Optional)

Add `.skill-auditor.config.json` for custom rules:

```json
{
  "customRules": [
    "All API responses must include 'success' field"
  ]
}
```

## See Also

- [examples/](./examples/) - Example outputs
- [SKILL.md](./SKILL.md) - Full skill documentation

## License

MIT
