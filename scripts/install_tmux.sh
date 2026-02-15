#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_SOURCE_FILE="${TMUX_SOURCE_FILE:-$SCRIPT_DIR/tmux/.tmux.conf}"
TMUX_TARGET_FILE="${TMUX_TARGET_FILE:-$HOME/.tmux.conf}"

if [ ! -f "$TMUX_SOURCE_FILE" ]; then
  echo "Tmux source config not found: $TMUX_SOURCE_FILE"
  exit 1
fi

if [ -f "$TMUX_TARGET_FILE" ]; then
  echo "Tmux config already exists at $TMUX_TARGET_FILE - skipping (won't overwrite)."
  exit 0
fi

mkdir -p "$(dirname "$TMUX_TARGET_FILE")"
cp "$TMUX_SOURCE_FILE" "$TMUX_TARGET_FILE"
echo "Installed tmux config at $TMUX_TARGET_FILE"
