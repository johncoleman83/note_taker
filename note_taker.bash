#!/usr/bin/env bash
#
# note taker executable

NOTE_PAD_PATH="/$HOME/.notes_for_note_taker.txt"

# editor set this here or through git
# $ git config --global core.editor "emacs"
EDITOR=$(git config core.editor || echo 'vim')

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
# Handles options
# Globals:
#   NOTE_PAD_PATH
#   EDITOR
# Arguments:
#   -p: paste from pbpaste
#   -i: interactive option, adds timestamp
#   -e: edit file, does not add timestamp
#   -t N: output $ tail -n (optional N number of lines)
# Returns:
#   None
#######################################
handle_options () {
    case "$1" in
        "-p")
            # -p for paste
            printf "\n" >> "$NOTE_PAD_PATH"
            date >> "$NOTE_PAD_PATH"
            echo -n "(clipboard)--: $(pbpaste)" >> "$NOTE_PAD_PATH"
            printf "\n" >> "$NOTE_PAD_PATH"
            ;;
        "-i")
            # -i for interactive
            printf "\n" >> "$NOTE_PAD_PATH"
            date >> "$NOTE_PAD_PATH"
            echo -n "----: " >> "$NOTE_PAD_PATH"
            "$EDITOR" "$NOTE_PAD_PATH"
            ;;
        "-e")
            # -e for edit
            "$EDITOR" "$NOTE_PAD_PATH"
            ;;
        "-t")
            # -t N for tail -n N (optional)
            if [[ -z "$2" ]]; then
                tail "$NOTE_PAD_PATH"
            else
                tail -n $2 "$NOTE_PAD_PATH"
            fi
            echo ""
            ;;
        *)
            return
            ;;
    esac
    [[ "$0" = "$BASH_SOURCE" ]] && exit 0 || return 0
}

#######################################
# Writes arguments to notepad
# Globals:
#   NOTE_PAD_PATH
# Arguments:
#   $1: the subject line or Options
#   $@: all notes
# Returns:
#   None
#######################################
process_notes () {
    argv_one=${#1}
    if [[ "$argv_one" == 2 ]]; then
        handle_options "$@"
    fi
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
