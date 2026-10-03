#!/usr/bin/env bash
set -euo pipefail

# Add fork-specific TUI settings on top of the normal OpenCode configuration.
# Prefer the mutable live copy (theme switching writes there); the repo file
# is a static template used only to seed it on first run.
_ocv_tui_cfg="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/ocv-tui.json"
[ -f "$_ocv_tui_cfg" ] || cp "$HOME/dotfiles/config/opencode/ocv-tui.json" "$_ocv_tui_cfg"
export OPENCODE_TUI_CONFIG="$_ocv_tui_cfg"
unset _ocv_tui_cfg
exec "$HOME/.ocv/bin/ocv" "$@"
