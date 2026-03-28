# GitLab Code Review MCP Server

MCP server for fetching GitLab merge request data for code review.

## Tools

- `get_merge_request` - Get MR info (title, description, author, branches)
- `get_merge_request_diff` - Get the diff/changes for code review

## Setup

The MCP server is automatically configured when you install the code-review skill via `install.sh`.

### Manual Setup

1. Build the server:
```bash
cd code-review/mcp-server
npm install
npm run build
```

2. Add to `~/.kiro/settings/mcp.json`:
```json
{
  "mcpServers": {
    "gitlab-code-review": {
      "command": "node",
      "args": ["/path/to/code-review/mcp-server/dist/index.js"],
      "env": {
        "GITLAB_TOKEN": "glpat-xxxx",
        "GITLAB_HOST": "gitlab.com"
      }
    }
  }
}
```

## Environment Variables

- `GITLAB_TOKEN` (required) - GitLab personal access token with `read_api` scope
- `GITLAB_HOST` (optional) - GitLab host, defaults to `gitlab.com`

## Creating a GitLab Token

1. Go to GitLab → Settings → Access Tokens
2. Create a token with `read_api` scope
3. Copy the token (starts with `glpat-`)
