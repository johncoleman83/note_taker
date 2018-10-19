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
	"-a")
	    # -a for all: pipes the whole notes file through less for quick, easy viewing
	    cat "$NOTE_PAD_PATH" | less
	    ;;
	"-c")
	    # -c for 'clear notes'
	    # confirm user intention
	    read -p "Clear all notes [y/n]? " -n 1 -r CLEAR_REPLY
	    echo ""
            # exit if not confirmed
	    if [[ ! "$CLEAR_REPLY" =~ ^[Yy]$ ]]; then
	    	echo "Cancelled."
	    else 
            	# clear notes file by overwriting it with blankness:
		> "$NOTE_PAD_PATH"
		# report success
		echo "Cleared."
	    fi
            echo ""
	    ;;
	"-u")
	    # -u for 'undo': deletes the most recent note. Specifically, it deletes lines starting
            # with the next-to-last line and moving upwards through the file, until the next blank
            # line it encounters.
	    # confirm user intention
	    read -p "Clear most recent note [y/n]? " -n 1 -r CLEAR_REPLY
	    echo ""
            # exit if not confirmed
	    if [[ ! "$CLEAR_REPLY" =~ ^[Yy]$ ]]; then
	    	echo "Cancelled."
	    else 
        	# get the total number of lines in the notes file
		LINES=`cat "$NOTE_PAD_PATH" | wc -l`
		# get the penultimate line, as the last line is always blank
		((LINES--))
		# get the text of the penultimate line and assign it to LINE_TEXT
		LINE_NUMBER=$LINES
		# get the text of the penultimate line and assign it to LINE_TEXT
		LINE_TEXT=`tail -n +"$LINE_NUMBER" "$NOTE_PAD_PATH" | head -n 1`
		# as long as LINE_TEXT is not empty and LINE_NUMBER is not 0
		until [ -z "$LINE_TEXT" ] || [ "$LINE_NUMBER" -eq 0 ]; do
			# delete the last line of the notes file by copying a shortened version
			# to a temp file and then overwriting the original with the temp
			head -n -1 "$NOTE_PAD_PATH" > temp.txt
			mv temp.txt "$NOTE_PAD_PATH"
			# decrement the current variable for the current line number
			((LINE_NUMBER--))
			# get the text of the new last line
			LINE_TEXT=`tail -n +"$LINE_NUMBER" "$NOTE_PAD_PATH" | head -n 1`
		done
		# outside of the loop we need to delete one more line to complete the clear process
		head -n -1 "$NOTE_PAD_PATH" > temp.txt
		mv temp.txt "$NOTE_PAD_PATH"
		# report success
		echo "Cleared."
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

# make sure `note` command is not being sourced
if [[ "$0" = "$BASH_SOURCE" ]]; then
    process_notes "$@"
fi
