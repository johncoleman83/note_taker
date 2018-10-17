#!/usr/bin/env bash
#
# install script

# check root privileges
function root_privileges() {
    if [ "$(id -u)" != "0" ]; then
        echo "Usage: sudo ./install.bash (please use root privileges)"
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
    fi
}

function directory_validation() {
    # source path to find current directory and to copy application to /opt/
    SRC_DIR=$(dirname "$0") # directory from which install was executed
    SRC_PATH=$(cd "$SRC_DIR" && pwd)  # absolute path
    if [ -z "$SRC_PATH" ]; then
        # exit if for some reason, the path is empty string
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
    fi
}

function set_installation_variables() {
    # grab current directory name to use as subdirectory for the installed app
    APP_DIR=$(basename "$SRC_PATH")
    # path for sym link to executable
    BIN_PATH="/usr/local/bin"
    # location of install directory
    APP_PATH="/opt"
    # full install directory
    INSTALL_DIR="${APP_PATH}/${APP_DIR}"
    # Executable file
    EXECUTABLE="note_taker.bash"
}

function installation_output() {
    echo "* *********************************************************** *"
    echo "*"
    echo "*   installation steps:"
    echo "*"
    echo "*   (1) copies (or updates) '$SRC_PATH/$EXECUTABLE' to the path:"
    echo "*       '$INSTALL_DIR'"
    echo "*       NOTE: update will use the command:"
    echo "*       $ rm -rf $INSTALL_DIR"
    echo "*"
    echo "*   (2) creates (or updates) the execution command:"
    echo "*       (a) this will be a sym link to the install directory"
    echo "*           executable '$EXECUTABLE' copied to the path:"
    echo "*           '/usr/local/bin' --> generally designated for"
    echo "*           user programs."
    echo "*       (b) The command will be given the default:"
    echo "*           command name of: 'note'"
    echo "*       (c) If you would like to specify the command name,"
    echo "*           you will be prompted for an input name."
    echo "*           NOTE: Be sure to specify a UNIQUE name"
    echo "*"
    echo "* *********************************************************** *"
    echo ""
    echo "Type 'y' or 'Y' to continue, or anything else to quit"
    read -p "Continue ? " -n 1 -r INSTALL_REPLY
    echo ""
}

function continue_installation() {
    if [[ ! "$INSTALL_REPLY" =~ ^[Yy]$ ]]; then
        echo "...Goodbye"
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
    else
        echo "To customize the note command for your CLI, please type:"
        echo "'y' or 'Y', or anything else to use the default command 'note'"
        read -p "Customize Command ? " -n 1 -r CMD_REPLY
        echo ""
        if [[ "$CMD_REPLY" =~ ^[Yy]$ ]]; then
            read -p "Your Custom Unique command: " -r THE_CMD
        else
            THE_CMD="note"
        fi
        echo "...installing"
        sleep 1
    fi
}

function install_directory_safety_checks() {
    # Go over board to avoid "rm -rf /"; e.g. APP_PATH is set above, testing anyway.
    if [[ -z "$APP_PATH" || -z "${APP_DIR}" || "$INSTALL_DIR" == "/" ]]; then
        echo "Something is incorrect about the install directory. Exiting."
        # exit since there could be something wrong
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
    fi
    # Yes, this is redundant with the above. User safety is top priority.
    # Only continues to delete if directory exists and is not root '/'
    if [[ -n "$APP_PATH" && -n "${APP_DIR}" && "$INSTALL_DIR" != "/" ]]; then
        rm -rf "$INSTALL_DIR"
    fi
}

function install_files() {
    # creates the directory if not already existing /opt/
    mkdir -p "$INSTALL_DIR"

    # Copies Source to /opt/$INSTALL_DIR
    cp -Rv "$SRC_PATH/$EXECUTABLE" "$INSTALL_DIR"
}

function installed_files_permissions() {
    # Make installed directories usable by all users.
    find "$INSTALL_DIR" -type d -exec chmod +rx {} \;

    # Make installed files readable by all users.
    chmod -R +r "$INSTALL_DIR"
    # Allow all users to execute the editor.
    chmod +rx "$INSTALL_DIR/$EXECUTABLE"
}

# Installation procedure
root_privileges
directory_validation
set_installation_variables
installation_output
continue_installation
install_directory_safety_checks
install_files
installed_files_permissions

ln -sf "$APP_PATH/$APP_DIR/$EXECUTABLE" "$BIN_PATH/$THE_CMD"
echo "...Success! Enjoy."
