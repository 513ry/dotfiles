#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

PS1='[\u@\h \W]\$ '

# Print session header
echo "Running bash v.$BASH_VERSION"
echo "$(compgen -c | wc -l) executables and $(compgen -a | wc -l) aliases"
