#!/bin/bash

# Skills for Real Engineers — Kiro Hooks Installer
# Installs Kiro hooks for skills already installed via `npx skills add`

set -e

create_hook() {
  local skill=$1
  mkdir -p .kiro/hooks

  case $skill in
    "grill-me")
      cat > .kiro/hooks/grill-me.kiro.hook << 'EOF'
{
  "name": "Grill Me",
  "version": "1.0.0",
  "description": "Get relentlessly interviewed about a plan or design until every decision is resolved",
  "when": {
    "type": "userTriggered"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer. Ask the questions one at a time. If a question can be answered by exploring the codebase, explore the codebase instead."
  }
}
EOF
      echo "  ✓ Hook installed: grill-me"
      ;;
    "grill-with-docs")
      cat > .kiro/hooks/grill-with-docs.kiro.hook << 'EOF'
{
  "name": "Grill With Docs",
  "version": "1.0.0",
  "description": "Grilling session that updates CONTEXT.md and ADRs as decisions crystallize",
  "when": {
    "type": "userTriggered"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies one-by-one. For each question, provide your recommended answer. Ask one at a time. Challenge against the glossary in CONTEXT.md. Sharpen fuzzy language. Cross-reference with code. Update CONTEXT.md inline when terms are resolved. Offer ADRs sparingly — only when hard to reverse, surprising without context, and the result of a real trade-off."
  }
}
EOF
      echo "  ✓ Hook installed: grill-with-docs"
      ;;
    "caveman")
      cat > .kiro/hooks/caveman.kiro.hook << 'EOF'
{
  "name": "Caveman Mode",
  "version": "1.0.0",
  "description": "Ultra-compressed communication — cuts token usage ~75%",
  "when": {
    "type": "userTriggered"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Activate caveman mode. Respond terse like smart caveman. Drop articles, filler, pleasantries, hedging. Fragments OK. Short synonyms. Abbreviate common terms (DB/auth/config/req/res/fn/impl). Use arrows for causality. Technical terms stay exact. Code blocks unchanged. Stay active every response until user says 'stop caveman' or 'normal mode'. Exception: drop caveman temporarily for security warnings and irreversible action confirmations."
  }
}
EOF
      echo "  ✓ Hook installed: caveman"
      ;;
    "tdd")
      cat > .kiro/hooks/tdd.kiro.hook << 'EOF'
{
  "name": "TDD",
  "version": "1.0.0",
  "description": "Test-driven development with red-green-refactor loop",
  "when": {
    "type": "userTriggered"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Help me build this feature using TDD. Follow the red-green-refactor loop with vertical slices — one test at a time, not all tests first. Before writing code: confirm what interface changes are needed, which behaviors to test, and get my approval. Then: write ONE failing test (RED), write minimal code to pass (GREEN), repeat. After all tests pass, look for refactor candidates. Tests should verify behavior through public interfaces, not implementation details."
  }
}
EOF
      echo "  ✓ Hook installed: tdd"
      ;;
    "diagnose")
      cat > .kiro/hooks/diagnose.kiro.hook << 'EOF'
{
  "name": "Diagnose",
  "version": "1.0.0",
  "description": "Disciplined diagnosis loop for hard bugs and performance regressions",
  "when": {
    "type": "userTriggered"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Help me diagnose this bug using a disciplined loop. Phase 1: Build a feedback loop (failing test, curl script, headless browser, etc.) — spend disproportionate effort here. Phase 2: Reproduce the bug. Phase 3: Generate 3-5 ranked hypotheses before testing any. Phase 4: Instrument — one variable at a time, tag debug logs with [DEBUG-xxxx]. Phase 5: Fix + regression test. Phase 6: Cleanup — remove debug instrumentation, state the root cause in the commit message."
  }
}
EOF
      echo "  ✓ Hook installed: diagnose"
      ;;
    "improve-codebase-architecture")
      cat > .kiro/hooks/improve-codebase-architecture.kiro.hook << 'EOF'
{
  "name": "Improve Codebase Architecture",
  "version": "1.0.0",
  "description": "Find deepening opportunities — turn shallow modules into deep ones",
  "when": {
    "type": "userTriggered"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Explore this codebase and surface architectural friction. Look for shallow modules (interface nearly as complex as implementation), tightly-coupled modules leaking across seams, and untested code. Apply the deletion test: would deleting a module concentrate complexity or just move it? Present a numbered list of deepening opportunities with files, problem, solution, and benefits. Use CONTEXT.md vocabulary if available. Ask me which candidate to explore before proposing interfaces."
  }
}
EOF
      echo "  ✓ Hook installed: improve-codebase-architecture"
      ;;
    "zoom-out")
      cat > .kiro/hooks/zoom-out.kiro.hook << 'EOF'
{
  "name": "Zoom Out",
  "version": "1.0.0",
  "description": "Get a high-level map of modules and callers in unfamiliar code",
  "when": {
    "type": "userTriggered"
  },
  "then": {
    "type": "askAgent",
    "prompt": "I don't know this area of code well. Go up a layer of abstraction. Give me a map of all the relevant modules and callers, using the project's domain glossary vocabulary if CONTEXT.md exists."
  }
}
EOF
      echo "  ✓ Hook installed: zoom-out"
      ;;
    "commit-msg")
      cat > .kiro/hooks/commit-msg.kiro.hook << 'EOF'
{
  "name": "Smart Commit",
  "version": "1.0.0",
  "description": "Analyze staged changes and generate conventional commit message",
  "when": {
    "type": "userTriggered"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Analyze my staged git changes and help me create a commit following Conventional Commits format. Check git status, review the diff, suggest an appropriate commit message, and ask for confirmation before committing."
  }
}
EOF
      echo "  ✓ Hook installed: commit-msg"
      ;;
    "daily-commit-summary")
      cat > .kiro/hooks/daily-commit-summary.kiro.hook << 'EOF'
{
  "name": "Daily Commit Summary",
  "version": "1.0.0",
  "description": "Generate daily task summary from commits across all configured repos",
  "when": {
    "type": "userTriggered"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Generate my daily commit summary following the daily-commit-summary skill. CRITICAL STEPS: 1) Read config from ~/.daily-commit-summary.yaml to get repositories. 2) Run 'git log' for each repo to get today's commits (08:00 to now). 3) TRANSFORM each commit into a human-readable task using Conventional Commits mapping (feat→Implemented, fix→Fixed, refactor→Refactored, etc.). 4) Output MUST include 'Summary Task Daily' section at the TOP with transformed tasks, then show commit details below. Skip empty commits like []. If config doesn't exist, ask which repos to scan."
  }
}
EOF
      echo "  ✓ Hook installed: daily-commit-summary"
      ;;
    "sprint-commit-summary")
      cat > .kiro/hooks/sprint-commit-summary.kiro.hook << 'EOF'
{
  "name": "Sprint Commit Summary",
  "version": "1.0.0",
  "description": "Generate a 2-week sprint commit summary with transformed tasks, day-by-day breakdown, and sprint statistics",
  "when": {
    "type": "userTriggered"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Generate a sprint commit summary using the sprint-commit-summary skill. Ask the user for the sprint date range (e.g., '6-17' for June 6 to June 17) if not already provided. Follow all steps in the sprint-commit-summary/SKILL.md skill file: read config from ~/.daily-commit-summary.yaml, collect commits across all repositories for the sprint period, transform them into human-readable tasks, and output the full sprint summary with Week 1/Week 2 task grouping, day-by-day breakdown, and sprint statistics."
  }
}
EOF
      echo "  ✓ Hook installed: sprint-commit-summary"
      ;;
    "skill-auditor")
      cat > .kiro/hooks/skill-auditor.kiro.hook << 'EOF'
{
  "name": "Skill Auditor",
  "version": "1.0.0",
  "description": "Analyze repository and generate custom skill.md file",
  "when": {
    "type": "userTriggered"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Run /skill-audit to analyze the repository structure, dependencies, and architecture, then generate a custom skill.md file for this project."
  }
}
EOF
      echo "  ✓ Hook installed: skill-auditor"
      ;;
    *)
      echo "  ⚠️  No hook defined for: $skill"
      ;;
  esac
}

echo "🚀 Skills for Real Engineers — Kiro Hooks Installer"
echo ""

# Auto-detect skills installed by `npx skills add` in .agents/skills/
INSTALLED_SKILLS=()
if [ -d ".agents/skills" ]; then
  for dir in .agents/skills/*/; do
    if [ -d "$dir" ]; then
      skill_name=$(basename "$dir")
      INSTALLED_SKILLS+=("$skill_name")
    fi
  done
fi

# Check for specific skill argument
if [ -n "$1" ]; then
  SELECTED_SKILLS=("$@")
  echo "Installing hooks for specified skills..."
elif [ ${#INSTALLED_SKILLS[@]} -gt 0 ]; then
  SELECTED_SKILLS=("${INSTALLED_SKILLS[@]}")
  echo "Detected skills installed via 'npx skills add':"
  for skill in "${INSTALLED_SKILLS[@]}"; do
    echo "  - $skill"
  done
  echo ""
  echo "Installing Kiro hooks for these skills..."
else
  echo "❌ No skills detected."
  echo ""
  echo "First, install skills using:"
  echo "  npx skills@latest add habonn/portal-skills"
  echo ""
  echo "Or specify skills manually:"
  echo "  curl -fsSL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh | bash -s -- grill-me tdd commit-msg"
  exit 1
fi

echo ""
for skill in "${SELECTED_SKILLS[@]}"; do
  create_hook "$skill"
done

echo ""
echo "✅ Kiro hooks installed!"
echo ""
echo "Usage:"
echo "  • Chat: Ask Kiro naturally (e.g., 'grill me', 'commit my changes', 'debug this')"
echo "  • Hooks: Agent Hooks panel → click play button"
