setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_to_home

setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_find_no_dups

HISTSIZE="10000"
SAVEHIST="10000"
HISTFILE="$HOME/.zsh_history"

typeset -U path cdpath fpath manpath

function has() {
  command -v "${1}" >/dev/null 2>&1
}

if has fzy ; then
  function __fzy_execute_from_history() {
    BUFFER="$(fc -l -n 1 | sort -u | fzy --query "${LBUFFER}")"
    CURSOR=$#BUFFER
    zle -R -c
  }

  zle -N __fzy_execute_from_history
  bindkey '^P' __fzy_execute_from_history
fi

eval "$(starship init zsh)"

alias - l="ls --color -F -lah"
alias - ls="ls --color -F"
