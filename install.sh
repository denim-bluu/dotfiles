#!/bin/bash
set -e

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -q microsoft /proc/version 2>/dev/null; then
            echo "wsl"
        else
            echo "linux"
        fi
    else
        echo "unknown"
    fi
}

OS=$(detect_os)
echo "🚀 Installing dotfiles for $OS..."

# Create necessary directories
mkdir -p ~/.config/{oh-my-posh,zsh,scripts}

# Symlink files
ln -sf "$PWD/zsh/zshrc" ~/.zshrc
ln -sf "$PWD/oh-my-posh/theme.json" ~/.config/oh-my-posh/theme.json
ln -sf "$PWD/zsh/aliases.zsh" ~/.config/zsh/aliases.zsh
ln -sf "$PWD/zsh/tool-checker.zsh" ~/.config/zsh/tool-checker.zsh
ln -sf "$PWD/scripts/update-tools.sh" ~/.config/scripts/update-tools.sh

# Create OS-specific files
ln -sf "$PWD/packages-linux.txt" ~/.config/packages-linux.txt
ln -sf "$PWD/Brewfile" ~/.config/Brewfile

# Git config (only if file exists and not empty)
if [ -s "$PWD/git/gitconfig" ]; then
    ln -sf "$PWD/git/gitconfig" ~/.gitconfig
fi

echo "✅ Dotfiles installed successfully!"
echo "🔄 Run 'source ~/.zshrc' to reload your shell"
echo "📦 Run './scripts/update-tools.sh' to install development tools"
