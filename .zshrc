. ~/.profile

# -------------- Aliases -------------- 
alias zshreset='exec zsh -l'
alias cd="pushd -q"

# -------------- Default -------------- 
autoload -U select-word-style
select-word-style bash

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

PS1='%{$bg[green]$fg[black]%} λ %{$reset_color%}${vcs_info_msg_0_} %18<..<%F{green}%/%f '

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
declare session=$(tty | grep -Eo '[0-9]?[0-9]?[0-9]')
print "${(U)session} SESSION CONNECTED | ${(U)$(date +%d\ %A\ \|\ WEEK:\ %W)}\n"

# Append command execution time header
preexec() {
  case $INSIDE_EMACS in
    *comint*) ;;
    *) print $fg[green]"$(date +%a-%R) $(for x in {11..$(tput cols)}; do echo -n ⏤; done;)\e[0m"
    ;;
  esac
}

# For UNIX terminals ONLY. Can crash with Linux Console!
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
REPOS="$(realpath ~/)/repos"
typeset -A zdn_association=(
    r	$REPOS
    gh	$REPOS/github
    ghx	$REPOS/github-external
    gg	$REPOS/gitgud
    pb  $REPOS/paste-bin
    loc	$REPOS/local
    rem	$REPOS/remote
    em  ~/.emacs.d
)
zstyle ':zdn:dir:' mapping zdn_association
autoload -Uz add-zsh-hook zsh_directory_name_generic dir
add-zsh-hook -U zsh_directory_name dir

function cdg() {
    cd ~[$1]/$2
}

# -------------- Autocomplete -------------- 
autoload -Uz compinit
compinit
zstyle ':completion::complete:*' gain-privileges 1

# -------------- Custom Hooks -------------- 
# Say something before exit
local function byezsh() {
    print "ZSH exit $TTY. Bye $USER!"
}
add-zsh-hook zshexit byezsh

# -------------- Programming -------------- 
eval "$(~/.rbenv/bin/rbenv init - zsh)"
