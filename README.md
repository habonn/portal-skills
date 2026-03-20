# Portal Skills

A collection of AI agent skills for Kiro IDE, designed for portal development workflows.

## Installation

```bash
# Step 1: Install skills
npx skills add https://github.com/habonn/portal-skills

# Step 2: Run setup script
curl -sL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh | bash
```

Or install a specific skill:

```bash
npx skills add https://github.com/habonn/portal-skills@commit
curl -sL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh | bash -s commit
```

## Available Skills

| Skill | Description |
|-------|-------------|
| [commit](./commit/SKILL.md) | Smart git commit workflow with Conventional Commits format |
| [e2e](./e2e/SKILL.md) | Create/update Playwright E2E tests using Page Object Model |
| [test-go](./test-go/SKILL.md) | Generate Go unit tests with table-driven patterns (80%+ coverage) |
| [test-ts](./test-ts/SKILL.md) | Generate TypeScript/Vitest unit tests with mocking (80%+ coverage) |

## License

MIT
