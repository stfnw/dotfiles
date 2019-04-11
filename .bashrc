#!/bin/bash

# autostart x
[[ ! $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# automatically start tmux (if not already in tmux)
command -v tmux > /dev/null && [[ -z "$TMUX" ]] && exec tmux

# automatically record each session with util-linux's script
if [[ ( -z "$NOSCRIPT" ) \
    && ( ! "$(ps -ocommand= -p $PPID | awk '{print $1}')" == 'script') \
    && (-z "$SCRIPT_SESSION_BASE" ) ]]; then
    # if inside tmux, save id of session, window and pane
    [[ -n "$TMUX" ]] && TMUX_DATA=$(tmux display-message -p '#{session_id}-#{window_id}-#{pane_id}')
    base="$(date +"%Y-%m-%d_%H-%M-%S")_${USER}_${HOSTNAME}_$$_${TMUX_DATA}"
    dir=~/.cache/log/script-sessions
    mkdir -p "$dir"
    export SCRIPT_SESSION_BASE="${dir}/${base}"
    SCRIPT_SESSION_TIMING="${SCRIPT_SESSION_BASE}.timing"
    SCRIPT_SESSION_RECORD="${SCRIPT_SESSION_BASE}.record"

    exec script --quiet --timing="$SCRIPT_SESSION_TIMING" "$SCRIPT_SESSION_RECORD"
fi

export EDITOR=vim
export SUDO_EDITOR=vim
export VISUAL=vim
export TERM=xterm-256color

export HISTSIZE=2500
export HISTFILESIZE=2500
shopt -s histappend         # append to the history file, don't overwrite it
shopt -s checkwinsize       # check window size/update LINES and COLUMNS after each command

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
else
    PS1='\u@\h:\W\$ '
fi
unset color_prompt

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# enable auto-completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# alias and function definitions
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -f ~/.bash_aliases_costly ]] && . ~/.bash_aliases_costly
[[ -f ~/.bash_aliases_host_specific ]] && . ~/.bash_aliases_host_specific
