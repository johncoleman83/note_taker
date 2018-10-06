#!/usr/bin/env bash
#
# install script

# This function test to see is script is running under root and exits if not:
function test_for_root_permissions (){

	if [ "$(id -u)" != "0" ]; then
		echo "Usage: sudo ./install.bash (please use root privileges)"
		[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
	fi

}

# This function establishes the directory from which the install script is being run and exits if it 
# cannot be determined:
function establish_current_directory(){
	
	# Source the path to find the current directory, from which the application will later be copied to /opt/
	SRC_DIR=$(dirname "$0") # directory from which install was executed
	SRC_PATH=$(cd "$SRC_DIR" && pwd)  # absolute path
	if [ -z "$SRC_PATH" ]; then
		# exits if for some reason the path is an empty string
		[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
	fi

	}

# This function assigns the variables to be used for copying the application into the system:
function assign_installation_variables (){
 
	# current directory name, to be used as the subdirectory for the installed app
	APP_DIR=$(basename "$SRC_PATH")	
	
	# place to make the sym link to actual executable
	BIN_PATH="/usr/local/bin" 
	
	# install directory
	APP_PATH="/opt"	
	
	 # full install directory
	INSTALL_DIR="${APP_PATH}/${APP_DIR}"
	
	 # Executable file
	EXECUTABLE="note_taker.bash"

	}

# This function informs the user of the installation process and get their input, if any, 
# regarding configurable options:
function establish_user_options (){

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

#This function: 
#      1) Tests that the variables for install directory and current directory are not empty strings
#      2) tests that the installation directory is not /
#      3) exits with error if either of those is true
#      4) again tests that the variables for install directory and current directory are not empty strings
#      5) again tests that the installation directory is not /
#      6) deletes the install directory to make room for an updated version
function delete_old_version_if_present() {

	# Go overboard to avoid "rm -rf /"; e.g. APP_PATH is set above, testing anyway:
	if [[ -z "$APP_PATH" || -z "${APP_DIR}" || "$INSTALL_DIR" == "/" ]]; then
		echo "Something is incorrect about the install directory. Exiting."
		exit -1
	fi

	# Yes, this test is redundant with the above, but user safety is top priority.
	# Only continues to delete if directory exists and is not root '/':
	if [[ -n "$APP_PATH" && -n "${APP_DIR}" && "$INSTALL_DIR" != "/" ]]; then
		rm -rf "$INSTALL_DIR"
	fi

}

# This function  creates the installation directory, copies files, creates links and sets 
# permissions for the new application:
function install_files(){

	# creates the directory if not already existing /opt/:
	mkdir -p "$INSTALL_DIR"

	# Copies source to /opt/$INSTALL_DIR:
	cp -Rv "$SRC_PATH/$EXECUTABLE" "$INSTALL_DIR"

	# Make installed directories usable by all users:
	find "$INSTALL_DIR" -type d -exec chmod +rx {} \;

	# Make installed files readable by all users:
	chmod -R +r "$INSTALL_DIR"

	# Allow all users to execute the editor:
	chmod +rx "$INSTALL_DIR/$EXECUTABLE"
	ln -sf "$APP_PATH/$APP_DIR/$EXECUTABLE" "$BIN_PATH/$THE_CMD"

}


# Main installation:
test_for_root_permissions
establish_current_directory
assign_installation_variables
establish_user_options
delete_old_version_if_present
install_files

echo "...Success! Enjoy."
