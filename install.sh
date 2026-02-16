#!/usr/bin/env bash
set -e

# Install Homebrew if it isn't already installed.
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

echo "Installing Git config..."
bash "./scripts/install_git.sh"

echo "Reloading shell..."
chsh -s "$(which zsh)"

echo "Installing SDKMAN..."
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

# Install Java
JAVA_VERSION="25-tem"

#Load SDKMAN into current shell
source "$HOME/.sdkman/bin/sdkman-init.sh"

if ! sdk list java | grep -q "$JAVA_VERSION"; then
  echo "Installing Java $JAVA_VERSION..."
  sdk install java "$JAVA_VERSION"
else
  echo "Java $JAVA_VERSION already installed."
fi

# Set default Java
sdk default java "$JAVA_VERSION"
java -version

# ------------------------
# Install asdf
# ------------------------
if [ ! -d "$HOME/.asdf" ]; then
  echo "Installing asdf..."
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
else
  echo "asdf already installed. Updating..."
fi

# Load asdf
. "$HOME/.asdf/asdf.sh"

# Add to .zshrc
if ! grep -q 'asdf.sh' "$HOME/.zshrc"; then
  echo -e '\n# asdf' >> "$HOME/.zshrc"
  echo '. $HOME/.asdf/asdf.sh' >> "$HOME/.zshrc"
  echo '. $HOME/.asdf/completions/asdf.bash' >> "$HOME/.zshrc"
fi

echo "🔧 Installing asdf plugins..."
bash "./asdf/install_plugins.sh"

TARGET_FILE="$HOME/.tool-versions"

if [ -f "$TARGET_FILE" ]; then
  echo "A .tool-versions file already exists at $TARGET_FILE"
else
  echo "Copying .tool-versions to $TARGET_FILE"
  cp "./asdf/.tool-versions" "$TARGET_FILE"
fi

if ! grep -q "icu4c" "$HOME/.bashrc"; then
  echo 'export PKG_CONFIG_PATH="$(brew --prefix icu4c)/lib/pkgconfig"' >> "$HOME/.bashrc"
  echo "✅ Added PKG_CONFIG_PATH for icu4c to ~/.bashrc"
fi

asdf install

echo "✅ Setup complete!"
zsh
