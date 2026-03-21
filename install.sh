#!/bin/bash

# Portal Skills Installer
# Interactive installer for Kiro IDE skills and hooks

set -e

REPO_URL="https://github.com/habonn/portal-skills"
TEMP_DIR=$(mktemp -d)

# Cleanup on exit
cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

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
    "prompt": "Generate my daily commit summary. Read the config from ~/.daily-commit-summary.yaml to get the list of repositories. For each repo, run 'git log' to get today's commits (from 08:00 to now). Categorize commits by type (feat, fix, docs, etc.) and generate a formatted Markdown summary grouped by project. If config file doesn't exist, ask me which repos to scan."
  }
}
EOF
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
      ;;
  esac
}

echo "🚀 Portal Skills Installer"
echo ""

# Clone repo
echo "Fetching skills..."
git clone --quiet "$REPO_URL" "$TEMP_DIR"

# Auto-detect available skills (folders with SKILL.md)
SKILLS=()
for dir in "$TEMP_DIR"/*/; do
  if [ -f "${dir}SKILL.md" ]; then
    skill_name=$(basename "$dir")
    SKILLS+=("$skill_name")
  fi
done

if [ ${#SKILLS[@]} -eq 0 ]; then
  echo "❌ No skills found in repository"
  exit 1
fi

# Check for specific skill argument
if [ -n "$1" ]; then
  SELECTED_SKILLS=("$@")
else
  # Check if running interactively (stdin is terminal)
  if [ -t 0 ]; then
    # Interactive selection
    echo ""
    echo "Available skills:"
    for i in "${!SKILLS[@]}"; do
      echo "  $((i+1)). ${SKILLS[$i]}"
    done
    echo "  a. All skills"
    echo ""
    read -p "Select skills to install (e.g., 1 2 or 'a' for all): " selection
    
    if [ "$selection" = "a" ] || [ "$selection" = "A" ]; then
      SELECTED_SKILLS=("${SKILLS[@]}")
    else
      SELECTED_SKILLS=()
      for num in $selection; do
        idx=$((num-1))
        if [ $idx -ge 0 ] && [ $idx -lt ${#SKILLS[@]} ]; then
          SELECTED_SKILLS+=("${SKILLS[$idx]}")
        fi
      done
    fi
  else
    # Non-interactive (piped) - show available skills and exit
    echo ""
    echo "Available skills:"
    for skill in "${SKILLS[@]}"; do
      echo "  - $skill"
    done
    echo ""
    echo "To install specific skills, run:"
    echo "  curl -fsSL $REPO_URL/raw/main/install.sh | bash -s -- commit e2e"
    echo ""
    echo "Or run interactively:"
    echo "  bash <(curl -fsSL $REPO_URL/raw/main/install.sh)"
    exit 0
  fi
fi

# Validate selection
if [ ${#SELECTED_SKILLS[@]} -eq 0 ]; then
  echo "❌ No skills selected"
  exit 1
fi

# Install selected skills
echo ""
for skill in "${SELECTED_SKILLS[@]}"; do
  if [ -d "$TEMP_DIR/$skill" ]; then
    echo "Installing $skill..."
    
    # Create skill directory and copy
    mkdir -p ".kiro/skills/$skill"
    cp "$TEMP_DIR/$skill/SKILL.md" ".kiro/skills/$skill/"
    
    # Create hook for this skill
    create_hook "$skill"
    
    echo "  ✓ Skill + Hook installed"
  else
    echo "⚠️  Skill '$skill' not found, skipping"
  fi
done

echo ""
echo "✅ Installation complete!"
echo ""
echo "Usage:"
echo "  • Chat: Ask Kiro naturally (e.g., 'commit my changes')"
echo "  • Hooks: Agent Hooks panel → click play button"
