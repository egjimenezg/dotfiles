#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

ZSH_SOURCE_FILE="${ZSH_SOURCE_FILE:-$DOTFILES_ROOT/shell/.zshrc}"
ZSH_TARGET_FILE="${ZSH_TARGET_FILE:-$HOME/.zshrc}"

if [ ! -f "$ZSH_SOURCE_FILE" ]; then
  echo "Zsh source config not found: $ZSH_SOURCE_FILE"
  exit 1
fi

if [ ! -f "$ZSH_TARGET_FILE" ]; then
  cp "$ZSH_SOURCE_FILE" "$ZSH_TARGET_FILE"
  echo "Installed $ZSH_TARGET_FILE"
  exit 0
fi

if cmp -s "$ZSH_SOURCE_FILE" "$ZSH_TARGET_FILE"; then
  echo "No changes. $ZSH_TARGET_FILE is already up to date."
  exit 0
fi

echo "Differences found"
diff -u "$ZSH_TARGET_FILE" "$ZSH_SOURCE_FILE" || true

read -r -p "Replace $ZSH_TARGET_FILE with repo version? [y/N] " reply

case "$reply" in
  [yY]|[yY][eE][sS])
    cp "$ZSH_SOURCE_FILE" "$ZSH_TARGET_FILE"
    echo "Replaced $ZSH_TARGET_FILE"
    ;;
  *)
    echo "Skipped."
    ;;
esac
