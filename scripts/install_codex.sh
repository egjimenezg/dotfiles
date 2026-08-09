#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

CODEX_SOURCE_FILE="${CODEX_SOURCE_FILE:-$DOTFILES_ROOT/codex/AGENTS.md}"
CODEX_TARGET_FILE="${CODEX_TARGET_FILE:-$HOME/.codex/AGENTS.md}"

if [ ! -f "$CODEX_SOURCE_FILE" ]; then
  echo "Codex source config not found: $CODEX_SOURCE_FILE"
  exit 1
fi

mkdir -p "$HOME/.codex"

if [ ! -f "$CODEX_TARGET_FILE" ]; then
  cp "$CODEX_SOURCE_FILE" "$CODEX_TARGET_FILE"
  echo "Installed $CODEX_TARGET_FILE"
  exit 0
fi

if cmp -s "$CODEX_SOURCE_FILE" "$CODEX_TARGET_FILE"; then
  echo "No changes. $CODEX_TARGET_FILE is already up to date."
  exit 0
fi

echo "Differences found"
diff -u "$CODEX_TARGET_FILE" "$CODEX_SOURCE_FILE" || true

read -r -p "Replace $CODEX_TARGET_FILE with repo version? [y/N] " reply

case "$reply" in
  [yY]|[yY][eE][sS])
    cp "$CODEX_SOURCE_FILE" "$CODEX_TARGET_FILE"
    echo "Replaced $CODEX_TARGET_FILE"
    ;;
  *)
    echo "Skipped."
    ;;
esac
