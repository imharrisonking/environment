source ~/environment/custom/environment

. "$HOME/.cargo/env"
# bob-nvim global PATH (added)
export PATH="$HOME/.cargo/bin:$HOME/.local/share/bob/nvim-bin:$PATH"
# Per-directory auto switch if available (safe no-op)
if command -v bob >/dev/null 2>&1; then
  bob use >/dev/null 2>&1 || true
fi
