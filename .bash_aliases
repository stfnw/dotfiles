#!/bin/bash

################################################################################
# contains aliases and functions ###############################################
################################################################################

alias rm=trash                                          # safeguard from deleting files

alias grep='grep --color'                               # colored output
alias egrep='egrep --color'
alias ls='ls --color'
alias diff='diff --color'

alias python='python3'                                  # default to python3

alias c="export LANG=C && export LC_ALL=C"              # disable locale translations

alias dtt="date --iso-8601=s | tr ':' '-'"              # date suitable for tar (without ':')

alias cl='xclip -selection clipboard'                   # copy to x clipboard


# search text in all pdf files in the current directory (recursive)
pdfs() {
    find . -iname '*.pdf' -exec sh -c 'pdftotext "$0" - | grep --with-filename --label="$0" --ignore-case --color "$1"' '{}' "$1" \;
}


# display qrcode from string: usage e.g. `qr test`
qr() {
    qrencode -s 10 "$1" -o - | display
}


# get filename derived from url
_urlname() {
    printf '%s' "$1" | tr -c '[:alnum:][:blank:]' '_'
}

# convert html to markdown
mdify() {
    url="$1"
    outfile="$(_urlname "$url").md"
    pandoc -f html -t markdown_github-raw_html <(curl -L "$url") -o "$outfile"
}

# curl with readable name
ncurl() {
    curl "$1" -o "$(_urlname "$1")"
}

# wget single page (including dependencies) with readable name
nwget() {
    dir="$(_urlname "$1")" && mkdir "$dir"
    wget -P "$dir" -E -H -k -K -p "$1"
}


# record terminal session with script
rts() {
  if [[ ! -z "$1" ]]; then
    base="$1"
  else
    base="$(date -Is)"
  fi

  timing="${base}.timing"
  record="${base}.record"

  script --timing="$timing" "$record"

  echo '[+] replay the script with:'
  echo "    scriptreplay -t '$timing' '$record'"
}


# edit and commit file (e.g. some kind of log/protocol)
_edit_commit() {
  file="$1"
  shift
  vim "$file" "$@"
  git -C "$(dirname "$file")" add "$file"
  git -C "$(dirname "$file")" commit --message 'update'
}


# start working on a project: open folder and notes
# usage e.g.: `alias dot="_startsession '~/.dotfiles/' '~/.notes/protocol.md'"`
_startsession() {
  dir="$1"
  file="$2"

  # open file manager
  env -u TMUX -u SCRIPT_SESSION_BASE dolphin "$dir" >/dev/null 2>&1 &

  # open time log / protocol
  id=$(uuidgen)
  echo >> "$file"
  echo "# $(date --iso=s) - $id" >> "$file"
  _edit_commit "$file" -c 'normal Gzzo  - ' -c 'startinsert!'
  sed -i "s/${id}/$(date --iso=s)/g" "$file"
}


# start an application without internet access
# requires preconfiguration like described in https://ubuntuforums.org/showthread.php?t=1188099&s=73e8a8809da60f5e49641129388c7658
# sudo groupadd nointernet
# sudo usermod -aG nointernet $(whoami)
# sudo iptables -A OUTPUT -m owner --gid-owner nointernet -j DROP
# sudo ip6tables -A OUTPUT -m owner --gid-owner nointernet -j DROP
alias ni='sg nointernet'

# tar command for generating reproducible backups of some important configuration files
alias conf.bak='LC_ALL=C tar --verbose --create --file - --sort=name --files-from ~/.config/backup_config.txt --ignore-failed-read | gzip --no-name > "$(date -I)_backup_config_files-$(hostname).tar.gz"'

# diff two tar files by extracting them into temporary directories
# usage e.g.:
#       tardiff 1.tar.gz 2.tar.gz
#       tardiff 1.tar.gz 2.tar.gz 'diff -Naur'
tardiff() {
    FILE1="$1"
    FILE2="$2"
    DIFFCMD="${3:-meld}"

    DIR1=$(mktemp -d)
    DIR2=$(mktemp -d)

    tar -xf "$FILE1" -C "$DIR1"
    tar -xf "$FILE2" -C "$DIR2"

    $DIFFCMD "$DIR1" "$DIR2"
    env rm -rf -- "$DIR1" "$DIR2"
}
