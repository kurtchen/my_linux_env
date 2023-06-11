if [ -f ~/.bashrc.local.before ]; then
    source ~/.bashrc.local.before
fi

# PS1 {{{
function jobs_indicator() {
    local jobs_count=`jobs|wc -l`
    if [[ $jobs_count -gt 0 ]]; then
        echo "($jobs_count jobs) "
    fi
}

if [[ -n $PS1_SHOW_HOST && $PS1_SHOW_HOST -eq 1 ]]; then
    PS1='\[\e[0;32m\]\u@\h\[\e[m\] `jobs_indicator`\[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\n\$\[\e[m\] \[\e[1;37m\]'
else
    #PS1='\u@\w#'
    #PS1='\[\e[0;32m\]\u\[\e[m\] (\j jobs) \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\n\$\[\e[m\] \[\e[1;37m\]'
    #PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\n\$\[\e[m\] \[\e[1;37m\]'
    PS1='\[\e[0;32m\]\u\[\e[m\] `jobs_indicator`\[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\n\$\[\e[m\] \[\e[1;37m\]'
fi

# }}} // PS1

# Path {{{
if [ -n $MY_BIN ]; then
    export PATH=$MY_BIN:$PATH
fi
# }}} // Path

# ENV {{{
export LS_COLORS="di=01;32:fi=0:ln=0:pi=0:so=0:bd=0:cd=0:or=0:mi=0:ex=0:*.rpm=0"

# 256 color for tmux
export TERM=screen-256color
# }}} // ENV

# Alias {{{
alias vi='vim';
alias grep='grep --color';

#Git alias
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias gck='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias gdc='git -c core.whitespace=tab-in-indent diff'

alias got='git '
alias get='git '

alias gdv='git difftool --tool=vimdiff --no-prompt '

#Xterm & screen alias
alias xterm='xterm -u8 -e bash'
alias screen='screen -U '

alias tn='tnote'
alias wn='date +%V'

if [[ -n $GODADDY_USER && -n $GODADDY_HOST ]]; then
    alias gfw_ssh='ssh -2 -qTNfn -D 127.0.0.1:7001 $GODADDY_USER@$GODADDY_HOST'
fi

#Shortcuts
if [ -n $WORKSPACE_HOME ]; then
    alias ws='cd $WORKSPACE_HOME'
fi

# }}} // Alias

# Settings {{{
stty erase "^?"

set -o vi

# OS specific
OS="`uname`"
case $OS in
  'Linux')
    OS='Linux'
    alias ls='ls --color -F';
    ;;
  'FreeBSD')
    OS='FreeBSD'
    alias ls='ls -G'
    ;;
  'WindowsNT')
    OS='Windows'
    ;;
  'Darwin')
    OS='Mac'
    alias ls='ls -G'
    export PATH=/opt/local/bin:$PATH
    ;;
  'SunOS')
    OS='Solaris'
    ;;
  'AIX') ;;
  *) ;;
esac

# }}} // Settings

# Functions {{{

targrep() {

  local taropt=""

  if [[ ! -f "$2" ]]; then
    echo "Usage: targrep pattern file ..."
  fi

  while [[ -n "$2" ]]; do

    if [[ ! -f "$2" ]]; then
      echo "targrep: $2: No such file" >&2
    fi

    case "$2" in
      *.tar.gz) taropt="-z" ;;
      *) taropt="" ;;
    esac

    while read filename; do
      tar $taropt -xOf "$2" \
       | grep "$1" \
       | sed "s|^|$filename:|";
    done < <(tar $taropt -tf $2 | grep -v '/$')

  shift

  done
}

gsd(){
    gdv $1^ $1
}
export -f gsd

# mount the develop file image
function mountDevelop() {
    if [[ ! -d "/Volumes/develop" ]]; then
        hdiutil attach ~/develop.dmg.sparseimage -mountpoint /Volumes/develop
    fi
}
export -f mountDevelop

# unmount the develop file image
function umountDevelop() {
    if [[ -d "/Volumes/develop" ]]; then
        hdiutil detach /Volumes/develop
    fi
}
export -f umountDevelop

# explain.sh begins
explain () {
  if [ "$#" -eq 0 ]; then
    while read  -p "Command: " cmd; do
      curl -Gs "https://www.mankier.com/api/explain/?cols="$(tput cols) --data-urlencode "q=$cmd"
    done
    echo "Bye!"
  elif [ "$#" -eq 1 ]; then
    curl -Gs "https://www.mankier.com/api/explain/?cols="$(tput cols) --data-urlencode "q=$1"
  else
    echo "Usage"
    echo "explain                  interactive mode."
    echo "explain 'cmd -o | ...'   one quoted command to explain it."
  fi
}
export -f explain

# }}} // Settings

if [ -f ~/.bashrc.local.after ]; then
    source ~/.bashrc.local.after
fi
