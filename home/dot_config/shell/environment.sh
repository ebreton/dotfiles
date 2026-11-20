# shellcheck shell=sh
# Recheck the PATH after macOS login startup, which can reorder inherited entries.
brew_shell=bash
if [ -n "${ZSH_VERSION:-}" ]; then
    brew_shell=zsh
fi
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$brew_bin" ] && brew_setup="$("$brew_bin" shellenv "$brew_shell")"; then
        eval "$brew_setup"
        break
    fi
done
unset brew_bin brew_setup brew_shell

export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$HOME/.config/starship.toml}"
export POETRY_VIRTUALENVS_IN_PROJECT=true
if command -v code >/dev/null 2>&1; then
    export EDITOR="${EDITOR:-code --wait}"
fi
