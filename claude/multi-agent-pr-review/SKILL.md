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

### Step 3: Start Codex Review Asynchronously

Launch Codex review with PR context, diffs, and acceptance criteria.

Codex runs in parallel while Claude continues Steps 4-7. Results will be retrieved in Step 8.

Expected completion: ~60-90 seconds for typical PRs.

### Step 4: Index Existing Comments

Fetch PR comments from Bitbucket (inline and general) and build an index structure for duplicate detection.

- Use Bitbucket MCP to get all PR comments
- Parse into indexed structure: `{file_path: {line_number: [comments]}}`
- Extract keywords from comment text for matching
- Store status (RESOLVED/UNRESOLVED)

### Step 5: Search for Similar Patterns

Find similar implementations in the destination branch (develop/main) to ensure new code follows established patterns.

Compare structure, naming, error handling, logging, and validation approaches. Flag inconsistencies.

For multi-tenant code: verify tenant filters are applied at query level, not just assumed from context.

### Step 6: Analyze and Classify Issues

Classify each finding by type and severity:

**Critical:**
- SECURITY: Auth, injection, data exposure, buffer/heap overflows
- PURPOSE-BREAKING: Breaks acceptance criteria
- TENANT-BOUNDARY: Missing tenant filters at query level

**High:**
- BUGS: Null checks, type errors, memory leaks, stack overflows
- PERFORMANCE: N+1 queries, unbounded collections, inefficient algorithms

**Medium:**
- PATTERNS: Codebase standard deviations
- TESTING: Missing test coverage

**Low:**
- NITS: Style, naming, formatting

### Step 7: Build Failures List

Collect all detected issues into a structured list. For each: category, severity, file/line, description, suggested fix, and reference.

Filter out duplicates using the comment index from Step 4 before adding.

### Step 8: Compare and Filter to Consensus

Wait for Codex review (started in Step 3) to complete. Compare Claude and Codex findings by matching file/line/issue-type.

Keep ONLY issues where both reviewers agree (consensus). Discard Claude-only and Codex-only findings.

Merge descriptions from both reviewers for consensus issues. Report: "Found X consensus issues (Y filtered out as single-reviewer findings)."

### Step 9: Present Consensus Issues for Selection

Display only consensus issues (high confidence - both reviewers agree). Show combined analysis from Claude + Codex.

Use ask_user_input_v0 for multi-select grouped by severity. All issues shown have been validated by both reviewers.

