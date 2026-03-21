# Portal Skills

A collection of AI agent skills for [Kiro IDE](https://kiro.dev), designed to enhance developer productivity with smart automation for commits, testing, and daily workflows.

## Quick Start

```bash
# Step 1: Install from skills registry (universal support for multiple AI agents)
npx skills add habonn/portal-skills

# Step 2: Install Kiro hooks
bash <(curl -fsSL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh)
```

### Install Specific Skills

```bash
# Install specific skills only
npx skills add habonn/portal-skills@commit
npx skills add habonn/portal-skills@e2e

# Then add Kiro hooks for selected skills
curl -fsSL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh | bash -s -- commit e2e
```

## Available Skills

| Skill | Description | Command |
|-------|-------------|---------|
| [commit](./commit/SKILL.md) | Smart git commits with Conventional Commits format | `/commit` or "commit my changes" |
| [e2e](./e2e/SKILL.md) | Generate Playwright E2E tests using Page Object Model | `/e2e create <module>` |
| [test-go](./test-go/SKILL.md) | Generate Go unit tests with 80%+ coverage | `/test-go create <file>` |
| [test-ts](./test-ts/SKILL.md) | Generate TypeScript/Vitest tests with 80%+ coverage | `/test-ts create <file>` |
| [daily-commit-summary](./daily-commit-summary/SKILL.md) | Generate daily task summaries from commits | `/daily-commit-summary` |

## Usage

After installation, use skills in Kiro by:

1. **Chat commands**: Type `/commit`, `/e2e create banner`, etc.
2. **Natural language**: Ask "commit my changes" or "create tests for user.go"
3. **Hooks panel**: Click the play button next to a skill hook

### Using File/Folder Context

Reference files directly in commands:

```
/test-ts create #File      → drag a file into chat
/e2e create #Folder        → reference a folder
```

## What Gets Installed

```
.kiro/
├── skills/
│   ├── commit/SKILL.md
│   ├── e2e/SKILL.md
│   ├── test-go/SKILL.md
│   ├── test-ts/SKILL.md
│   └── daily-commit-summary/SKILL.md
└── hooks/
    ├── commit.kiro.hook
    ├── e2e.kiro.hook
    ├── test-go.kiro.hook
    ├── test-ts.kiro.hook
    └── daily-commit-summary.kiro.hook
```

## Manual Installation

If you prefer manual setup:

1. Copy the desired `SKILL.md` files to `.kiro/skills/<skill-name>/`
2. Create hooks in `.kiro/hooks/` (see [install.sh](./install.sh) for hook definitions)

## Contributing

1. Fork this repository
2. Create a new skill folder with `SKILL.md`
3. Add hook definition in `install.sh`
4. Submit a pull request

## License

MIT
