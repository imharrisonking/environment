#!/bin/bash
# Neovim LSP log cleanup script
# Clears LSP log if it exceeds 10MB to prevent disk space issues

set -e

LOG_FILE="$HOME/.local/state/nvim/lsp.log"
MAX_SIZE_MB=10
MAX_SIZE_BYTES=$((MAX_SIZE_MB * 1024 * 1024))

if [[ -f "$LOG_FILE" ]]; then
    current_size=$(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null)
    
    if [[ $current_size -gt $MAX_SIZE_BYTES ]]; then
        echo "$(date): LSP log file is $(($current_size / 1024 / 1024))MB, clearing..." >> "$HOME/.local/state/nvim/log-cleanup.log"
        echo "LSP log cleared on $(date) - was $(($current_size / 1024 / 1024))MB" > "$LOG_FILE"
        echo "LSP log cleared successfully"
    else
        echo "LSP log size OK: $(($current_size / 1024))KB"
    fi
else
    echo "LSP log file does not exist"
fi