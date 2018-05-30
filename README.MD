# note

this is a new command to help you take notes

# installation (Linux / Mac OS)

Execute the install script with root privileges. Either change directory `cd`
to the downloaded directory (or local repository): note_taker, or use the
path to the installation file (i.e. ./[PATH_TO_FILE]/install.sh).

```
$ sudo ./install.sh
```

- Note: This script creates a copy of the repository in the directory
`/opt/note_taker/`; the update, overwrites that copy. Then a symbolic link
is created in the directory `/usr/local/bin/`, which is generally
designated for user programs not managed by the distribution package manager

# Usage
This command opens the text editor from any directory. The execution
command for the editor can be specified by user choice during installation or manually.

```
$ note "<A_NEAT_SUBJECT_GOES_HERE>" "This one line of a Note" "and another line to document"
```

- interactive

```
$ note -i
```

- pure edit

```
$ note -e
```

# author

- David John Coleman II, http://www.davidjohncoleman.com
