# -------------- Sane Defaults
# Only change this value when planning on expensive sorting or search algorithm
FUNCNEST=400

# If EDITOR is not set to emacs some terminals do not support emacs-mode properly
set editing-mode emacs
export EDITOR=emacs
export BROWSER=firefox
export YUNK=~/.local/share/yunk
export WALLPAPER=~/Pictures/Wallpaper/howls-castle.jpg
export UNIT_SCREEN=eDP1

# Set terminal default colors
eval "$(dircolors)"

# Create yunk directory if not found
mkdir -p $YUNK

# -------------- Aliases
# Crystal
alias icr='crystal i'
alias crrun='crystal run'
alias crmk='crystal build'

# Standard
alias ls='ls --color=auto'
alias l='ls -l'
alias la='ls -la'
alias ly=~/.lsy.sh
alias rm=~/.dwimrm.sh
alias quit=exit
alias clear=c
# Show a nice, clean tree
alias tree="tree -IC '*[~#]|CMakeFiles|build'"

# Applications
alias game="cd $HOME/.local/share/Steam/steamapps/common/"
alias code='emacsclient -n'
alias alpine=$HOME/repos/pastebin/alpine/alpine/alpine
alias vim=nvim

# -------------- Commands
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
