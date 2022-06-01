#!/bin/bash
echo -e "Installation script for aliasrc executed!"
newest_version=$(curl "https://raw.githubusercontent.com/NiroUwU/aliasrc/main/aliasrc") || (echo -e "Failed to fetch newest version" && return)
install_path=~/aliasrc


# Check for conflicting files:
if [[ -f $install_path ]]; then
	echo -e "'$install_path' already exists, what to do?"
	echo -e "1) Continue anyways (may delete data)"
	echo -e "2) Change installation path"
	echo -e "3) Abort installation"

	printf "Please type an integer >> " && read inp
	case $inp in
		1)
			echo -e "Continueing install"
			;;
		2)
			printf "Please input a new, full installation path >> " && read install_path

			# Check validity of new destination:
			if [[ -f "$install_path" || -d "$install_path" ]]; then
				echo -e "Cannot write file '$install_path', either an already existing file or a directory. Aborting." && exit
			fi
			;;
		3)
			echo -e "Installation aborted." && exit
			;;
		*)
			echo -e "Invalid option, aborting installation." && exit
	esac
fi


# Write data to file:
echo -e "Installing in aliasrc to '$install_path'"
(echo "$newest_version" > "$install_path" && echo -e "Successfully installed aliasrc to '$install_path'!") || (echo -e "Install unsuccessful. Aborting!"; exit)


# Check for writing validity:
if [[ ! $(cat "$install_path") == "$newest_version" ]]; then
	echo -e "Data was not written or written data was corrupted. Aborting." && exit
fi


# Delete Installation script if data successfully written:
if [[ $(cat "$install_path") == "$newest_version" ]]; then
	(rm "$0" && echo -e "Removed installation script.") || echo -e "Failed to remove installation script."
fi


# Post-Install:
COL="\e[32m"
echo -e "\n!!! To finish the install, you will need to add aliasrc to your shell rc file.\nYou can do that by executing:\n'$COL echo \"source $install_path\" >> YOUR_SHELL_RC_FILE_HERE\\e[0m '"
