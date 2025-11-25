#!/bin/bash
set -euo pipefail

DOTFILES_ROOT="$(pwd)"
export DOTFILES_ROOT

source "$DOTFILES_ROOT/scripts/platform.sh"
dotfiles_export_platform

echo "🚀 Installing dotfiles for $DOTFILES_PLATFORM..."

mkdir -p \
    "$HOME/.config/oh-my-posh" \
    "$HOME/.config/zsh" \
    "$HOME/.config/scripts"

declare -a links=(
    "$DOTFILES_ROOT/zsh/zshrc:$HOME/.zshrc"
    "$DOTFILES_ROOT/oh-my-posh/theme.json:$HOME/.config/oh-my-posh/theme.json"
    "$DOTFILES_ROOT/zsh/aliases.zsh:$HOME/.config/zsh/aliases.zsh"
    "$DOTFILES_ROOT/zsh/tool-checker.zsh:$HOME/.config/zsh/tool-checker.zsh"
    "$DOTFILES_ROOT/scripts/update-tools.sh:$HOME/.config/scripts/update-tools.sh"
    "$DOTFILES_ROOT/scripts/platform.sh:$HOME/.config/scripts/platform.sh"
)

for mapping in "${links[@]}"; do
    IFS=':' read -r src dst <<< "$mapping"
    ln -sf "$src" "$dst"
done

if [ -s "$DOTFILES_ROOT/git/gitconfig" ]; then
    ln -sf "$DOTFILES_ROOT/git/gitconfig" "$HOME/.gitconfig"
fi

echo "✅ Dotfiles installed successfully!"
echo "🔄 Run 'source ~/.zshrc' to reload your shell"
