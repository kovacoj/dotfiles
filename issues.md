# Open issues

## 1. `Ctrl+Backspace` does not delete the previous word

- Expected:
  - `Ctrl+Backspace` deletes the previous word in zsh.
- Actual:
  - It still does not behave like native backward word deletion.
- Current context:
  - zsh bindings were added for common `Ctrl+Backspace` escape sequences.
  - tmux passthrough for `C-BSpace` was added.
  - `xterm-keys` is enabled in tmux.
  - The terminal may be sending a different escape sequence or not sending a distinct `Ctrl+Backspace` sequence at all.
