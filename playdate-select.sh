#!/bin/sh
#
#	playdate-select
#	little bash script to swap around the SDK
#	yorgle@gmail.com
#
#
# 	version 1.0a - 2023-05-07 - initial version

psversion="1.01a"
selversion="0"
operation="help"

# get the current sdk directory
sdk=`egrep '^\s*SDKRoot' ~/.Playdate/config | head -n 1 | cut -c9-`

if [ ! -L "$sdk" ] && [ -f "$sdk" ]
then
	echo "The path $sdk is either a solid directory, or doesn't exist."
	echo ""
	echo "Please rename the actual SDK directory to be something like"
	echo "   PlaydateSDK-1"
	echo "or"
	echo "   PlaydateSDK-2"
	echo "before proceeding.  thanks!"
	exit
fi


while [[ "$#" -gt 0 ]]
do case $1 in
    -h|--help) operation="help"
    shift;;
    -s|--select) selversion="$2"; operation="select"
    shift;;
    -v|--version) operation="version"
    shift;;
    *) echo "Unknown operation: $1"
    exit 1;;
esac
shift
done


if [[ $operation =~ (help) ]]
then
	echo "playdate-select v$psversion"
	echo "Usage: playdate-select [options]"
	echo ""
	echo "Options:"
	echo "  -s <version>		select version 1 or 2"
	echo "  -h, --help 		print this help message and exit"
	echo "  -v, --version		print the playdate-select version"
	exit
fi

if [[ $operation =~ (version) ]]
then
	echo "playdate-select v$psversion "
	exit
fi

if [[ $operation =~ (select) ]]
then
	echo "Changing Playdate SDK to version $selversion "
	if [ ! -d "$sdk-$selversion" ]
	then
		echo "($sdk-$selversion) Selected SDK does not exist!"
		exit
	fi


	rm "$sdk"
	ln -s "$sdk-$selversion" "$sdk"
fi
