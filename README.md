# Skills For Real Engineers

My agent skills that I use every day to do real engineering - not vibe coding.

Developing real applications is hard. Approaches like GSD, BMAD, and Spec-Kit try to help by owning the process. But while doing so, they take away your control and make bugs in the process hard to resolve.

These skills are designed to be small, easy to adapt, and composable. They work with any model. They're based on real engineering experience. Hack around with them. Make them your own. Enjoy.

## Quickstart (30-second setup)

1. Run the skills.sh installer:

   ```
   npx skills@latest add habonn/portal-skills
   ```

2. Pick the skills you want, and which coding agents you want to install them on.

3. Bam - you're ready to go.

## Why These Skills Exist

I built these skills as a way to fix common failure modes I see with Claude Code, Kiro, Codex, and other coding agents.

### #1: The Agent Didn't Do What I Want

> "No-one knows exactly what they want"
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

The Problem. The most common failure mode in software development is misalignment. You think the dev knows what you want. Then you see what they've built - and you realize it didn't understand you at all.

This is just the same in the AI age. There is a communication gap between you and the agent. The fix for this is a grilling session - getting the agent to ask you detailed questions about what you're building.

The Fix is to use:

- [/grill-me](./grill-me/SKILL.md) - for non-code uses
- [/grill-with-docs](./grill-with-docs/SKILL.md) - same as /grill-me, but adds more goodies (see below)

These are my most popular skills. They help you align with the agent before you get started, and think deeply about the change you're making. Use them _every_ time you want to make a change.

### #2: The Agent Is Way Too Verbose

> "With a ubiquitous language, conversations among developers and expressions of the code are all derived from the same domain model."
>
> Eric Evans, [Domain-Driven-Design](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

The Problem: At the start of a project, devs and the people they're building the software for (the domain experts) are usually speaking different languages.

I felt the same tension with my agents. Agents are usually dropped into a project and asked to figure out the jargon as they go. So they use 20 words where 1 will do.

The Fix for this is a shared language. It's a document that helps agents decode the jargon used in the project.

This is built into [/grill-with-docs](./grill-with-docs/SKILL.md). It's a grilling session, but that helps you build a shared language with the AI, and document hard-to-explain decisions in ADR's.

It's hard to explain how powerful this is. It might be the single coolest technique in this repo. Try it, and see.

Or just go `/caveman` - ultra-compressed communication that cuts token usage ~75% while keeping full technical accuracy.

> [!TIP]
> A shared language has many other benefits than reducing verbosity:
> - Variables, functions and files are named consistently, using the shared language
> - As a result, the codebase is easier to navigate for the agent
> - The agent also spends fewer tokens on thinking, because it has access to a more concise language

### #3: The Code Doesn't Work

> "Always take small, deliberate steps. The rate of feedback is your speed limit. Never take on a task that's too big."
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

The Problem: Let's say that you and the agent are aligned on what to build. What happens when the agent still produces crap?

It's time to look at your feedback loops. Without feedback on how the code it produces actually runs, the agent will be flying blind.

The Fix: You need the usual tranche of feedback loops: static types, browser access, and automated tests.

For automated tests, a red-green-refactor loop is critical. This is where the agent writes a failing test first, then fixes the test. This helps give the agent a consistent level of feedback that results in far better code.

I've built a [/tdd](./tdd/SKILL.md) skill you can slot into any project. It encourages red-green-refactor and gives the agent plenty of guidance on what makes good and bad tests.

For debugging, I've also built a [/diagnose](./diagnose/SKILL.md) skill that wraps best debugging practices into a simple loop.

### #4: We Built A Ball Of Mud

> "Invest in the design of the system every day."
>
> Kent Beck, [Extreme Programming Explained](https://www.amazon.co.uk/Extreme-Programming-Explained-Embrace-Change/dp/0321278658)

> "The best modules are deep. They allow a lot of functionality to be accessed through a simple interface."
>
> John Ousterhout, [A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

The Problem: Most apps built with agents are complex and hard to change. Because agents can radically speed up coding, they also accelerate software entropy. Codebases get more complex at an unprecedented rate.

The Fix for this is a radical new approach to AI-powered development: caring about the design of the code.

[/zoom-out](./zoom-out/SKILL.md) tells the agent to explain code in the context of the whole system.

And crucially, [/improve-codebase-architecture](./improve-codebase-architecture/SKILL.md) helps you rescue a codebase that has become a ball of mud. I recommend running it on your codebase once every few days.

### #5: Bad Commit Messages

> "Any fool can write code that a computer can understand. Good programmers write code that humans can understand."
>
> Martin Fowler, [Refactoring](https://www.amazon.co.uk/Refactoring-Improving-Existing-Addison-Wesley-Signature/dp/0134757599)

The Problem: The agent dumps "update files" or "fix stuff" into your git history. Six months later, `git log` is useless.

The Fix is [/commit-msg](./commit-msg/SKILL.md). It analyzes your staged diff and generates a proper Conventional Commit message every time. One logical change per commit, imperative mood, scoped types.

### #6: You Forget What You Did

The Problem: Standup is in 5 minutes and you're scrolling through `git log` trying to remember what you shipped.

The Fix is [/daily-commit-summary](./daily-commit-summary/SKILL.md). It reads your commits across all configured repos, transforms them into human-readable tasks, and hands you a standup-ready summary.

For sprint demos, [/sprint-commit-summary](./sprint-commit-summary/SKILL.md) groups 2 weeks of work by week with day-by-day breakdown and statistics. Built for Friday demo prep.

### #7: AI Doesn't Understand Your Project

The Problem: The agent gives generic advice because it doesn't know your stack, architecture, or conventions. It suggests React patterns in your Go project.

The Fix is [/skill-auditor](./skill-auditor/SKILL.md). It scans your repo - deps, folder structure, infra, code style - and generates a custom SKILL.md so the AI actually understands your project. Run it after major refactors or dependency updates.

### Summary

Software engineering fundamentals matter more than ever. These skills are my best effort at condensing these fundamentals into repeatable practices, to help you ship the best apps of your career. Enjoy.

## Reference

### Engineering

Skills I use daily for code work.

- [grill-with-docs](./grill-with-docs/SKILL.md) — Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates `CONTEXT.md` and ADRs inline.
- [tdd](./tdd/SKILL.md) — Test-driven development with a red-green-refactor loop. Builds features or fixes bugs one vertical slice at a time.
- [diagnose](./diagnose/SKILL.md) — Disciplined diagnosis loop for hard bugs and performance regressions: reproduce → minimise → hypothesise → instrument → fix → regression-test.
- [improve-codebase-architecture](./improve-codebase-architecture/SKILL.md) — Find deepening opportunities in a codebase, informed by the domain language in `CONTEXT.md` and the decisions in `docs/adr/`.
- [zoom-out](./zoom-out/SKILL.md) — Tell the agent to zoom out and give broader context or a higher-level perspective on an unfamiliar section of code.
- [commit-msg](./commit-msg/SKILL.md) — Smart git commit workflow using Conventional Commits format with AI-generated commit message suggestions based on staged changes.
- [skill-auditor](./skill-auditor/SKILL.md) — Analyze your repository and generate a customized SKILL.md file so AI understands your project's architecture, tech stack, and conventions.

### Productivity

General workflow tools, not code-specific.

- [grill-me](./grill-me/SKILL.md) — Get relentlessly interviewed about a plan or design until every branch of the decision tree is resolved.
- [caveman](./caveman/SKILL.md) — Ultra-compressed communication mode. Cuts token usage ~75% by dropping filler while keeping full technical accuracy.
- [daily-commit-summary](./daily-commit-summary/SKILL.md) — Generate daily task summaries by analyzing git commits across all configured repos. Transforms raw commits into standup-ready task descriptions.
- [sprint-commit-summary](./sprint-commit-summary/SKILL.md) — Generate sprint commit summaries by analyzing git commits across a 2-week sprint period. Day-by-day breakdown and statistics for Friday demo prep.

## Installation

### Option 1: npx (recommended)

```
npx skills@latest add habonn/portal-skills
```

### Option 2: Kiro hooks

```bash
# After installing skills, install Kiro hooks
curl -fsSL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh | bash

# Or specify skills manually
curl -fsSL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh | bash -s -- grill-me tdd commit-msg
```

### Option 3: Manual

Copy the `SKILL.md` files you want into your agent's skill directory:

- **Kiro**: `.kiro/skills/<skill-name>/SKILL.md`
- **Claude Code**: `.claude/skills/<skill-name>/SKILL.md`
- **Copilot / Others**: `.agents/skills/<skill-name>/SKILL.md`

## Configuration

`daily-commit-summary` and `sprint-commit-summary` share a config file:

```yaml
# ~/.daily-commit-summary.yaml
repositories:
  - ~/projects/portal-api
  - ~/projects/portal-frontend
work_hours:
  start: "08:00"
  end: "18:00"
author: "your.email@example.com"
```

## Credits

Engineering skills (`grill-me`, `grill-with-docs`, `tdd`, `diagnose`, `improve-codebase-architecture`, `zoom-out`, `caveman`) are adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT License).

## License

MIT
