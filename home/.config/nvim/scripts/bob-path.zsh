# bob-nvim PATH setup for zsh
# Source this from your ~/.zshrc (after any PATH resets)
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
# Auto-switch if .nvim-version present
bob use >/dev/null 2>&1 || true
