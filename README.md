# Portal Skills

A collection of AI agent skills for [Kiro IDE](https://kiro.dev), designed to enhance developer productivity with smart automation for commits, testing, and daily workflows.

## Quick Start

```bash
# Step 1: Install skills from registry (supports multiple AI agents)
npx skills add habonn/portal-skills

# Step 2: Install Kiro hooks (auto-detects installed skills)
curl -fsSL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh | bash
```

### Install Specific Skills Only

```bash
# Install only commit and e2e skills
npx skills add habonn/portal-skills@commit
npx skills add habonn/portal-skills@e2e

# Install Kiro hooks (auto-detects from .agents/skills/)
curl -fsSL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh | bash

# Or specify hooks manually
curl -fsSL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh | bash -s -- commit e2e
```

## Available Skills

| Skill | Description | Command |
|-------|-------------|---------|
| [commit](./commit/SKILL.md) | Smart git commits with Conventional Commits format | `/commit` or "commit my changes" |
| [code-review](./code-review/SKILL.md) | Automated code review for GitLab merge requests | `/code-review <MR-URL>` |
| [skill-auditor](./skill-auditor/SKILL.md) | 🔥 Auto-generate custom skill.md by analyzing repo structure | `/skill-audit` or "audit my repo" |
| [e2e](./e2e/SKILL.md) | Generate Playwright E2E tests using Page Object Model | `/e2e create <module>` |
| [test-go](./test-go/SKILL.md) | Generate Go unit tests with 80%+ coverage | `/test-go create <file>` |
| [test-ts](./test-ts/SKILL.md) | Generate TypeScript/Vitest tests with 80%+ coverage | `/test-ts create <file>` |
| [daily-commit-summary](./daily-commit-summary/SKILL.md) | Generate daily task summaries from commits | `/daily-commit-summary` |

### 🌟 Featured: Skill Auditor

The **skill-auditor** analyzes your repository and generates a customized skill file for your project.

**Why use it:**
- AI understands YOUR project (not generic patterns)
- Auto-detects tech stack, architecture, conventions
- Works across multiple repos with different stacks

**Install:**
```bash
npx skills add habonn/portal-skills@skill-auditor
```

**Use in Kiro:**
```
/skill-audit
```

See [skill-auditor/README.md](./skill-auditor/README.md) for details.

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
│   ├── code-review/
│   │   ├── SKILL.md
│   │   └── mcp-server/        # GitLab MCP server
│   ├── skill-auditor/
│   │   ├── SKILL.md
│   │   └── auditor-agent.ts   # Standalone auditor script
│   ├── e2e/SKILL.md
│   ├── test-go/SKILL.md
│   ├── test-ts/SKILL.md
│   └── daily-commit-summary/SKILL.md
└── hooks/
    ├── commit.kiro.hook
    ├── code-review.kiro.hook
    ├── skill-audit-manual.kiro.hook
    ├── skill-audit-on-dependency-change.kiro.hook
    ├── skill-audit-on-config-change.kiro.hook
    ├── skill-audit-on-infrastructure-change.kiro.hook
    ├── e2e.kiro.hook
    ├── test-go.kiro.hook
    ├── test-ts.kiro.hook
    └── daily-commit-summary.kiro.hook

~/.kiro/settings/mcp.json      # GitLab MCP server config (for code-review)
```

## Code Review Skill Setup

The `code-review` skill requires a GitLab personal access token. When you run `install.sh`, it will:

1. Prompt for your GitLab host (default: `gitlab.com`)
2. Prompt for your GitLab personal access token (`glpat-xxx`)
3. Build and configure the MCP server automatically

### Creating a GitLab Token

1. Go to GitLab → Settings → Access Tokens
2. Create a token with `read_api` scope
3. Copy the token (starts with `glpat-`)

### Usage

```bash
# In Kiro chat
/code-review https://gitlab.com/group/project/-/merge_requests/123

# Or natural language
review this MR: https://gitlab.com/group/project/-/merge_requests/123
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
