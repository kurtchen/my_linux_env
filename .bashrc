if [ -f ~/.bashrc.local.local ]; then
    source ~/.bashrc.local.local
fi

#PS1='\u@\w#'
PS1='\[\e[0;32m\]Kurt\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'

#Path
if [ -n $MY_BIN ]; then
    export PATH=$MY_BIN:$PATH
fi

if [ -n $VIM_HOME ]; then
    export PATH=$VIM_HOME/bin:$PATH
fi

if [ -n $CSCOPE_HOME ]; then
    export PATH=$CSCOPE_HOME/bin:$PATH
fi

if [ -n $SCREEN_HOME ]; then
    export PATH=$SCREEN_HOME/bin:$PATH
fi

if [ -n $JYTHON_HOME ]; then
    export PATH=$JYTHON_HOME/bin:$PATH
fi

if [ -n $MERCURIAL_HOME ]; then
    export PATH=$MERCURIAL_HOME:$PATH
fi

if [ -n $MAVEN_HOME ]; then
    export PATH=$MAVEN_HOME/bin:$PATH
fi

if [ -n $GRADLE_HOME ]; then
    export PATH=$GRADLE_HOME/bin:$PATH
fi

if [ -n $GRADLE_HOME ]; then
    export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
    export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/jre/lib/rt.jar
fi

if [ -n $ANT_HOME ]; then
    export PATH=$ANT_HOME/bin:$PATH
fi

if [ -n $ANDROID_HOME ]; then
    export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH
    if [ -n $ANDROID_SDK_VERSION ]; then
        export PATH=$ANDROID_HOME/build-tools/$ANDROID_SDK_VERSION:$PATH
    fi
fi

if [ -n $MAVEN_HOME ]; then
    export PATH=$MAVEN_HOME/bin:$PATH
fi

export LS_COLORS="di=01;32:fi=0:ln=0:pi=0:so=0:bd=0:cd=0:or=0:mi=0:ex=0:*.rpm=0"

#Alias
alias vi='vim';
alias ls='ls --color -F';
alias grep='grep --color';

#Git alias
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias gdc='git -c core.whitespace=tab-in-indent diff'

alias got='git '
alias get='git '

alias gdv='git difftool --tool=vimdiff --no-prompt '

#Xterm & screen alias
alias xterm='xterm -u8 '
alias screen='screen -U '

#Shortcuts
if [ -n $WORKSPACE_HOME ]; then
    alias ws='cd $WORKSPACE_HOME'
fi

if [ -n $PYGMENTS_HOME ]; then
    alias ccat='$PYGMENTS_HOME/pygmentize'
fi

# 256 color
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

stty erase "^?"

set -o vi

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

xtitle(){
    local title="${USER}@${HOSTNAME}: ${PWD};"
    if [[ -n $1 ]]; then
        title=$1
    fi

    echo -ne "\033]0;$title\007"
}

export -f xtitle
