#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export LANG="pl_PL.UTF-8 UTF-8"
export HISTFILESIZE=100000
export HISTSIZE=100000

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export EDITOR="vim"
export PS1="\[\033[1;38m\](\$(date +%H:%M:%S))\[\033[34m\]<\u@\h:\w>\[\033[0m\] "
#export AVIPLUGIN_PATH="/usr/lib/avifile-0.7"
alias playonlinux='optirun playonlinux'
alias make='make -j 8'
alias grep='grep --color'
alias sc='cat ~/.bash_history | grep -i '
alias cls='printf "\033c"'
alias gpush='printf "Commit message: " && read c && git commit -am "$c" && git pull && git push -u origin master'

xset b off

