#!/bin/bash
set -e

# Homebrew
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for Apple Silicon
  if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "Homebrew already installed"
fi

# Git
if ! brew list git &>/dev/null; then
  echo "Installing Git..."
  brew install git
else
  echo "Git already installed"
fi

# iTerm2
if ! brew list --cask iterm2 &>/dev/null; then
  echo "Installing iTerm2..."
  brew install --cask iterm2
else
  echo "iTerm2 already installed"
fi

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh already installed"
fi

# Powerlevel10k
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  echo "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  # Set theme in .zshrc
  sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
  source "$HOME/.zshrc"
else
  echo "Powerlevel10k already installed"
fi

# Install ZSH Plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Update plugins in .zshrc
sed -i '' 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)/' "$HOME/.zshrc"
source "$HOME/.zshrc"

echo "Done! Restart your terminal to apply changes."
