. ~/.profile

# -------------- Aliases -------------- 
alias zshreset='exec zsh -l'
alias cd="pushd -q"

# -------------- Default -------------- 
autoload -U select-word-style
select-word-style bash

# -------------- Autocomplete -------------- 
autoload -Uz compinit
compinit
zstyle ':completion::complete:*' gain-privileges 1

# -------------- Prompt -------------- 
setopt promptsubst 

export RPROMPT=%0(?.'%F{green}:3%f'.'%? %F{red}:c%f')

# Enable the version control system
autoload -Uz vcs_info add-zsh-hook
# Set style of the vcs_info_msg_0_
zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:*' formats ' [%F{yellow}%b%f]'
# Always update before displaying the prompt
add-zsh-hook precmd vcs_info

PS1='%{$bg[green]$fg[black]%} λ %{$reset_color%}${vcs_info_msg_0_} %F{green}%18<\<<%/%f '

get_suffix() {
  local number="$1"

  printf "$number'"
  if [[ "$number" == "11" || "$number" == "12" || "$number" == "13" ]]; then
    echo "th"
  elif [[ "$number" == "1" ]]; then
    echo "st"
  elif [[ "$number" == "2" ]]; then
    echo "nd"
  elif [[ "$number" == "3" ]]; then
    echo "rd"
  else
    echo "th"
  fi
}

# -------------- Header -------------- 
# Load zsh colors
autoload colors
colors

# Append shell session header
case $INSIDE_EMACS in
  *comint*) print "Emacs shell $INSIDE_EMACS ..." ;;
  *)
  printf '\e]4;%d;?\a' 260
  if read -d $'\a' -s -t 1; then
    for x in {22..51}; do echo -n "\033[48;5;${x}m  "; done;  echo "\\033[m"
  fi
  ;;
esac
print $(get_suffix $(tty | grep -Eo '[0-9]?[0-9]?[0-9]')), "SESSION CONNECTED | ${(U)$(date +%d\ %A\ \|\ WEEK:\ %W)}\n"

# Append command execution time header
preexec() {
  case $INSIDE_EMACS in
    *comint*) ;;
    *) print $fg[green]"$(date +%a-%R) $(for x in {11..$(tput cols)}; do echo -n ─; done;)\e[0m"
    ;;
  esac
}

# For UNIX terminals ONLY. Can crash with the Linux Console!
#printf '\033[?112c'

# -------------- Directory -------------- 
# Remember the last 5 directories
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5
zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':chpwd:*' recent-dirs-file \
       ~/.chpwd-recent-dirs-${TTY##*/} +

# Generic/dynamic directory names
function dir() { zsh_directory_name_generic "$@" }
REPOS="$HOME/repos"
typeset -A zdn_association=(
    r   $REPOS
    or  $REPOS/or
    gh	$REPOS/github
    ghx	$REPOS/github-external
    gg	$REPOS/gitgud
    pb  $REPOS/paste-bin
    loc	$REPOS/local
    rem	$REPOS/remote
    fib $REPOS/fib
    doc $HOME/Documents
    em  ~/.emacs.d
)
zstyle ':zdn:dir:' mapping zdn_association
autoload -Uz add-zsh-hook zsh_directory_name_generic dir
add-zsh-hook -U zsh_directory_name dir

function cdg() {
    cd ~[$1]/$2
}

function _cdg {
  _arguments -C \
    '1:shortcut:_cdg_shortcut_keys' \
    '2:filename:_cdg_shortcut_paths'
}

# 4. Completion for first arg (shortcut key)
function _cdg_shortcut_keys {
  compadd -- ${(k)zdn_association}
}

function _cdg_shortcut_paths {
  local shortcut=$words[2]     # word[2] is the first argument to `cdg`
  local dirpath

  # Expand the shortcut using `~[$shortcut]`
  dirpath=$(print -r -- ~[$shortcut] 2>/dev/null)

  if [[ -d "$dirpath" ]]; then
    _files -W "$dirpath" -/
  fi
}

compdef _cdg cdg

# -------------- Custom Hooks -------------- 
# Say something before exit
local function byezsh() {
    print "ZSH exit $TTY. Bye $USER!"
}
add-zsh-hook zshexit byezsh

# -------------- Programming -------------- 
eval "$(~/.rbenv/bin/rbenv init - zsh)"
