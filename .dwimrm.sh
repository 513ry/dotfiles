#!/usr/bin/bash
# This file assumes you have YUNK and DATE_FORMAT environment variable set for
# your shell !!

# Exit codes
declare -ir EXIT_SUCCESS=0
declare -ir OPTIONS_ERROR=1
declare -ir INVALID_FILE=2
declare -ir TERMINATE=3

# Options
#declare quiet

# Temp Globals
declare -i remove_all=1
declare -i skip=1

# Takes user input and returns 0 at YES, 1 at NO, 2 at ALWAYS, and 3 at SKIP
#NOTE:
# Command options -n, will prevent from removing any files (Ss), and -y will
# enforce to always remove files (Aa). If any of the above options has been
# passed then this function is not used
function yes_no_always {
	while true; do
		declare -l opt
		read -r -n 1 -p "$* [y/N/a/s]: " opt
		printf "\n"
		case $opt in
		Y | y) return 0 ;;
		N | n | '') return 1 ;;
		A | a)
			remove_all=0
			return 2
			;;
		S | s)
			skip=0
			return 3
			;;
		esac
	done
}

#TODO: Implement [-y -n, -q, -v] options
# * Options can be passed at the beginning of the command in both long (e.g.
#   --no) and short version (e.g. -n).
# * If
# # Synopsis:
# dwimrm [ [-y] [-n] ] [ [-q] [-v] ]

#TODO: Handle options and remove them from argument list
#function options() {
#	echo $1
#}

function dwimrm() {
	# Run fzf search when no argument found
	if [ $# -eq -1 ]; then
		echo 'No argument supplied'
		declare -rl file=$(fzf)
		echo $(dwimrm "$file")
		return $EXIT_SUCCESS
	fi

	# Handle empty argument as exit to escape fzf
	if [ -z "$1" ]; then
		return $TERMINATE
	fi

	declare -al to_move
	declare -al to_remove

	# Separate YUNK directory files from other files
	for file in $@; do
		if [ $YUNK == $(realpath -- "$file" | xargs dirname) ]; then
			to_remove+=($file)
		else
			to_move+=($file)
		fi
	done

	echo "to_move:   ${to_move[*]}"
	echo "to_remove: ${to_remove[*]}"

	# Move files
	for file in "${to_move[@]}"; do
		declare -l destination="$YUNK/$(date +$DATE_FORMAT)_$(basename $file)"
		mv -- $file $destination

		# Store origin path
		echo $(realpath $file) >$destination.meta
		echo "$file moved to $YUNK"
	done

	# Remove files
	for file in "${to_remove[@]}"; do
		declare -il opt
		if [ $remove_all -eq 1 ] && [ $skip -eq 1 ]; then
			yes_no_always "Do you want to remove this data forever [$file]?"
			opt=$?
		fi

		if [ $skip -eq 0 ]; then
			opt=1
		elif [ $remove_all -eq 0 ]; then
			opt=0
		fi

		if [ $opt -eq 0 ]; then
			echo 'Removing junk'
			/bin/rm -rf -- $file
		fi
	done
}

dwimrm $*
