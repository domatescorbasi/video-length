#! /bin/bash

# Calculates length of the videos (avi,mkv,mp4,mov,webm)
# Usage : video-length.sh /path/to/directory
#      or video-length.sh   # without any path parameter

FORMATS=('*.avi' '*.mkv' '*.mp4' '*.mov' '*.webm')

calculateLength()
{
	for n in "${!FORMATS[@]}";
	do
	{
		length=$(find "$DIR" -maxdepth 2 -iname "${FORMATS[n]}" -exec \
			ffprobe -v quiet -of csv=p=0 -show_entries \
			format=duration {} \; | paste -sd+ -| bc 2>/dev/null)
		if [[ -n $length ]] ; then
			hour=$(bc <<<  "$length / 3600")
			hourWithTrail=$(bc <<< "scale = 2; $length / 3600")
			minute=$(bc <<< "scale = 2; $(bc <<< "scale = 2; $hourWithTrail - $hour ") * 60")
			printf "%s Length: %s hours %s minutes\n" "${FORMATS[n]}" "$hour" "$minute"
			export length;
		fi
	}
	done
	return 0
}

if [ $# -eq 0 ]; then
	DIR="./"
	calculateLength
	exit 0
elif [ $# -eq 1 ] && [ "$1" != -h ] && [ "$1" != --help ]; then
	DIR="$1"
	if [ -d "$DIR" ]; then
		calculateLength
		exit 0
	else
		echo "Second argument should be a directory."
		exit 1
	fi
else
	echo "$0 Help."
	echo "This script calculates length of the videos (mp4,mkv,avi,webm)"
	echo "Usage         : $0 [DIR]"
	echo "Another usage : $0"
	echo "Defaults to the current working directory if no path is given."
	exit 1
fi

