#PS1='\u@\w#'
PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'

#Path
export PATH=/home/kurt/bin:/home/kurt/bin/cscope/bin:/home/kurt/bin/screen/bin:$PATH
export PATH=/home/kurt/bin/jython2.7b1/bin:$PATH
export PATH=/home/kurt/bin/mercurial-2.8-rc:$PATH
export PATH=/home/kurt/bin/schedtool-1.3.0:$PATH
export PATH=/home/kurt/bin/apache-maven-3.0.5/bin:$PATH
#export PATH=/home/kurt/bin/apache-maven-3.1.1/bin:$PATH
export PATH=/home/kurt/bin/gradle-1.8/bin:$PATH

export JAVA_HOME=/home/kurt/bin/jdk1.7.0_45
export CLASSPATH=.:%JAVA_HOME/lib/tools.jar:%JAVA_HOME/jre/lib/rt.jar
export PATH=$JAVA_HOME/bin:$PATH

export ANT_HOME=/home/kurt/bin/apache-ant-1.9.2
export PATH=$ANT_HOME/bin:$PATH

export ANDROID_HOME=/home/kurt/bin/android-sdk

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

alias got='git '
alias get='git '

alias gdv='git difftool --tool=vimdiff --no-prompt '

#Xterm & screen alias
alias xterm='xterm -u8 '
alias screen='screen -U '

#Shortcuts
alias ws='cd /home/kurt/develop'

#export DISPLAY=xxx:99

# 256 color
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

#export GODADDY=xxx

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
