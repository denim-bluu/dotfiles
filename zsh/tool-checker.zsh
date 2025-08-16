# Tool checker function
check_dev_tools() {
    local missing_tools=()
    local tools_to_check=()
    
    # Platform-specific tool lists
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS tools
        tools_to_check=(
            "brew:Homebrew:Run '/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"'"
            "oh-my-posh:Oh My Posh:brew install oh-my-posh"
            "uv:uv (Python package manager):curl -LsSf https://astral.sh/uv/install.sh | sh"
            "ruff:Ruff (Python linter):brew install ruff"
            "fzf:fzf (fuzzy finder):brew install fzf"
            "bat:bat (better cat):brew install bat"
            "eza:eza (better ls):brew install eza"
            "zoxide:zoxide (better cd):brew install zoxide"
            "lazydocker:lazydocker:brew install lazydocker"
            "direnv:direnv:brew install direnv"
            "rg:ripgrep:brew install ripgrep"
        )
    else
        # Linux/WSL tools
        tools_to_check=(
            "oh-my-posh:Oh My Posh:curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin"
            "uv:uv (Python package manager):curl -LsSf https://astral.sh/uv/install.sh | sh"
            "ruff:Ruff (Python linter):pip3 install --user ruff"
            "fzf:fzf (fuzzy finder):sudo apt install fzf"
            "bat:bat (better cat):sudo apt install bat"
            "eza:eza (better ls):Install via: wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg && echo 'deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main' | sudo tee /etc/apt/sources.list.d/gierens.list && sudo apt update && sudo apt install eza"
            "zoxide:zoxide (better cd):curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash"
            "direnv:direnv:curl -sfL https://direnv.net/install.sh | bash"
            "rg:ripgrep:sudo apt install ripgrep"
            "gh:GitHub CLI:See https://cli.github.com/manual/installation#debian-ubuntu-linux-raspberry-pi-os-apt"
            "node:Node.js:curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs"
        )
    fi
    
    for tool_info in "${tools_to_check[@]}"; do
        IFS=':' read -r cmd name install_cmd <<< "$tool_info"
        if ! command -v "$cmd" &> /dev/null; then
            missing_tools+=("$name|$install_cmd")
        fi
    done
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo "🔧 Missing development tools detected:"
        echo ""
        for tool in "${missing_tools[@]}"; do
            IFS='|' read -r name install_cmd <<< "$tool"
            echo "  ❌ $name"
            echo "     Install with: $install_cmd"
            echo ""
        done
        echo "💡 Tip: Run 'update-tools' to install all missing tools"
    fi
}

# Check once per day
LAST_CHECK_FILE="$HOME/.cache/zsh_tools_last_check"
mkdir -p "$HOME/.cache"

if [ ! -f "$LAST_CHECK_FILE" ] || [ $(find "$LAST_CHECK_FILE" -mtime +1 -print 2>/dev/null) ]; then
    check_dev_tools
    date > "$LAST_CHECK_FILE"
fi
