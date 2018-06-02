# `note`

a new command, (`$ note`) to help you take notes

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

- The editor for interactive and edit options is `emacs`, be sure to change to
the editor of your choice.

# Usage

This command opens the text editor from any directory. The execution
command for the editor can be specified by user choice during installation or manually.

```
$ note "<A_NEAT_SUBJECT_GOES_HERE>" "This one line of a Note" "and another line to document"
```

- interactive, timestamp is added and user prompted to edit file

```
$ note -i
```

- pure edit, no timestamp added

```
$ note -e
```

- output last N lines of notes (N is optional, defaults to 10)

```
$ note -t N
```

# license

MIT License

# author

- David John Coleman II, http://www.davidjohncoleman.com
