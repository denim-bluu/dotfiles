#!/bin/bash
set -euo pipefail

SCRIPT_PATH="${BASH_SOURCE[0]:-$0}"
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
if [ -z "${DOTFILES_ROOT:-}" ]; then
    if [ -f "$SCRIPT_DIR/../Brewfile" ]; then
        DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
    elif [ -d "$HOME/dotfiles" ]; then
        DOTFILES_ROOT="$HOME/dotfiles"
    else
        echo "❌ Unable to locate dotfiles root. Set DOTFILES_ROOT and retry." >&2
        exit 1
    fi
fi

source "$DOTFILES_ROOT/scripts/platform.sh"
dotfiles_export_platform

echo "🚀 Installing development tools for $DOTFILES_PLATFORM..."

install_with_brew() {
    if ! command -v brew &> /dev/null; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    echo "📦 Installing Homebrew packages..."
    brew bundle --file "$DOTFILES_ROOT/Brewfile"
}

install_with_apt() {
    if ! command -v apt-get &> /dev/null; then
        echo "⚠️  Skipping apt-based packages: apt-get not available." >&2
        return
    fi

    echo "📦 Installing apt packages..."
    sudo apt-get update
    sudo apt-get install -y \
        oh-my-posh \
        fzf \
        bat \
        eza \
        zoxide \
        direnv \
        ripgrep
}

case "$DOTFILES_PLATFORM" in
    macos)
        install_with_brew
        ;;
    wsl|linux)
        if command -v brew &> /dev/null; then
            install_with_brew
        else
            install_with_apt
        fi
        ;;
    *)
        echo "ℹ️  Unknown platform '$DOTFILES_PLATFORM'; skipping package manager installs."
        ;;
esac

if ! command -v uv &> /dev/null; then
    echo "📦 Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if command -v pipx &> /dev/null; then
    echo "🐍 Installing Python tools..."
    pipx ensurepath
    for tool in poetry black mypy pre-commit rich-cli; do
        pipx install "$tool" || true
    done
fi

if command -v fzf &> /dev/null && [ ! -f "$HOME/.fzf.zsh" ]; then
    if command -v brew &> /dev/null && [ -d "$(brew --prefix 2>/dev/null)/opt/fzf" ]; then
        echo "⚙️ Configuring fzf key bindings..."
        "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc
    else
        echo "ℹ️  fzf installed outside Homebrew; configure key bindings manually if desired."
    fi
fi

echo "✅ All tools installed!"
