#!/bin/bash

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

# Install packages for Linux/WSL
install_linux_packages() {
    echo "📦 Installing Linux packages..."
    
    # Update package list
    sudo apt update
    
    # Install basic packages
    if [ -f ~/.config/packages-linux.txt ]; then
        sudo apt install -y $(cat ~/.config/packages-linux.txt | grep -v '^#' | tr '\n' ' ')
    fi
    
    # Install eza (better ls)
    if ! command -v eza &> /dev/null; then
        echo "📦 Installing eza..."
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo apt update && sudo apt install -y eza
    fi
    
    # Install zoxide (better cd)
    if ! command -v zoxide &> /dev/null; then
        echo "📦 Installing zoxide..."
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi
    
    # Install direnv
    if ! command -v direnv &> /dev/null; then
        echo "📦 Installing direnv..."
        curl -sfL https://direnv.net/install.sh | bash
    fi
    
    # Install oh-my-posh
    if ! command -v oh-my-posh &> /dev/null; then
        echo "📦 Installing oh-my-posh..."
        curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
        # Add to PATH if not already there
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            export PATH="$HOME/.local/bin:$PATH"
        fi
    fi
    
    # Install yq
    if ! command -v yq &> /dev/null; then
        echo "📦 Installing yq..."
        sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && sudo chmod +x /usr/bin/yq
    fi
    
    # Install GitHub CLI if not present
    if ! command -v gh &> /dev/null; then
        echo "📦 Installing GitHub CLI..."
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update && sudo apt install gh -y
    fi
    
    # Install Node.js via NodeSource
    if ! command -v node &> /dev/null; then
        echo "📦 Installing Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
    
    # Install Docker if not present
    if ! command -v docker &> /dev/null; then
        echo "📦 Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        rm get-docker.sh
        echo "⚠️  Please log out and back in for Docker group changes to take effect"
    fi
}

# Install packages for macOS
install_macos_packages() {
    echo "📦 Installing macOS packages..."
    
    # Install Homebrew if missing
    if ! command -v brew &> /dev/null; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # Install from Brewfile
    if [ -f ~/.config/Brewfile ]; then
        cd ~/.config && brew bundle
    fi
}

OS=$(detect_os)
echo "🚀 Installing missing development tools for $OS..."

case $OS in
    "macos")
        install_macos_packages
        ;;
    "linux"|"wsl")
        install_linux_packages
        ;;
    *)
        echo "❌ Unsupported OS: $OS"
        exit 1
        ;;
esac

# Install uv (Python package manager) - works on all platforms
if ! command -v uv &> /dev/null; then
    echo "📦 Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Install ruff (Python linter) via pip if not available via package manager
if ! command -v ruff &> /dev/null; then
    echo "📦 Installing ruff..."
    pip3 install --user ruff
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
    if [[ "$OS" == "macos" ]]; then
        $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
    else
        # For Linux, fzf key bindings are typically in /usr/share/doc/fzf/examples/
        if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
            echo "source /usr/share/doc/fzf/examples/key-bindings.zsh" >> ~/.fzf.zsh
        fi
        if [ -f /usr/share/doc/fzf/examples/completion.zsh ]; then
            echo "source /usr/share/doc/fzf/examples/completion.zsh" >> ~/.fzf.zsh
        fi
    fi
fi

echo "✅ All tools installed!"
