#!/usr/bin/env bash
set -euo pipefail

# Simple installer/updater for bob-nvim (Neovim version manager)
# Installs Rust toolchain if missing, installs/updates bob-nvim, then installs and activates stable Neovim.
# Idempotent: safe to re-run.

# Configuration
BOB_BIN_DIR="$HOME/.local/share/bob/nvim-bin"
RUST_ENV="$HOME/.cargo/env"

need_cmd() { command -v "$1" >/dev/null 2>&1; }

log() { printf "[bob-setup] %s\n" "$*"; }

die() { log "ERROR: $*" >&2; exit 1; }

install_rust() {
  log "Installing Rust toolchain (rustup) ..."
  curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal
  # shellcheck disable=SC1090
  source "$RUST_ENV"
}

ensure_rust() {
  if ! need_cmd cargo; then
    install_rust
  else
    # shellcheck disable=SC1090
    source "$RUST_ENV" 2>/dev/null || true
    log "Rust toolchain present: $(cargo --version)"
  fi
}

ensure_bob() {
  if need_cmd bob; then
    log "Updating bob-nvim ..."
    cargo install bob-nvim --locked --force
  else
    log "Installing bob-nvim ..."
    cargo install bob-nvim --locked
  fi
}

install_neovim_versions() {
  local versions=(stable)
  for v in "${versions[@]}"; do
    log "Ensuring Neovim version '$v' is installed via bob ..."
    if bob list | grep -q "^$v$"; then
      log "Version '$v' already installed; updating if newer available ..."
      bob install "$v" || true
    else
      bob install "$v"
    fi
  done
  log "Activating 'stable' ..."
  bob use stable
}

update_shell_config() {
  local shell_rc
  # Pick a shell rc file to modify (non-destructive append)
  if [[ -n ${ZSH_VERSION:-} ]]; then
    shell_rc="$HOME/.zshrc"
  else
    shell_rc="$HOME/.bashrc"
  fi
  local export_lines='export PATH="$HOME/.cargo/bin:$PATH"\nexport PATH="$HOME/.local/share/bob/nvim-bin:$PATH"'
  if ! grep -Fq "bob/nvim-bin" "$shell_rc" 2>/dev/null; then
    log "Appending PATH updates to $shell_rc"
    {
      echo "# Added by bob-nvim setup (Neovim version manager)"
      echo -e "$export_lines"
      echo 'bob use >/dev/null 2>&1 || true'
    } >>"$shell_rc"
  else
    log "Shell rc already contains bob PATH entries; skipping."
  fi
}

verify() {
  log "Verification:"
  if ! need_cmd nvim; then
    log "nvim not on PATH after install (expected). Add PATH manually or open new shell." && return 1
  fi
  log "nvim path: $(command -v nvim)"
  nvim --version | head -n 1
  bob list
}

main() {
  ensure_rust
  ensure_bob
  mkdir -p "$BOB_BIN_DIR"
  install_neovim_versions
  update_shell_config || true
  verify
  log "Setup complete. Open a new shell or source your rc to use updated PATH."
}

main "$@"
