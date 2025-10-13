#!/usr/bin/env bash
set -euo pipefail

# Usage
# ./generate_github_ssh.sh [key_name] [label]
#
# - key_name (optional): name for the SSH key file.
#   Defaults to "id_github_<timestamp>".
# - label (optional): label to appear in GitHub SSH keys.
#   Defaults to "<key_name>-<hostname>".
#
# Example:
# ./generate_github_ssh.sh id_github_egjimenezg "MacBook Pro, 2020"


# Ensure GitHub CLI is authenticated
if ! gh auth status &>/dev/null; then
  echo "Authenticating GitHub CLI..."
  gh auth login -h github.com -p ssh
else
  echo "GitHub CLI already authenticated."
fi

# Ensure SSH keys can be added
if ! gh api user/keys &>/dev/null; then
  echo "Missing admin:public_key scope. Refreshing..."
  gh auth refresh -h github.com -s admin:public_key
fi

KEY_NAME="${1:-id_github_$(date +%Y%m%d_%H%M%S)}"
KEY_DIR="$HOME/.ssh"
KEY_PATH="$KEY_DIR/$KEY_NAME"

mkdir -p "$KEY_DIR"
chmod 700 "$KEY_DIR"

LABEL="${2:-${KEY_NAME}-$(hostname)}"
EMAIL="${GITHUB_EMAIL:-egjimenezg@gmail.com}"

mkdir -p "$KEY_DIR"
chmod 700 "$KEY_DIR"

echo "🔐 Generating SSH key: $KEY_PATH"

ssh-keygen -t ed25519 -C "egjimenezg@gmail.com" -f "$KEY_PATH" -N ""

echo "Key generated at: $KEY_PATH"

echo "🗝️ Public key:"
cat "${KEY_PATH}.pub"

# Add it to GitHub if gh is logged in
if command -v gh &>/dev/null; then
  echo "Uploading to GitHub..."
  gh ssh-key add "${KEY_PATH}.pub" --title "$LABEL"
else
  echo "'gh' CLI not found or not authenticated. Skipping GitHub upload."
fi

# Trust Github host
ssh-keyscan -t ed25519 github.com >> ~/.ssh/known_hosts 2>/dev/null
chmod 644 ~/.ssh/known_hosts

# Add to SSH config if not already present
CONFIG_ENTRY="Host github.com
  HostName github.com
  User git
  IdentityFile $KEY_PATH
  IdentitiesOnly yes
"

if ! grep -q "$KEY_PATH" ~/.ssh/config 2>/dev/null; then
  echo "Adding SSH config for github.com"
  echo "$CONFIG_ENTRY" >> ~/.ssh/config
fi

# Test SSH connection
echo "🔍 Testing SSH connection..."
ssh -T git@github.com || true

echo "Key '$KEY_NAME' uploaded and configured."
