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

alias ii="git status && git branch -v"
alias gf="find . | grep -i "
alias gg='git grep -n'
alias gga='git grep -A 5 -n'
alias ggb='git grep -B 5 -n'
alias ggab='git grep -A 5 -B 5 -n'
alias ch='tail -n 10 ~/.bash_history'

function mb() {
    cat "$(git rev-parse --show-toplevel)/.main-branch" || echo master
}

function mmc() {
    git checkout $(mb)
}

function ii() {
    git status
    git branch -v
}

function aa() {
    git add -u
    git status && read -p 'Press any key to continue... ' -n1 -s || return 1
}

function am() {
    aa || return 1
    git commit --amend || return 1
}

function mm() {
    if [ "$(git rev-parse --abbrev-ref HEAD)" != "$(mb)" ] ;
    then
        if ! git diff --exit-code ;
        then
            aa || return 1
            git commit --amend --no-edit
        fi
    fi
    #git rebase origin/$(mb)
    git checkout $(mb) && git pull origin $(mb) || return 1
}

function startb() {
    if [ -z "$1" ]; then
        echo "no branch specified."
        return 1
    fi
    mm
    echo "branch: $1"
    git checkout -b "$1" $(mb) || return 1
    ( git commit --allow-empty -m "$(echo $@)" ) || return 1
    ii
}

function bb() {
    if [ -z "$1" ]; then
        echo "no branch specified."
        return 1
    fi
    mm
    echo "branch: $1"
    git checkout "$1" || return 1
    #git fetch && git checkout origin/master || return 1
    echo "SUCCESS"
    rb || return 1
    ii
}

function rb() {
    git rebase $(mb) || return 1
}

function cc() {
    git diff
    ii
    aa || return 1
    #echo -n "branch: "
    #read $branch
    git commit --amend && git push -f origin "HEAD:$(git rev-parse --abbrev-ref HEAD)" || return 1
    # origin "HEAD:/refs/for/$branch"
    #mm || return 1
}

function elo() {
    mm || return 1
}

XSET=$(which xset 2> /dev/null)
if [ -f "$XSET" ] ;
then
    xset b off
fi


