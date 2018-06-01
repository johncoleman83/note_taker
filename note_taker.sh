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
    if [ "$#" == 1 ] && [ "$1" == "-i" ]; then
        # -i for interactive
        echo "-i"
        [[ "$0" = "$BASH_SOURCE" ]] && exit 0 || return 0
    elif [ "$#" == 1 ] && [ "$1" == "-e" ]; then
        # -e for edit
        echo "1 = 1"
        [[ "$0" = "$BASH_SOURCE" ]] && exit 0 || return 0
    else
        echo "else"
    fi
    for var in "${@:2}"; do
        echo "$var"
    done
}

#######################################
# Writes arguments to notepad
# Globals:
#   NOTE_PAD_PATH
# Arguments:
#   -i: interactive option, adds timestamp
#   -e: edit file, does not add timestamp
#   -t N: output $ tail -n (optional N number of lines)
#   $1: the subject line
#   $@: all notes
# Returns:
#   None
#######################################
process_notes () {
    if [[ "$#" == 1 ]] && [[ "$1" == "-i" ]]; then
        # -i for interactive
        printf "\n" >> "$NOTE_PAD_PATH"
        date >> "$NOTE_PAD_PATH"
        echo -n "----: " >> "$NOTE_PAD_PATH"
        emacs "$NOTE_PAD_PATH"
        [[ "$0" = "$BASH_SOURCE" ]] && exit 0 || return 0
    elif [[ "$#" == 1 ]] && [[ "$1" == "-e" ]]; then
        # -e for edit
        emacs "$NOTE_PAD_PATH"
        [[ "$0" = "$BASH_SOURCE" ]] && exit 0 || return 0
    elif [[ "$1" == "-t"* ]]; then
        # -t N for tail -n N (optional)
        if [[ -z "$2" ]]; then
            tail "$NOTE_PAD_PATH"
        else
            tail -n $2 "$NOTE_PAD_PATH"
        fi
        [[ "$0" = "$BASH_SOURCE" ]] && exit 0 || return 0
    fi
    printf "\n" >> "$NOTE_PAD_PATH"
    date >> "$NOTE_PAD_PATH"
    echo "----: $1" >> "$NOTE_PAD_PATH"

    # Loop all argv args after first to last
    for var in "${@:2}"; do
        echo "$var" >> "$NOTE_PAD_PATH"
    done
    printf "\n" >> "$NOTE_PAD_PATH"
}

process_notes "$@"
#testing "$@"
