# Tool checker function
check_dev_tools() {
    if [ -f "$HOME/.config/scripts/platform.sh" ]; then
        source "$HOME/.config/scripts/platform.sh"
        dotfiles_export_platform
    fi
    local missing_tools=()
    local platform="${DOTFILES_PLATFORM:-generic}"
    local tools_to_check=(
        "oh-my-posh^Oh My Posh^brew install oh-my-posh^sudo apt install -y oh-my-posh"
        "uv^uv (Python package manager)^curl -LsSf https://astral.sh/uv/install.sh | sh^curl -LsSf https://astral.sh/uv/install.sh | sh"
        "ruff^Ruff (Python linter)^brew install ruff^python3 -m pip install --user ruff"
        "fzf^fzf (fuzzy finder)^brew install fzf^sudo apt install -y fzf"
        "bat^bat (better cat)^brew install bat^sudo apt install -y bat"
        "eza^eza (better ls)^brew install eza^sudo apt install -y eza"
        "zoxide^zoxide (better cd)^brew install zoxide^sudo apt install -y zoxide"
        "lazydocker^lazydocker^brew install lazydocker^curl -fsSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash"
        "direnv^direnv^brew install direnv^sudo apt install -y direnv"
        "rg^ripgrep^brew install ripgrep^sudo apt install -y ripgrep"
    )

    if [[ "$platform" == "macos" ]]; then
        tools_to_check=(
            "brew^Homebrew^/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"^/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            "${tools_to_check[@]}"
        )
    fi

    for tool_info in "${tools_to_check[@]}"; do
        IFS='^' read -r cmd name mac_install linux_install <<< "$tool_info"
        if ! command -v "$cmd" &> /dev/null; then
            local install_cmd="$mac_install"
            if [[ "$platform" != "macos" ]]; then
                install_cmd="${linux_install:-$mac_install}"
            fi
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
