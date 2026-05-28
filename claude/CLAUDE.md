# Personal Development Preferences

## Code Style
- **Naming:** Variables, functions, and types should read like plain English — names reveal intent, not implementation (`userHasActiveSubscription` not `flag2`).
- **Functions:** Keep functions focused on a single responsibility. Extract sub-steps into well-named helpers when doing so clarifies the caller, not just to reduce line count.
- **Comments:** Do not add decorative banner comments, separator blocks, or repeated function-name headers like `# --------` / `# function_name` / `# --------`. Prefer clear names for structure, and write comments only when they explain non-obvious behavior, constraints, tradeoffs, or external-system quirks.

## Git Workflow
- Compare local code changes against `develop` by default, not `master` or `main`, unless the repo or user explicitly says otherwise.
