#!/bin/bash

echo "🚀 Installing missing development tools..."

# Install Homebrew if missing
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install from Brewfile
echo "📦 Installing Homebrew packages..."
cd ~/dotfiles && brew bundle

# Install uv
if ! command -v uv &> /dev/null; then
    echo "📦 Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Install Python tools via pipx
if command -v pipx &> /dev/null; then
    echo "🐍 Installing Python tools..."
    pipx ensurepath
    pipx install poetry || true
    pipx install black || true
    pipx install mypy || true
    pipx install pre-commit || true
    pipx install rich-cli || true
fi

# Configure fzf
if command -v fzf &> /dev/null && [ ! -f ~/.fzf.zsh ]; then
    echo "⚙️ Configuring fzf..."
    $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
fi

echo "✅ All tools installed!"
