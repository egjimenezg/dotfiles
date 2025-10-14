#!/usr/bin/env bash
set -e

# Install Homebrew if it isn’t already installed.
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add Homebrew to PATH
  if [ -d "/opt/homebrew/bin" ]; then
    echo "Adding Homebrew to PATH..."
    echo >> ~/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "Homebrew already installed."
fi

# Install Brew packages
echo "Installing Brew packages..."
brew bundle --file="./Brewfile"

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💫 Installing Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh already installed."
fi

echo "Copy configuration files..."
cp ./shell/.zshrc "$HOME/.zshrc"

echo "Reloading shell..."
chsh -s "$(which zsh)"

echo "Installing SDKMAN and Java..."
if [ ! -d "$HOME/.sdkman" ]; then
  echo "Installing SDKMAN..."
  curl -s "https://get.sdkman.io" | bash
else
  echo "SDKMAN already installed."
fi

SDKMAN_INIT='export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"'

# Add to .zshrc if missing
if ! grep -q 'sdkman-init.sh' "$HOME/.zshrc" 2>/dev/null; then
  echo "Adding SDKMAN to PATH in ~/.zshrc..."
  echo -e "\n# >>> SDKMAN initialization >>>\n$SDKMAN_INIT\n# <<< SDKMAN initialization <<<" >> "$HOME/.zshrc"
fi

# Add to .bashrc if missing
if ! grep -q 'sdkman-init.sh' "$HOME/.bashrc" 2>/dev/null; then
  echo "Adding SDKMAN to PATH in ~/.bashrc..."
  echo -e "\n# >>> SDKMAN initialization >>>\n$SDKMAN_INIT\n# <<< SDKMAN initialization <<<" >> "$HOME/.bashrc"
fi

echo "✅ Setup complete!"
zsh

