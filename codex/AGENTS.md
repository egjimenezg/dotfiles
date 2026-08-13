# Personal Development Preferences

## Code Style
- **Naming:** Variables, functions, and types should read like plain English — names reveal intent, not implementation (`userHasActiveSubscription` not `flag2`).
- **Functions:** Keep functions focused on a single responsibility. Extract sub-steps into well-named helpers when doing so clarifies the caller, not just to reduce line count.
- **Comments:** Do not add decorative banner comments, separator blocks, or repeated function-name headers like `# --------` / `# function_name` / `# --------`. Prefer clear names for structure, and write comments only when they explain non-obvious behavior, constraints, tradeoffs, or external-system quirks.

## Git Workflow
- Compare local code changes against `develop` by default, not `master` or `main`, unless the repo or user explicitly says otherwise.

# Python Preferences

- Prefer readable, explicit code over clever one-liners.
- Use structural pattern matching only when it clearly improves branching over data shape.
- Prefer standard library solutions before adding dependencies.
- In tests, when validating multiple attributes of the same object, prefer one structured assertion: compare the complete object when it supports value equality, or compare dictionaries keyed by attribute name when checking a subset. Keep separate assertions for independent behaviors, and avoid positional tuples when named fields provide clearer failures.

## Elixir Convention

### Module Aliases

Use one explicit alias per line and sort alias declarations alphabetically by their full module name. Do not use grouped aliases such as alias MyApp.{Accounts.User, Accounts.Profile}. Explicit aliases make module references easier to search and navigate.

Preferred:

alias MyApp.Accounts.Profile
alias MyApp.Accounts.User

Avoid:

alias MyApp.Accounts.{Profile, User}

## TypeScript Conventions

### Decorators
Use decorators when framework expects them or when multiple class-based services need the same cross cutting behavior, such as logging, metrics, authorization, caching or validation. In React components and hooks, favor React's composition pattern. For one-off behavior, prefer an explicit function.

