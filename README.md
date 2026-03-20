# Portal Skills

A collection of AI agent skills for Kiro IDE, designed for portal development workflows.

## Quick Start

```bash
curl -sL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh | bash
```

This opens an interactive menu to select which skills to install. Skills and hooks are installed together - ready to use immediately.

## Installation Options

**Interactive install (recommended):**
```bash
curl -sL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh | bash
```

**Install specific skill directly:**
```bash
curl -sL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh | bash -s -- commit
```

**Install multiple skills:**
```bash
curl -sL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh | bash -s -- commit other-skill
```

**Alternative - npx skills (no hooks):**
```bash
npx skills add https://github.com/habonn/portal-skills
```
Note: This installs all skills but without hooks. Use the curl method for full experience.

## Available Skills

| Skill | Description | Hook |
|-------|-------------|------|
| [commit](./commit/SKILL.md) | Smart git commit with Conventional Commits format | ✅ Smart Commit |

## Usage

After installation, you can use skills in two ways:

**Natural Language (Chat):**
- "commit my changes"
- "help me write a commit message"

**Hook Trigger (Button):**
1. Open Agent Hooks panel in Kiro
2. Find the hook (e.g., "Smart Commit")
3. Click the play button

Or use Command Palette: `Cmd+Shift+P` → "Run Hook" → select hook

## Project Structure

```
portal-skills/
├── README.md
├── install.sh          # Interactive installer (generates hooks)
├── commit/
│   └── SKILL.md        # Commit skill
└── [future-skill]/
    └── SKILL.md
```

## Adding New Skills

1. Create a folder with your skill name
2. Add `SKILL.md` following [Agent Skills Specification](https://agentskills.io/specification)
3. (Optional) Add hook in `hooks/[skill-name].kiro.hook`
4. Add skill name to `SKILLS` array in `install.sh`
5. Update this README

## License

MIT
