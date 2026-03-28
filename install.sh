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
    "code-review")
      cat > .kiro/hooks/code-review.kiro.hook << 'EOF'
{
  "name": "Code Review",
  "version": "1.0.0",
  "description": "Perform automated code review on GitLab merge requests",
  "when": {
    "type": "userTriggered"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Help me review a GitLab merge request. Ask for the MR URL, then use the gitlab-code-review MCP tools to fetch the MR info and diff. Analyze the code for: security vulnerabilities, bugs, performance issues, error handling, code style, and duplication. Generate a structured report with severity levels (critical, warning, suggestion, positive) and actionable recommendations."
  }
}
EOF
      echo "  ✓ Hook installed: code-review"
      ;;
    *)
      echo "  ⚠️  No hook defined for: $skill"
      ;;
  esac
}

# Function to setup MCP server for code-review skill
setup_code_review_mcp() {
  local skill_path="$1"
  local mcp_server_path="${skill_path}/mcp-server"
  
  # Check if MCP server exists
  if [ ! -d "$mcp_server_path" ]; then
    echo "  ⚠️  MCP server not found at: $mcp_server_path"
    return 1
  fi
  
  echo ""
  echo "📦 Setting up GitLab Code Review MCP Server..."
  echo ""
  
  # Ask for GitLab configuration
  read -p "  Enter your GitLab host (e.g., gitlab.com): " gitlab_host
  gitlab_host=${gitlab_host:-gitlab.com}
  
  read -p "  Enter your GitLab personal access token (glpat-xxx): " gitlab_token
  
  if [ -z "$gitlab_token" ]; then
    echo "  ⚠️  No token provided. You can configure it later in ~/.kiro/settings/mcp.json"
    return 0
  fi
  
  # Build MCP server
  echo ""
  echo "  Building MCP server..."
  (cd "$mcp_server_path" && npm install --silent && npm run build --silent) || {
    echo "  ⚠️  Failed to build MCP server. Please run manually:"
    echo "      cd $mcp_server_path && npm install && npm run build"
    return 1
  }
  
  # Get absolute path
  local abs_mcp_path
  abs_mcp_path=$(cd "$mcp_server_path" && pwd)
  
  # Create MCP config
  local mcp_config_dir="$HOME/.kiro/settings"
  local mcp_config_file="$mcp_config_dir/mcp.json"
  
  mkdir -p "$mcp_config_dir"
  
  # Check if mcp.json exists and merge config
  if [ -f "$mcp_config_file" ]; then
    # Backup existing config
    cp "$mcp_config_file" "${mcp_config_file}.backup"
    
    # Use node to merge JSON (more reliable than jq)
    node -e "
      const fs = require('fs');
      const existing = JSON.parse(fs.readFileSync('$mcp_config_file', 'utf8'));
      existing.mcpServers = existing.mcpServers || {};
      existing.mcpServers['gitlab-code-review'] = {
        command: 'node',
        args: ['$abs_mcp_path/dist/index.js'],
        env: {
          GITLAB_TOKEN: '$gitlab_token',
          GITLAB_HOST: '$gitlab_host'
        }
      };
      fs.writeFileSync('$mcp_config_file', JSON.stringify(existing, null, 2));
    " 2>/dev/null || {
      # Fallback: create new config
      cat > "$mcp_config_file" << MCPEOF
{
  "mcpServers": {
    "gitlab-code-review": {
      "command": "node",
      "args": ["$abs_mcp_path/dist/index.js"],
      "env": {
        "GITLAB_TOKEN": "$gitlab_token",
        "GITLAB_HOST": "$gitlab_host"
      }
    }
  }
}
MCPEOF
    }
  else
    # Create new config
    cat > "$mcp_config_file" << MCPEOF
{
  "mcpServers": {
    "gitlab-code-review": {
      "command": "node",
      "args": ["$abs_mcp_path/dist/index.js"],
      "env": {
        "GITLAB_TOKEN": "$gitlab_token",
        "GITLAB_HOST": "$gitlab_host"
      }
    }
  }
}
MCPEOF
  fi
  
  echo "  ✓ MCP server configured at: $mcp_config_file"
  echo "  ✓ GitLab host: $gitlab_host"
  echo ""
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

# Check if code-review skill is being installed and setup MCP
for skill in "${SELECTED_SKILLS[@]}"; do
  if [ "$skill" = "code-review" ]; then
    # Find the skill path
    if [ -d ".agents/skills/code-review" ]; then
      setup_code_review_mcp ".agents/skills/code-review"
    elif [ -d "code-review" ]; then
      setup_code_review_mcp "code-review"
    fi
    break
  fi
done

echo ""
echo "✅ Kiro hooks installed!"
echo ""
echo "Usage:"
echo "  • Chat: Ask Kiro naturally (e.g., 'commit my changes')"
echo "  • Hooks: Agent Hooks panel → click play button"
echo ""
echo "For code-review skill:"
echo "  • Say: '/code-review https://gitlab.com/group/project/-/merge_requests/123'"
echo "  • Or: 'review this MR: <url>'"
