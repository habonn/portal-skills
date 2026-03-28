#!/usr/bin/env node
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

const GITLAB_TOKEN = process.env.GITLAB_TOKEN;
const GITLAB_HOST = process.env.GITLAB_HOST || "gitlab.com";

interface MergeRequestInfo {
  title: string;
  description: string;
  state: string;
  author: string;
  sourceBranch: string;
  targetBranch: string;
  webUrl: string;
}

interface MergeRequestDiff {
  oldPath: string;
  newPath: string;
  diff: string;
  newFile: boolean;
  deletedFile: boolean;
  renamedFile: boolean;
}

function parseGitLabUrl(url: string): { projectPath: string; mrId: string } | null {
  const match = url.match(/https?:\/\/[^/]+\/(.+)\/-\/merge_requests\/(\d+)/);
  if (!match) return null;
  return { projectPath: match[1], mrId: match[2] };
}

async function gitlabApi<T>(endpoint: string): Promise<T> {
  if (!GITLAB_TOKEN) {
    throw new Error("GITLAB_TOKEN environment variable is not set");
  }
  
  const response = await fetch(`https://${GITLAB_HOST}/api/v4${endpoint}`, {
    headers: {
      "PRIVATE-TOKEN": GITLAB_TOKEN,
      "Content-Type": "application/json",
    },
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`GitLab API error (${response.status}): ${error}`);
  }

  return response.json() as Promise<T>;
}

async function getMergeRequest(url: string): Promise<MergeRequestInfo> {
  const parsed = parseGitLabUrl(url);
  if (!parsed) {
    throw new Error("Invalid GitLab merge request URL");
  }

  const encodedPath = encodeURIComponent(parsed.projectPath);
  const data = await gitlabApi<any>(`/projects/${encodedPath}/merge_requests/${parsed.mrId}`);

  return {
    title: data.title,
    description: data.description || "",
    state: data.state,
    author: data.author?.name || data.author?.username || "Unknown",
    sourceBranch: data.source_branch,
    targetBranch: data.target_branch,
    webUrl: data.web_url,
  };
}

async function getMergeRequestDiff(url: string): Promise<MergeRequestDiff[]> {
  const parsed = parseGitLabUrl(url);
  if (!parsed) {
    throw new Error("Invalid GitLab merge request URL");
  }

  const encodedPath = encodeURIComponent(parsed.projectPath);
  const data = await gitlabApi<any>(`/projects/${encodedPath}/merge_requests/${parsed.mrId}/changes`);

  return (data.changes || []).map((change: any) => ({
    oldPath: change.old_path,
    newPath: change.new_path,
    diff: change.diff,
    newFile: change.new_file,
    deletedFile: change.deleted_file,
    renamedFile: change.renamed_file,
  }));
}

const server = new Server(
  { name: "gitlab-code-review-mcp", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: "get_merge_request",
      description: "Get merge request information (title, description, author, branches)",
      inputSchema: {
        type: "object",
        properties: {
          url: {
            type: "string",
            description: "GitLab merge request URL",
          },
        },
        required: ["url"],
      },
    },
    {
      name: "get_merge_request_diff",
      description: "Get the diff/changes from a merge request for code review",
      inputSchema: {
        type: "object",
        properties: {
          url: {
            type: "string",
            description: "GitLab merge request URL",
          },
        },
        required: ["url"],
      },
    },
  ],
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    if (name === "get_merge_request") {
      const info = await getMergeRequest(args?.url as string);
      return {
        content: [
          {
            type: "text",
            text: JSON.stringify(info, null, 2),
          },
        ],
      };
    }

    if (name === "get_merge_request_diff") {
      const diffs = await getMergeRequestDiff(args?.url as string);
      const formattedDiff = diffs
        .map((d) => `### ${d.newPath}\n\`\`\`diff\n${d.diff}\n\`\`\``)
        .join("\n\n");
      return {
        content: [
          {
            type: "text",
            text: formattedDiff || "No changes found",
          },
        ],
      };
    }

    throw new Error(`Unknown tool: ${name}`);
  } catch (error) {
    return {
      content: [
        {
          type: "text",
          text: `Error: ${error instanceof Error ? error.message : String(error)}`,
        },
      ],
      isError: true,
    };
  }
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("GitLab Code Review MCP server running");
}

main().catch(console.error);
