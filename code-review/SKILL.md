---
name: code-review
description: Perform automated code reviews on GitLab merge requests. Analyzes code for style, bugs, security, performance, and error handling issues. Generates HTML report for easy reading.
---

# Code Review Skill

Perform automated code reviews on GitLab merge requests with multi-category analysis and structured summary reports. **Automatically generates an HTML report** with professional styling for easy reading and sharing.

## Output

After completing the review, the skill automatically saves an HTML report:
- **Filename:** `code-review-{MR-number}.html` in the current directory
- **Features:**
  - Color-coded severity levels (🔴 critical, 🟡 warning, 🔵 suggestion, 🟢 positive)
  - Syntax-highlighted code snippets
  - Summary statistics at the top
  - Responsive design for easy reading on any device

## Prerequisites

This skill requires the `gitlab-code-review` MCP server to fetch merge request data automatically.

**Setup:** Run `install.sh` after installing the skill - it will prompt for your GitLab token and configure the MCP server automatically.

**Manual setup:** See `code-review/mcp-server/README.md`

## When to Use This Skill

- "/code-review"
- "/code-review <url>"
- "code review"
- "review this MR"
- "review merge request"

---

## Commands

| Command | Description |
|---------|-------------|
| `/code-review` | Activate skill and prompt for a GitLab merge request URL |
| `/code-review <url>` | Start review with the provided GitLab merge request URL |
| `code review` | Natural language trigger to activate the skill |
| `review this MR` | Natural language trigger to activate the skill |
| `review merge request` | Natural language trigger to activate the skill |

---

## GitLab Merge Request URL Pattern

The skill accepts GitLab merge request URLs following this pattern:

```
https://<gitlab-host>/<group>/<project>/-/merge_requests/<id>
```

### URL Components

| Component | Description | Example |
|-----------|-------------|---------|
| `gitlab-host` | The GitLab instance domain | `gitlab.com`, `gitlab.example.com` |
| `group` | Project group or namespace (supports nested paths) | `myteam`, `org/subgroup` |
| `project` | Repository name | `my-project` |
| `id` | Merge request number (numeric) | `123` |

### Supported URL Formats

**Simple project path:**
```
https://gitlab.com/mygroup/myproject/-/merge_requests/123
```

**Nested group path (group/subgroup/project):**
```
https://gitlab.com/org/team/subgroup/myproject/-/merge_requests/456
```

**Self-hosted GitLab:**
```
https://gitlab.company.io/engineering/backend/-/merge_requests/789
```

### Parsing Rules

1. The URL must be a valid HTTPS URL
2. The URL must contain the `/-/merge_requests/` path segment
3. The merge request ID must be a positive integer
4. The project path is extracted as everything between the host and `/-/merge_requests/`
5. Nested group paths are fully supported (e.g., `group/subgroup/project`)

### Extracted Components

When parsing a valid URL, the skill extracts:

- **host**: The GitLab instance domain (e.g., `gitlab.com`)
- **projectPath**: The full path to the project including groups (e.g., `org/team/myproject`)
- **mergeRequestId**: The numeric MR identifier (e.g., `123`)

### URL Validation and Error Handling

The skill validates URLs and provides clear error messages for invalid inputs:

| Error Condition | Error Message |
|-----------------|---------------|
| Empty or missing URL | "Please provide a GitLab merge request URL." |
| Malformed URL (not a valid URL format) | "The provided URL is not valid. Expected format: `https://<gitlab-host>/<group>/<project>/-/merge_requests/<id>`" |
| Non-GitLab URL (e.g., GitHub, Bitbucket) | "Only GitLab merge request URLs are supported. Please provide a URL from a GitLab instance." |
| Missing `/-/merge_requests/` segment | "The URL does not appear to be a GitLab merge request. Ensure the URL contains `/-/merge_requests/`." |
| Non-numeric merge request ID | "The merge request ID must be a number. Found invalid ID in URL." |

**Validation Order:**

1. Check if URL is provided (not empty)
2. Validate URL format (must be a valid HTTPS URL)
3. Verify the URL is from a GitLab instance (contains `/-/merge_requests/`)
4. Extract and validate the merge request ID (must be numeric)

---

## Workflow

The code review process follows these steps:

### Step 1: Command Recognition and URL Extraction

When you invoke the skill using `/code-review`, `/code-review <url>`, or natural language triggers like "review this MR", the skill activates and checks if a URL was provided. If no URL is included, you will be prompted to provide one.

### Step 2: URL Validation and Parsing

The provided URL is validated against the GitLab merge request pattern. The skill extracts:
- Host (GitLab instance domain)
- Project path (including any nested groups)
- Merge request ID

If validation fails, a clear error message explains what went wrong and the expected format.

### Step 3: Guide User to Fetch Diff Content

Once the URL is validated, the skill provides instructions for retrieving the merge request data:
- How to access the diff via GitLab web interface or API
- What information to provide (title, description, changed files)
- Troubleshooting tips if access issues occur

See the [How to Retrieve Merge Request Data](#how-to-retrieve-merge-request-data) section below for detailed instructions.

### Step 4: Receive and Process Diff

After you provide the diff content, the skill processes all changed files in the merge request. Each file is analyzed regardless of file type, with appropriate handling for:
- Source code files (full analysis)
- Configuration files (relevant checks)
- Binary files (noted but skipped)

### Step 5: Analyze Code and Generate Report

The skill performs multi-category analysis on the code changes and generates a structured summary report containing:
- Overall assessment
- Findings categorized by severity (critical, warning, suggestion, positive)
- File and line references for each issue
- Actionable recommendations

---

## How to Retrieve Merge Request Data

After the merge request URL is validated, you need to provide the diff content for analysis. This section explains how to retrieve the required information.

### Required Information

To perform a thorough code review, please provide:

| Information | Description | Required |
|-------------|-------------|----------|
| Title | The merge request title | Yes |
| Description | The MR description explaining the changes | Yes |
| Diff Content | The actual code changes (additions/deletions) | Yes |
| Changed Files List | List of all files modified in the MR | Recommended |

### Option 1: Using the GitLab Web Interface

1. **Navigate to the Merge Request**
   - Open the merge request URL in your browser
   - You should see the MR overview page with title and description

2. **Copy the Title and Description**
   - The title is displayed at the top of the page
   - The description is shown below the title in the overview section

3. **Access the Changes Tab**
   - Click on the "Changes" tab to view the diff
   - This shows all modified files with line-by-line changes

4. **Copy the Diff Content**
   - Select and copy the diff content from the Changes view
   - Alternatively, click the "..." menu and select "Copy diff" if available
   - For large MRs, you may need to expand collapsed files first

### Option 2: Using the GitLab API

If you have API access, you can retrieve the merge request data programmatically:

**Get Merge Request Details:**
```bash
curl --header "PRIVATE-TOKEN: <your_access_token>" \
  "https://<gitlab-host>/api/v4/projects/<project_id>/merge_requests/<mr_id>"
```

**Get Merge Request Changes (Diff):**
```bash
curl --header "PRIVATE-TOKEN: <your_access_token>" \
  "https://<gitlab-host>/api/v4/projects/<project_id>/merge_requests/<mr_id>/changes"
```

**Notes:**
- Replace `<your_access_token>` with your GitLab personal access token
- Replace `<project_id>` with the URL-encoded project path (e.g., `mygroup%2Fmyproject`)
- Replace `<mr_id>` with the merge request number
- The token needs at least `read_api` scope

### Option 3: Using Git Commands

If you have the repository cloned locally:

```bash
# Fetch the merge request branch
git fetch origin merge-requests/<mr_id>/head:mr-<mr_id>

# View the diff against the target branch
git diff <target_branch>...mr-<mr_id>
```

### Troubleshooting Access Issues

| Issue | Possible Cause | Solution |
|-------|----------------|----------|
| 404 Not Found | MR doesn't exist or wrong URL | Verify the merge request ID and project path are correct |
| 401 Unauthorized | Missing or invalid authentication | Ensure you're logged in (web) or using a valid API token |
| 403 Forbidden | Insufficient permissions | Request access to the project or contact the project owner |
| Empty diff | MR has no changes or is already merged | Check if the MR is still open and has commits |
| Timeout on large MRs | Too many changed files | Try fetching changes for specific files or use the API with pagination |

### Tips for Large Merge Requests

- **Break it down**: If the MR has many files, consider providing the diff in batches
- **Focus on key files**: Prioritize source code files over generated or configuration files
- **Exclude binary files**: Binary file changes cannot be meaningfully reviewed
- **Use file filters**: In the GitLab UI, use the file filter to focus on specific file types

### What to Provide

Once you have the information, share it in the following format:

```
**Title:** [MR Title]

**Description:**
[MR Description]

**Changed Files:**
- file1.ts
- file2.ts
- ...

**Diff:**
[Paste the diff content here]
```

---

## Code Analysis Categories

When analyzing code changes, the skill evaluates the diff across multiple categories to provide comprehensive feedback. Each finding is categorized to help prioritize and address issues effectively.

### Style

Identifies formatting and naming convention issues that affect code readability and maintainability.

| Issue Type | Description | Example |
|------------|-------------|---------|
| Formatting inconsistencies | Irregular indentation, spacing, or line breaks | Mixed tabs and spaces, inconsistent brace placement |
| Naming violations | Names that don't follow conventions | `myFunc` instead of `myFunction`, `x` for a meaningful variable |
| Code organization | Poor structure or ordering | Related functions scattered across file |

### Bugs

Detects potential logic errors and runtime issues that could cause incorrect behavior.

| Issue Type | Description | Example |
|------------|-------------|---------|
| Logic errors | Incorrect conditions or calculations | Off-by-one errors, inverted boolean logic |
| Null pointer risks | Potential null/undefined access | Accessing property without null check |
| Type mismatches | Incompatible type operations | String concatenation instead of numeric addition |
| Race conditions | Concurrent access issues | Unsynchronized shared state modifications |

### Security

Identifies vulnerabilities that could be exploited by malicious actors.

| Issue Type | Description | Example |
|------------|-------------|---------|
| SQL injection | Unsanitized database queries | String concatenation in SQL queries |
| XSS vulnerabilities | Cross-site scripting risks | Unescaped user input in HTML output |
| Hardcoded secrets | Credentials in source code | API keys, passwords, tokens in code |
| Insecure dependencies | Known vulnerable packages | Outdated libraries with CVEs |
| Path traversal | Unsanitized file path access | User input directly in file paths |

### Performance

Highlights inefficiencies that could impact application speed or resource usage.

| Issue Type | Description | Example |
|------------|-------------|---------|
| N+1 queries | Repeated database calls in loops | Fetching related records one at a time |
| Unnecessary loops | Redundant iterations | Looping when a direct lookup suffices |
| Memory leaks | Unreleased resources | Event listeners not removed, unclosed connections |
| Inefficient algorithms | Suboptimal complexity | O(n²) when O(n) is possible |
| Excessive allocations | Unnecessary object creation | Creating objects inside tight loops |

### Error Handling

Evaluates how the code handles exceptional conditions and failures.

| Issue Type | Description | Example |
|------------|-------------|---------|
| Uncaught exceptions | Missing try-catch blocks | Async operations without error handling |
| Silent failures | Errors swallowed without action | Empty catch blocks, ignored promise rejections |
| Missing validation | Unvalidated inputs | No bounds checking, missing required field validation |
| Poor error messages | Unhelpful error information | Generic "An error occurred" messages |

### Duplication

Identifies repeated code patterns that could be consolidated.

| Issue Type | Description | Example |
|------------|-------------|---------|
| Copy-paste code | Identical or near-identical blocks | Same logic repeated in multiple functions |
| Extractable functions | Repeated patterns that could be abstracted | Common validation logic duplicated |
| Magic numbers/strings | Repeated literals without constants | Same value hardcoded in multiple places |

### Positive

Recognizes good practices and well-written code to encourage continued quality.

| Issue Type | Description | Example |
|------------|-------------|---------|
| Clean abstractions | Well-designed interfaces and modules | Clear separation of concerns |
| Comprehensive testing | Good test coverage | Unit tests for edge cases |
| Clear documentation | Helpful comments and docs | Well-documented public APIs |
| Defensive coding | Proactive error prevention | Input validation, null checks |
| Performance optimization | Efficient implementations | Appropriate caching, lazy loading |

---

## Severity Levels

Each finding from the code review is assigned a severity level to help prioritize issues and focus attention on the most important items first.

### Critical

Issues that require immediate attention before the merge request can be approved.

| Criteria | Description | Examples |
|----------|-------------|----------|
| Security vulnerabilities | Code that could be exploited by attackers | SQL injection, XSS, authentication bypass, exposed credentials |
| Data loss risks | Code that could result in data corruption or loss | Unprotected delete operations, missing transaction handling, race conditions on writes |
| Breaking changes | Changes that would cause system failures | Null pointer exceptions in critical paths, infinite loops, resource exhaustion |

### Warning

Issues that should be addressed but don't block the merge request.

| Criteria | Description | Examples |
|----------|-------------|----------|
| Potential bugs | Code that may cause incorrect behavior | Off-by-one errors, incorrect null handling, logic errors |
| Performance issues | Code that could degrade system performance | N+1 queries, inefficient algorithms, memory leaks |
| Error handling gaps | Missing or inadequate error handling | Uncaught exceptions, silent failures, missing validation |

### Suggestion

Recommendations for improvement that enhance code quality.

| Criteria | Description | Examples |
|----------|-------------|----------|
| Style improvements | Formatting and convention issues | Inconsistent naming, poor indentation, missing documentation |
| Refactoring opportunities | Code that could be cleaner or more maintainable | Duplicated code, overly complex functions, magic numbers |
| Best practice deviations | Code that doesn't follow established patterns | Missing type annotations, hardcoded values, tight coupling |

### Positive

Recognition of good practices to encourage continued quality.

| Criteria | Description | Examples |
|----------|-------------|----------|
| Good practices observed | Code that demonstrates quality patterns | Comprehensive error handling, clear naming, proper abstractions |
| Well-tested code | Evidence of thorough testing | Unit tests for edge cases, integration test coverage |
| Clean design | Good architectural decisions | Separation of concerns, dependency injection, clear interfaces |

---

## Report Structure

The code review generates a structured markdown report containing all findings organized for easy consumption. This section documents the report format and each component.

### Report Sections Overview

| Section | Description | Always Present |
|---------|-------------|----------------|
| Header | MR identification information | Yes |
| Overall Assessment | High-level summary of the review | Yes |
| Findings Summary | Counts by severity category | Yes |
| Critical Issues | Issues requiring immediate attention | Only if critical findings exist |
| Warnings | Potential problems to address | Only if warning findings exist |
| Suggestions | Improvement recommendations | Only if suggestion findings exist |
| Positive Observations | Good practices identified | Only if positive findings exist |
| Recommendations | Actionable next steps | Yes |

### Header

The report header contains merge request identification information:

| Field | Description | Example |
|-------|-------------|---------|
| URL | Full merge request URL | `https://gitlab.com/team/project/-/merge_requests/123` |
| Project | Project path including groups | `team/project` |
| MR ID | Merge request number | `#123` |
| Title | Merge request title | `Add user authentication feature` |

**Format:**
```markdown
# Code Review: [MR Title]

**Merge Request:** [URL]
**Project:** [Project Path]
**MR ID:** #[ID]
```

### Overall Assessment

A brief summary providing the reviewer's high-level evaluation of the merge request quality and readiness.

**Content includes:**
- General quality assessment (e.g., "well-structured", "needs work", "ready for merge")
- Key concerns or highlights
- Recommendation (approve, request changes, needs discussion)

**Format:**
```markdown
## Overall Assessment

[1-3 sentences summarizing the overall quality and readiness of the changes]
```

### Findings Summary

A statistical overview showing the count of findings in each severity category.

| Metric | Description |
|--------|-------------|
| Total Findings | Sum of all findings across categories |
| Critical | Count of critical severity issues |
| Warnings | Count of warning severity issues |
| Suggestions | Count of suggestion severity items |
| Positive | Count of positive observations |
| Files Reviewed | Number of files analyzed |

**Format:**
```markdown
## Findings Summary

| Severity | Count |
|----------|-------|
| 🔴 Critical | [N] |
| 🟡 Warning | [N] |
| 🔵 Suggestion | [N] |
| 🟢 Positive | [N] |
| **Total** | [N] |

**Files Reviewed:** [N]
```

### Critical Issues

A detailed list of critical severity findings that require immediate attention before the merge request can be approved.

**Each finding includes:**
- File name and line number(s)
- Issue title and category
- Detailed description
- Actionable recommendation

**Format:**
```markdown
## Critical Issues

### 1. [Issue Title]

**File:** `[filename]` | **Line:** [line number or range]
**Category:** [Security/Bugs/etc.]

[Detailed description of the issue]

**Recommendation:** [Specific action to resolve the issue]

---
```

### Warnings

A list of warning severity findings that should be addressed but don't block the merge.

**Each finding includes:**
- File name and line number(s)
- Issue title and category
- Description of the concern
- Suggested resolution

**Format:**
```markdown
## Warnings

### 1. [Issue Title]

**File:** `[filename]` | **Line:** [line number or range]
**Category:** [Bugs/Performance/Error Handling/etc.]

[Description of the potential issue]

**Suggestion:** [How to address the warning]

---
```

### Suggestions

A list of improvement recommendations that enhance code quality but are not required.

**Each finding includes:**
- File name and line number(s) (when applicable)
- Suggestion title and category
- Explanation of the improvement
- Example or guidance (optional)

**Format:**
```markdown
## Suggestions

### 1. [Suggestion Title]

**File:** `[filename]` | **Line:** [line number or range]
**Category:** [Style/Duplication/etc.]

[Explanation of the suggested improvement]

---
```

### Positive Observations

Recognition of good practices and well-written code to encourage continued quality.

**Each observation includes:**
- File name (line numbers optional)
- What was done well
- Why it's a good practice

**Format:**
```markdown
## Positive Observations

### 1. [Observation Title]

**File:** `[filename]`

[Description of the good practice and why it's valuable]

---
```

### Actionable Recommendations

A prioritized list of next steps for the merge request author, summarizing the key actions needed.

**Content includes:**
- Prioritized action items based on findings
- Grouped by urgency (must fix, should fix, consider)
- Clear, specific guidance

**Format:**
```markdown
## Recommendations

### Must Fix (Before Merge)
1. [Action item from critical issues]
2. [Action item from critical issues]

### Should Fix
1. [Action item from warnings]
2. [Action item from warnings]

### Consider
1. [Action item from suggestions]
2. [Action item from suggestions]
```

### Complete Report Example

```markdown
# Code Review: Add user authentication feature

**Merge Request:** https://gitlab.com/team/project/-/merge_requests/123
**Project:** team/project
**MR ID:** #123

## Overall Assessment

The authentication implementation is well-structured with good separation of concerns. However, there are critical security issues with password handling that must be addressed before merge. The error handling is comprehensive and the code follows project conventions.

## Findings Summary

| Severity | Count |
|----------|-------|
| 🔴 Critical | 2 |
| 🟡 Warning | 3 |
| 🔵 Suggestion | 4 |
| 🟢 Positive | 2 |
| **Total** | 11 |

**Files Reviewed:** 6

## Critical Issues

### 1. Plaintext Password Storage

**File:** `src/auth/userService.ts` | **Line:** 45-48
**Category:** Security

Passwords are being stored in plaintext in the database. This exposes user credentials if the database is compromised.

**Recommendation:** Use bcrypt or argon2 to hash passwords before storage. Never store plaintext passwords.

---

### 2. SQL Injection Vulnerability

**File:** `src/auth/userRepository.ts` | **Line:** 23
**Category:** Security

User input is directly concatenated into SQL query without sanitization.

**Recommendation:** Use parameterized queries or an ORM to prevent SQL injection attacks.

---

## Warnings

### 1. Missing Rate Limiting

**File:** `src/auth/loginController.ts` | **Line:** 15-30
**Category:** Security

The login endpoint has no rate limiting, making it vulnerable to brute force attacks.

**Suggestion:** Implement rate limiting using a middleware like express-rate-limit.

---

### 2. Potential Null Reference

**File:** `src/auth/tokenService.ts` | **Line:** 12-15
**Category:** Bugs

The `user` object is accessed without checking if it exists, which could cause a runtime error if the user lookup fails.

**Suggestion:** Add a null check before accessing user properties: `if (!user) throw new UserNotFoundError();`

---

### 3. Missing Token Expiration Handling

**File:** `src/auth/tokenService.ts` | **Line:** 42-50
**Category:** Error Handling

The token refresh logic doesn't handle the case where the token has already expired, which could lead to silent authentication failures.

**Suggestion:** Add explicit expiration checking and return a clear error when the token cannot be refreshed.

---

## Suggestions

### 1. Extract Validation Logic

**File:** `src/auth/userService.ts` | **Line:** 20-35
**Category:** Duplication

Email and password validation logic is duplicated in multiple methods.

**Suggestion:** Extract into a shared validation utility function.

---

### 2. Add JSDoc Comments

**File:** `src/auth/userService.ts` | **Line:** 1-100
**Category:** Style

Public methods lack documentation comments, making it harder for other developers to understand the API.

**Suggestion:** Add JSDoc comments to all public methods describing parameters, return values, and potential errors.

---

### 3. Consider Using Validation Library

**File:** `src/auth/validators.ts` | **Line:** 5-45
**Category:** Style

Custom validation logic could be replaced with a well-tested validation library for better maintainability.

**Suggestion:** Consider using a validation library like Zod or Joi for schema validation.

---

### 4. Magic String Constants

**File:** `src/auth/constants.ts` | **Line:** 8-12
**Category:** Duplication

The error message "Invalid credentials" appears in multiple files without a shared constant.

**Suggestion:** Define error messages as constants in a shared file to ensure consistency.

---

## Positive Observations

### 1. Comprehensive Error Handling

**File:** `src/auth/loginController.ts`

Excellent use of try-catch blocks with specific error types and meaningful error messages. This will make debugging much easier.

---

### 2. Clear Function Naming

**File:** `src/auth/userService.ts`

Function names clearly describe their purpose (e.g., `validateUserCredentials`, `generateAuthToken`). This improves code readability.

---

## Recommendations

### Must Fix (Before Merge)
1. Implement password hashing in `userService.ts` (Critical: Security)
2. Use parameterized queries in `userRepository.ts` (Critical: Security)

### Should Fix
1. Add rate limiting to login endpoint (Warning: Security)
2. Add null check for user object in `tokenService.ts` lines 12-15 (Warning: Bugs)
3. Handle token expiration edge case in `tokenService.ts` (Warning: Error Handling)

### Consider
1. Extract validation logic to reduce duplication in `userService.ts`
2. Add JSDoc comments to public methods for better documentation
3. Consider using a validation library like Zod for schema validation
4. Define error message constants to ensure consistency
```
