# Portal Skills

A collection of AI agent skills for Kiro IDE, designed for portal development workflows.

## Installation

Install all skills:
```bash
npx skills add https://github.com/habonn/portal-skills
```

Install a specific skill:
```bash
npx skills add https://github.com/habonn/portal-skills@commit
```

## Available Skills

| Skill | Description |
|-------|-------------|
| [commit](./commit/SKILL.md) | Smart git commit workflow with Conventional Commits format and AI-generated message suggestions |

## Usage with Kiro

After installation, skills are available in your `.kiro/skills/` directory. Activate them by asking Kiro:

- "commit my changes"
- "help me write a commit message"

## Development

### Adding a New Skill

1. Create a new folder with your skill name
2. Add a `SKILL.md` file following the [Agent Skills Specification](https://agentskills.io/specification)
3. Update this README with the new skill

### Skill Structure

```
portal-skills/
├── README.md
├── commit/
│   └── SKILL.md
└── [future-skill]/
    └── SKILL.md
```

## License

MIT
