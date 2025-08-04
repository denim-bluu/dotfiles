#!/bin/bash
set -e

echo "🚀 Installing dotfiles..."

# Create necessary directories
mkdir -p ~/.config/{oh-my-posh,zsh,scripts}

# Symlink files
ln -sf "$PWD/zsh/zshrc" ~/.zshrc
ln -sf "$PWD/oh-my-posh/theme.json" ~/.config/oh-my-posh/theme.json
ln -sf "$PWD/zsh/aliases.zsh" ~/.config/zsh/aliases.zsh
ln -sf "$PWD/zsh/tool-checker.zsh" ~/.config/zsh/tool-checker.zsh
ln -sf "$PWD/scripts/update-tools.sh" ~/.config/scripts/update-tools.sh

# Git config (only if file exists and not empty)
if [ -s "$PWD/git/gitconfig" ]; then
    ln -sf "$PWD/git/gitconfig" ~/.gitconfig
fi

echo "✅ Dotfiles installed successfully!"
echo "🔄 Run 'source ~/.zshrc' to reload your shell"
