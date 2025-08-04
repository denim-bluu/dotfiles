# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# Tool replacements (only if installed)
command -v bat &> /dev/null && alias cat='bat'
command -v eza &> /dev/null && {
    alias ls='eza --icons'
    alias ll='eza -l --icons'
    alias la='eza -la --icons'
    alias tree='eza --tree --icons'
}
command -v rg &> /dev/null && alias grep='rg'

# Python aliases
alias py='python'
alias venv='python -m venv .venv && source .venv/bin/activate'
alias activate='[ -f .venv/bin/activate ] && source .venv/bin/activate || echo "No .venv found"'
alias deactivate='deactivate 2>/dev/null || echo "No virtual environment active"'

# Docker aliases (if docker is installed)
command -v docker &> /dev/null && {
    alias dc='docker compose'
    alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
    alias dclean='docker system prune -af'
    alias dlogs='docker logs -f'
    alias dexec='docker exec -it'
}

# Git aliases (complement oh-my-zsh git plugin)
alias gcm='git commit -m'
alias gst='git status'
alias gd='git diff'
alias gds='git diff --staged'

# Utility aliases
alias reload='source ~/.zshrc'
alias zshconfig='${EDITOR:-vim} ~/.zshrc'
alias ohmyposh='${EDITOR:-vim} ~/.config/oh-my-posh/theme.json'

# Claude alias (keep your existing one)
alias claude="/Users/joonkang/.claude/local/claude"

# Update functions
alias update-tools='$HOME/.config/scripts/update-tools.sh'
alias check-tools='check_dev_tools'
