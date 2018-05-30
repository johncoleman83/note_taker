#!/usr/bin/env bash
#
# note taker executable


NOTE_PAD_PATH="/Users/jcoleman/.johns_notepad.txt"

#######################################
# Script to test
# Globals:
#   NOTE_PAD_PATH
# Arguments:
#   $@
# Returns:
#   None
#######################################
testing () {
    echo "$#"
    for var in "${@:2}"; do
        echo "$var"
    done
}

#######################################
# Writes arguments to notepad
# Globals:
#   NOTE_PAD_PATH
# Arguments:
#   -i: interactive option
#   $1: the subject line
#   $@: all notes
# Returns:
#   None
#######################################
process_notes () {
    # -i for interactive
    if [ "$#" == 1 ] && [ "$1" == "-i" ]; then
        date >> "$NOTE_PAD_PATH"
        echo -n "----: " >> "$NOTE_PAD_PATH"
        emacs "$NOTE_PAD_PATH"
        [[ "$0" = "$BASH_SOURCE" ]] && exit 0 || return 0
    fi
    date >> "$NOTE_PAD_PATH"
    echo "----: $1" >> "$NOTE_PAD_PATH"

    # Loop all argv args after first to last
    for arg in "${@:2}"; do
        echo "$arg" >> "$NOTE_PAD_PATH"
    done
    echo "" >> "$NOTE_PAD_PATH"
}

process_notes "$@"
