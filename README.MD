# `note`

a new command, (`$ note`) to help you take notes. Gives fast ability to add notes to your
notes file through the `note` command or open up your selected notes file for an interactive edit.

# installation (Linux / Mac OS)

Execute the install script with root privileges. Either change directory `cd`
to the downloaded directory (or local repository): `note_taker`, or use the
path to the installation file (i.e. ./[PATH_TO_FILE]/install.bash).

```
$ sudo ./install.bash
```

- Note: This script creates a copy of the repository in the directory
`/opt/note_taker/`; the update, overwrites that copy. Then a symbolic link
is created in the directory `/usr/local/bin/`, which is generally
designated for user programs not managed by the distribution package manager

- you can specify the command if you don't like `note`

- The editor for interactive and edit options is set to the global editor defined in your
git config file or if unset, it is `vim`. To set your default editor for note command,
use this command:

```
git config --global core.editor "emacs"
```

# Usage

```
$ note [pieft] [NS] [<SUBJECT>] [<MESSAGE_LINE_1>] [<MESSAGE_LINE_2>] ...
```

The execution command for the note taker can be specified by user choice during installation or manually.

- usage with no options to add notes

```
$ note "<A_NEAT_SUBJECT_GOES_HERE>" "This one line of a Note" "and another line to document" ...
```

## Options

- Usage with options for management

```
$ note [-bpeft] [NS]
```

**\-b** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
`backup`, creates copy of note taker file with a hash extension as a backup

**\-p** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
`paste`, adds pbpaste (clipboard) content to note pad

**\-e** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
interactive `edit` of your notes, no timestamp added

**\-f S** &nbsp;&nbsp;&nbsp;
`find` string matching **S** (regex enabled) using:
```
grep --ignore-case --before-context=3 --after-context=3 --color --extended-regexp "$2"
```

**\-t N** &nbsp;&nbsp;&nbsp;
`tail` output last **N** lines of notes (N is optional, defaults to 10)

**NOTE:** see the install instructions to set your editor of choice for `-e` and `-i` options

# license

MIT License

# author

- David John Coleman II, http://www.davidjohncoleman.com

# contributors

- Nick Julian, https://github.com/JiveCatDaddyO
- Luis E. Jiménez, https://github.com/luisejrobles
