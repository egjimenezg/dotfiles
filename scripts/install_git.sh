#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

GIT_SOURCE_FILE="${GIT_SOURCE_FILE:-$DOTFILES_ROOT/git/.gitconfig}"
GIT_TARGET_FILE="${GIT_TARGET_FILE:-$HOME/.gitconfig}"

if [ ! -f "$GIT_SOURCE_FILE" ]; then
  echo "Git source config not found: $GIT_SOURCE_FILE"
  exit 1
fi

if [ ! -f "$GIT_TARGET_FILE" ]; then
  cp "$GIT_SOURCE_FILE" "$GIT_TARGET_FILE"
  echo "Installed $GIT_TARGET_FILE"
  exit 0
fi

if cmp -s "$GIT_SOURCE_FILE" "$GIT_TARGET_FILE"; then
  echo "No changes. $GIT_TARGET_FILE is already up to date."
  exit 0
fi

echo "Differences found"
diff -u "$GIT_TARGET_FILE" "$GIT_SOURCE_FILE" || true

read -r -p "Replace $GIT_TARGET_FILE with repo version? [y/N] " reply

case "$reply" in
  [yY]|[yY][eE][sS])
    cp "$GIT_SOURCE_FILE" "$GIT_TARGET_FILE"
    echo "Replaced $GIT_TARGET_FILE"
    ;;
  *)
    echo "Skipped."
    ;;
esac

