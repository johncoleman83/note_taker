#!/usr/bin/env bash
#
# note taker executable

NOTE_PAD_PATH="$HOME/.notes_for_note_taker.txt"

# editor set this here or through git
# $ git config --global core.editor "emacs"
NOTE_EDITOR="$(git config core.editor 2> /dev/null || echo 'vim')"
USAGE_STRING="Usage: $ note [bpeft] [NS] [<SUBJECT>] [<MESSAGE_LINE_1>] [<MESSAGE_LINE_2>] ..."

#######################################
# Handles options
# Globals:
#   NOTE_PAD_PATH
#   NOTE_EDITOR
# Arguments:
#   see README for arguments
# Returns:
#   None
#######################################
handle_options () {
    case "$1" in
        "-b")
            # -b to backup your NOTE_PAD_PATH
            BACKUP_EXTENSION="$(uuidgen 2> /dev/null || echo 'backup')"
            BACKUP_PATH="$NOTE_PAD_PATH.$BACKUP_EXTENSION"
            cp -Rf "$NOTE_PAD_PATH" "$BACKUP_PATH"
            echo "notes backed up to $BACKUP_PATH"
            ;;
        "-p")
            # -p for paste
            printf "\n" >> "$NOTE_PAD_PATH"
            date >> "$NOTE_PAD_PATH"
            echo -n "(clipboard)--: $(pbpaste)" >> "$NOTE_PAD_PATH"
            printf "\n" >> "$NOTE_PAD_PATH"
            echo "clipboard added to notes"
            ;;
        "-e")
            # -e for edit
            "$NOTE_EDITOR" "$NOTE_PAD_PATH"
            ;;
        "-f")
            # -f S for find using grep with string match for S
            if [[ -z "$2" ]]; then
                echo "Usage: $ note -f 'STRING_TO_FIND'"
            else
                cat "$NOTE_PAD_PATH" | grep --ignore-case --before-context=3 --after-context=3 --color --extended-regexp "$2"
            fi
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
            echo "$1 looks like an argument, please use a valid argument"
            echo "$USAGE_STRING"
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
    argv_one_length=${#1}
    if [[ "$argv_one_length" == 2 && "$1" == -* ]]; then
        handle_options "$@"
    elif [[ "$argv_one_length" == 0 ]]; then
        echo "$USAGE_STRING"
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
    fi
    date >> "$NOTE_PAD_PATH"
    echo "----: $1" >> "$NOTE_PAD_PATH"

    # Loop all argv args after first to last
    for var in "${@:2}"; do
        echo "$var" >> "$NOTE_PAD_PATH"
    done
    printf "\n" >> "$NOTE_PAD_PATH"
}

# make sure command is not being sourced
if [[ "$0" = "$BASH_SOURCE" ]]; then
    process_notes "$@"
fi
