# shellcheck shell=sh
if command -v pyenv >/dev/null 2>&1 && pyenv_setup="$(pyenv init --path)"; then
    eval "$pyenv_setup"
fi
unset pyenv_setup
