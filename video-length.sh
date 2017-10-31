#! /bin/bash

# Description:  This script calculates length of the videos (mp4,mkv,avi,webm,mov)
# Usage         : video-length.sh [OPTION] [DIR]
# Usage         : video-length.sh [DIR]

# Another usage : video-length.sh
#                     Defaults to the current working directory if no path is given.

# Options:        -r, --recursive
#                     process directories recursively

FORMATS=('*.avi' '*.mkv' '*.mp4' '*.mov' '*.webm')

calculateLength()
{
	for n in "${!FORMATS[@]}";
	do
	{
		length=$(find "$DIR" -maxdepth "$DEPTH" -iname "${FORMATS[n]}" -exec \
			ffprobe -v quiet -of csv=p=0 -show_entries \
			format=duration {} \; | paste -sd+ -| bc 2>/dev/null)
		if [[ -n $length ]] ; then
			hour=$(bc <<<  "$length / 3600")
			hourWithTrail=$(bc <<< "scale = 3; $length / 3600")
			minute=$(bc <<< "scale = 3; $(bc <<< "scale = 3; $hourWithTrail - $hour ") * 60")
			printf "%s Length: %s hours %s minutes\n" "${FORMATS[n]}" "$hour" "$minute"
			export length;
		fi
	}
	done
	return 0
}

printHelp()
{
	echo "$0 Help."
	echo "[*] Description:  This script calculates length of the videos (mp4,mkv,avi,webm,mov)"
	echo "[*] Usage         : $0 [OPTION] [DIR]"
	echo "[*] Usage         : $0 [DIR]"
	echo ""
	echo "[*] Another usage : $0"
	echo "                    Defaults to the current working directory if no path is given."
	echo ""
	echo "[*] Options:        -r, --recursive"
        echo "                    process directories recursively"
}

dirCheckRun()
{
	if [ -d "$DIR" ]; then
		calculateLength
		exit 0
	else
		echo "[-] Second argument should be a directory."
		exit 1
	fi
}

if [ $# -eq 0 ]; then
	DIR="./"
	DEPTH="1"
	calculateLength
	exit 0
elif [ $# -eq 1 ] && [ "$1" != -h ] && [ "$1" != --help ]; then
	if ([ "$1" == -r ] || [ "$1" == --recursive ]); then
		DIR="./"
		DEPTH="5"
	else
		DIR="$1"
		DEPTH="1"
	fi
	dirCheckRun
elif [ $# -eq 2 ] && ([ "$1" == -r ] || [ "$1" == --recursive ]); then
	DIR="$2"
	DEPTH="5"
	dirCheckRun
else
	printHelp
	exit 0
fi
