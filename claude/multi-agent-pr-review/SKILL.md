---
name: multi-agent-pr-review
description: Review pull requests with Claude and Codex in parallel, compare and deduplicate their results, then produce a final severity-ranked list of actionable findings.
---

# Multi agent PR review

## Trigger conditions

Use this skill when user asks for a comprehensive pull request of branch review, including requests such as:

- "review this branch"
- "check if this PR meets acceptance criteria"
- "review code for bugs and performance"
- "verify test coverage for this PR"
- "check if code follows our patterns"

## What This Skill Does

Performs a comprehensive code review that:
1. Uses the Bitbucket API/MCP to inspect the pull request metadata, changed files, diffs, comments, and pipeline status.
2. Analyze code changes for correctness, edge cases, and unintended behavior.
3. Searches the repository for similar patterns to verify consistency with existing architecture, naming, error handling, validation and testing style.
4. Detect potential bugs, logic errors, race conditions, null/empty state issues, and integration risks.
5. Analyzes performance implications, including unnecessary queries, repeated work, inefficient loops, payload size, caching behavior, and scalability concerns.
6. Verifies test coverage completeness for the changed behavior, including unit, integration, regression, and edge-case coverage where relevant.
7. Evaluates code cleanliness, complexity, maintainability, duplication, and wether the implementation reduces or introduces unnecessary complexity.
8. Produces a final severity-ranked list of actionable findings with file/line references and suggested fixes.
9. Reviews permissions, authorization, and security boundaries when the changed code touches user access, data exposure, authentication, secrets, input handling, or privileged operations.
10. Validates acceptance criteria only when the PR description, linked ticket, or user prompt provides enough context.

## Instructions

### Step 1: Load Bitbucket MCP
Use Claude tool search, when available, to discover the Bitbucket/Atlassian MCP tools for pull request metadata, diffs, comments, tasks, repository content, branches, and pipelines.

If tool search is unavailable, use the available Bitbucket MCP tools directly. If no Bitbucket tools are available, ask the user to connect the MCP server.

### Step 2: Fetch PR and Diff information via Bitbucket API
Use Bitbucket MCP tools to retrieve PR data and diff remotely:
2.1: Get Pull Request Details
Call Bitbucket MCP to get:
- PR title, description, and ID
- Source branch (feature branch)
- Destination branch (usually develop or main)
- Author and reviewers
- PR status and creation date

