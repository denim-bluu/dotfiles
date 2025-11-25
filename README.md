# My Dotfiles

Personal development environment configuration for macOS and WSL2.

## Repository Layout

- `install.sh` – bootstraps symlinks into `$HOME` and `.config`, exporting the detected platform.
- `scripts/platform.sh` – shared platform detection helpers used by the shells and scripts.
- `scripts/update-tools.sh` – installs common CLI tools via Homebrew or apt, plus language tooling.
- `zsh/zshrc` – main Zsh configuration (plugins, PATH, prompt, shared helpers).
- `zsh/aliases.zsh` – convenience aliases that only load when the related tool exists.
- `zsh/tool-checker.zsh` – daily reminder for missing tools with platform-aware install hints.
- `oh-my-posh/theme.json` – prompt theme consumed by `oh-my-posh`.
- `Brewfile` – Homebrew bundle definition for macOS / Homebrew setups.
- `git/gitconfig` – optional Git configuration symlinked when present.

## Quick Setup

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Run the install script
cd ~/dotfiles
./install.sh

# Install all tools (detects macOS vs. WSL2 automatically)
./scripts/update-tools.sh

# Reload your shell
source ~/.zshrc
