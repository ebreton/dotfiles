# shellcheck shell=sh
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -lFG'
alias la='ls -laFG'

mkd() {
    if [ "$#" -ne 1 ] || [ -z "$1" ]; then
        printf 'Usage: mkd DIRECTORY\n' >&2
        return 2
    fi
    case $1 in
        /*) mkdir -p -- "$1" && cd -- "$1" || return ;;
        *) mkdir -p -- "./$1" && cd -- "./$1" || return ;;
    esac
}
