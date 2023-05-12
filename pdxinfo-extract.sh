#!/bin/sh
#
#	pdxinfo-extract
#	little bash script to retrieve values from the current PDX file
#	yorgle@gmail.com
#

version="1.0a"
# 	version 1.0a - 2023-05-12 - initial version

pdxinfo_file="./Source/pdxinfo"	# default filename
key="NA"						# key to look for
operation="help"				# what are WE supposed to do here

# check params
while [[ "$#" -gt 0 ]]
	do case $1 in
		# set the pdxinfo file path
		-f|--file) pdxinfo_file="$2"
		shift;;

		# get this key
		-g|--get) key="$2"; operation="get"
		shift;;

		# print out help
		-h|--help) operation="help"
		shift;;
		# display our version 
		-v|--version) operation="version"
		shift;;
		# ???
		*) echo "Unknown operation: $1"
		exit 1;;
	esac
	shift
done

# make sure a key is chosen
if [[ -z $key ]] || [[ $key =~ (NA) ]]
then
	echo "Error: Empty or invalid key"
	exit 1;
fi

if [[ $operation =~ (help) ]]
then
	echo "pdxinfo-extract v$psversion"
	echo "Usage: pdxinfo-extract [options]"
	echo ""
	echo "Options:"
		echo "  -f/--file <file>	select new pdxinfo file (./Source/pdxinfo)"
		echo "  -g/--get <key>	get the value that matches <key>"

		echo "  -h, --help		print this help message and exit"
		echo "  -v, --version		print the pdxinfo-extract version"
		exit
fi

if [[ $operation =~ (version) ]]
then
	echo "pdxinfo-extract v$psversion "
	exit
fi

if [[ $operation =~ (get) ]]
then
	echo `grep -i $pdxinfo_file -e $key | awk -F = '{print \$2}'`;
fi
