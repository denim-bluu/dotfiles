# My Dotfiles

Personal development environment configuration for macOS and WSL2/Ubuntu.

## Quick Setup

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Run the install script
cd ~/dotfiles
./install.sh

# Install all tools
./scripts/update-tools.sh

# Reload your shell
source ~/.zshrc
```

## Supported Platforms

- **macOS** - Uses Homebrew for package management
- **WSL2/Ubuntu** - Uses apt and direct installs for packages

## What's Included

### Shell Enhancement
- **zsh** with modern plugins (autosuggestions, syntax highlighting, completions)
- **oh-my-posh** for beautiful prompts
- **fzf** for fuzzy finding
- **zoxide** for smart directory navigation
- **direnv** for project-specific environment variables

### Development Tools
- **Git** with sensible defaults
- **GitHub CLI** for Git operations
- **Node.js** and **npm** for JavaScript development
- **Python 3** with **pipx**, **uv**, **ruff** for Python development
- **Docker** and **docker-compose** for containerization

### Better CLI Tools
- **bat** (better cat)
- **eza** (better ls)
- **ripgrep** (better grep)
- **htop/btop** (better top)
- **jq/yq** for JSON/YAML processing

## Platform-Specific Notes

### macOS
- Uses Homebrew package manager
- All tools installed via `brew install`
- Supports Apple Silicon and Intel Macs

### WSL2/Ubuntu
- Uses apt package manager for system packages
- Some tools installed via direct downloads/scripts
- Includes Docker setup (requires logout/login for group changes)
- Compatible with Ubuntu 20.04+ and WSL2

## Manual Configuration

After installation, you may want to:

1. **Update git config** with your details:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

2. **Configure Claude CLI** (if you use it):
   - macOS: Already configured for `/Users/joonkang/.claude/local/claude`
   - Linux/WSL: Will auto-detect if installed in `$HOME/.claude/local/claude`

3. **Set up additional tools**:
   - Run `check-tools` to see missing development tools
   - Run `update-tools` to install all missing tools
