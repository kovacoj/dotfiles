#!/usr/bin/env bash
set -euo pipefail

# Add fork-specific TUI settings on top of the normal OpenCode configuration.
export OPENCODE_TUI_CONFIG="$HOME/dotfiles/config/opencode/ocv-tui.json"
exec "$HOME/.ocv/bin/ocv" "$@"
