#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

CLAUDE_SOURCE_FILE="${CLAUDE_SOURCE_FILE:-$DOTFILES_ROOT/claude/CLAUDE.md}"
CLAUDE_TARGET_FILE="${CLAUDE_TARGET_FILE:-$HOME/.claude/CLAUDE.md}"

if [ ! -f "$CLAUDE_SOURCE_FILE" ]; then
  echo "Claude source config not found: $CLAUDE_SOURCE_FILE"
  exit 1
fi

mkdir -p "$HOME/.claude"

if [ ! -f "$CLAUDE_TARGET_FILE" ]; then
  cp "$CLAUDE_SOURCE_FILE" "$CLAUDE_TARGET_FILE"
  echo "Installed $CLAUDE_TARGET_FILE"
  exit 0
fi

if cmp -s "$CLAUDE_SOURCE_FILE" "$CLAUDE_TARGET_FILE"; then
  echo "No changes. $CLAUDE_TARGET_FILE is already up to date."
  exit 0
fi

echo "Differences found"
diff -u "$CLAUDE_TARGET_FILE" "$CLAUDE_SOURCE_FILE" || true

read -r -p "Replace $CLAUDE_TARGET_FILE with repo version? [y/N] " reply

case "$reply" in
  [yY]|[yY][eE][sS])
    cp "$CLAUDE_SOURCE_FILE" "$CLAUDE_TARGET_FILE"
    echo "Replaced $CLAUDE_TARGET_FILE"
    ;;
  *)
    echo "Skipped."
    ;;
esac
