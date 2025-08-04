# Tool checker function
check_dev_tools() {
    local missing_tools=()
    local tools_to_check=(
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
