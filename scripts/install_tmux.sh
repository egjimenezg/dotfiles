#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TMUX_SOURCE_FILE="${TMUX_SOURCE_FILE:-$DOTFILES_ROOT/tmux/.tmux.conf}"
TMUX_TARGET_FILE="${TMUX_TARGET_FILE:-$HOME/.tmux.conf}"

if [ ! -f "$TMUX_SOURCE_FILE" ]; then
  echo "Tmux source config not found: $TMUX_SOURCE_FILE"
  exit 1
fi

if [ ! -f "$TMUX_TARGET_FILE" ]; then
  cp "$TMUX_SOURCE_FILE" "$TMUX_TARGET_FILE"
  echo "Installed $TMUX_TARGET_FILE"
  exit 0
fi

if cmp -s "$TMUX_SOURCE_FILE" "$TMUX_TARGET_FILE"; then
  echo "No changes. $TMUX_TARGET_FILE is already up to date."
  exit 0
fi

echo "Differences found"
diff -u "$TMUX_TARGET_FILE" "$TMUX_SOURCE_FILE" || true

read -r -p "Replace $TMUX_TARGET_FILE with repo version? [y/N] " reply

case "$reply" in
  [yY]|[yY][eE][sS])
    cp "$TMUX_SOURCE_FILE" "$TMUX_TARGET_FILE"
    echo "Replaced $TMUX_TARGET_FILE"
    ;;
  *)
    echo "Skipped."
    ;;
esac
