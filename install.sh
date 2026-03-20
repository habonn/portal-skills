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
    # Non-interactive (piped) - install all skills
    echo "Installing all skills..."
    SELECTED_SKILLS=("${SKILLS[@]}")
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
