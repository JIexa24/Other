# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

RED="\033[1;31m"
GRE="\033[1;32m"
YEL="\033[1;33m"
BLU="\033[1;34m"
LBL="\033[1;36m"
DEF="\033[1;00m"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000000
HISTFILESIZE=200000000
HISTFILE=~/.bash_history
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color|screen*) color_prompt=yes;;
    xterm) color_prompt=no;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
  if [ "$UID" == 0 ] ; then
    PS1="\[${DEF}\]${debian_chroot:+($debian_chroot)}\[${RED}\]\u\[${DEF}\]@\[${BLU}\]\h\[${YEL}\]:\[${LBL}\]\W \[${YEL}\][\@] \[${RED}\]\$(parse_git_branch)\[${RED}\]#\[${DEF}\] "
  else
    PS1="\[${DEF}\]${debian_chroot:+($debian_chroot)}\[${GRE}\]\u\[${DEF}\]@\[${BLU}\]\h\[${YEL}\]:\[${LBL}\]\W \[${YEL}\][\@] \[${RED}\]\$(parse_git_branch)\[${GRE}\]$\[${DEF}\] "
  fi
else
  if [ "$UID" == 0 ] ; then
    PS1="${debian_chroot:+($debian_chroot)}\u@\h:\W# "
  else
    PS1="${debian_chroot:+($debian_chroot)}\u@\h:\W$ "
  fi
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm);;
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [ ! -z ${MC_TMPDIR} ]; then
  export PS1="\[${RED}\](mc) ${PS1}"
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

parse_git_branch() {
    git_branch=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')
    if [[ $git_branch ]]; then
    echo "[$git_branch] "
    else
    echo ""
    fi
}

alias l='ls -lahX'
alias sbash='source ~/.bashrc'
alias disp='export DISPLAY=:0'
alias path='echo -e ${PATH//:/\\n}'
alias cssh='wrap_ssh(){ ssh $*; printf "\n[$(date)] : Disconnect.\n";  unset -f wrap_ssh; }; wrap_ssh'

export HISTTIMEFORMAT="%d/%m/%y %T "
export PROMPT_COMMAND='printf "%%%$((COLUMNS-1))s\\r"'

# User specific aliases and functions
if [ -d ${HOME}/.bashrc.d ]; then
        for rc in ${HOME}/.bashrc.d/*.sh; do
                if [ -f "$rc" ]; then
                        . "$rc"
                fi
        done
fi
unset rc
