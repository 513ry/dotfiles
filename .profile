# Set modules on/off
#twitch on
#rvm    on

# Sane Defaults
FUNCNEST=400              # Just change this value in your script when planing
                          # on some extensive sorting or search algorithm
set editing-mode emacs    # All the emacsy stuff
export EDITOR=emacsclient
export BROWSER=firefox

SCREEN='dp-4'

# Set terminal default colors
eval "$(dircolors)"

# -------------- Aliases -------------- 
# Crystal
alias crrun='crystal run'
alias crmk='crystal build'
# Standards
alias ls='ls --color=auto'
alias l='ls -l'
alias la='ls -la'
alias quit=exit
alias clear=c
# Show a nice, clean tree
alias tree="tree -IC '*[~#]'"
alias game="cd $HOME/.local/share/Steam/steamapps/common/" 
alias code='emacsclient -n'
# Applications
alias alpine=$HOME/repos/pastebin/alpine/alpine/alpine
alias xrun=nvidia-xrun

# -------------- Commands -------------- 
function today() {
  lslogins -Lc | grep -E '.*::[0-9]+:[0-9]+'
}

function logins() {
  lslogins -Lc | grep -E '.*::.*[0-9]+:[0-9]+'
}

function c() {
  printf "\e[H\e[2J"
}

function duck() {
  arg=$@
  lynx "https://duckduckgo.com/?q=$arg"
}

function reset_vga0() {
  SCREEN := "VGA-0"
  echo ${SCREEN}
  xrandr --output ${SCREEN} --auto
  sleep 1
  xrandr --output ${SCREEN} --mode 1920x1080
}

# -------------- Expand PATH -------------- 
for x in $(realpath $(eval echo $(go env GOBIN))); do
  case ":$PATH:" in
    *":$x"*) :;;
    *) PATH+=:$x;;
  esac
done
