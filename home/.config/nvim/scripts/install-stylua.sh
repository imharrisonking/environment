#!/usr/bin/env bash
set -euo pipefail

# Install stylua formatter via cargo (fallback if Mason fails)
# Requires Rust toolchain (cargo).

if ! command -v cargo >/dev/null 2>&1; then
  echo "cargo (Rust) not found. Install Rust first (rustup)" >&2
  exit 1
fi

VERSION="0.20.0"
CRATE_BIN="stylua"

# Try cargo install first (compiles from source)
if command -v stylua >/dev/null 2>&1; then
  echo "stylua already installed: $(stylua --version)" >&2
  exit 0
fi

echo "Installing stylua ${VERSION} via cargo (this may take a moment)..."
CARGO_TERM_COLOR=always cargo install stylua --locked --version "${VERSION}" || {
  echo "cargo install failed; attempting binary download..." >&2
  TMPDIR=$(mktemp -d)
  cd "$TMPDIR"
  ARCH="linux-x86_64"
  URL="https://github.com/JohnnyMorganz/StyLua/releases/download/v${VERSION}/stylua-${ARCH}.zip"
  curl -fL "$URL" -o stylua.zip
  unzip -q stylua.zip
  install -m 755 stylua "$HOME/.local/bin/stylua"
  echo "Installed stylua binary to ~/.local/bin/stylua"
}

if command -v stylua >/dev/null 2>&1; then
  echo "stylua installation successful: $(stylua --version)" >&2
else
  echo "stylua installation failed" >&2
  exit 1
fi
