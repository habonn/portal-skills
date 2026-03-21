#!/bin/bash

# Portal Skills - Kiro Hooks Installer
# Installs Kiro hooks for skills already installed via `npx skills add`

set -e

# Function to create hook for a skill
create_hook() {
  local skill=$1
  mkdir -p .kiro/hooks
  
  case $skill in
    "commit")
      cat > .kiro/hooks/commit.kiro.hook << 'EOF'
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
      echo "  ✓ Hook installed: commit"
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
    "e2e")
      cat > .kiro/hooks/e2e.kiro.hook << 'EOF'
{
  "name": "E2E Test Generator",
  "version": "1.0.0",
  "description": "Create or update Playwright E2E tests for a module",
  "when": {
    "type": "userTriggered"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Help me create or update E2E tests. First, ask which module I want to test. Then read existing e2e/pages/ files to understand the project's Page Object Model patterns. Create page objects and spec files following the same conventions."
  }
}
EOF
      echo "  ✓ Hook installed: e2e"
      ;;
    "test-go")
      cat > .kiro/hooks/test-go.kiro.hook << 'EOF'
{
  "name": "Go Test Generator",
  "version": "1.0.0",
  "description": "Generate Go unit tests with 80%+ coverage",
  "when": {
    "type": "userTriggered"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Help me create or update Go unit tests. Ask which file or folder I want to test. Analyze the source code to identify all functions, branches, and error paths. Generate table-driven tests that cover all execution paths for 80%+ coverage."
  }
}
EOF
      echo "  ✓ Hook installed: test-go"
      ;;
    "test-ts")
      cat > .kiro/hooks/test-ts.kiro.hook << 'EOF'
{
  "name": "TypeScript Test Generator",
  "version": "1.0.0",
  "description": "Generate TypeScript/Vitest unit tests with 80%+ coverage",
  "when": {
    "type": "userTriggered"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Help me create or update TypeScript unit tests using Vitest. Ask which file or folder I want to test. Analyze the source code to identify all functions, branches, and async paths. Generate tests that cover all execution paths for 80%+ coverage."
  }
}
EOF
      echo "  ✓ Hook installed: test-ts"
      ;;
    *)
      echo "  ⚠️  No hook defined for: $skill"
      ;;
  esac
}

echo "🚀 Portal Skills - Kiro Hooks Installer"
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
  # User specified skills manually
  SELECTED_SKILLS=("$@")
  echo "Installing hooks for specified skills..."
elif [ ${#INSTALLED_SKILLS[@]} -gt 0 ]; then
  # Auto-detected skills from .agents/skills/
  SELECTED_SKILLS=("${INSTALLED_SKILLS[@]}")
  echo "Detected skills installed via 'npx skills add':"
  for skill in "${INSTALLED_SKILLS[@]}"; do
    echo "  - $skill"
  done
  echo ""
  echo "Installing Kiro hooks for these skills..."
else
  # No skills found
  echo "❌ No skills detected."
  echo ""
  echo "First, install skills using:"
  echo "  npx skills add habonn/portal-skills"
  echo ""
  echo "Or specify skills manually:"
  echo "  curl -fsSL https://raw.githubusercontent.com/habonn/portal-skills/main/install.sh | bash -s -- commit e2e"
  exit 1
fi

# Install hooks for selected skills
echo ""
for skill in "${SELECTED_SKILLS[@]}"; do
  create_hook "$skill"
done

echo ""
echo "✅ Kiro hooks installed!"
echo ""
echo "Usage:"
echo "  • Chat: Ask Kiro naturally (e.g., 'commit my changes')"
echo "  • Hooks: Agent Hooks panel → click play button"
