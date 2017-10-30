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
}

if [ $# -eq 0 ]; then
	DIR="./"
	calculateLength
elif [ $# -eq 1 ] && [ "$1" != -h ] && [ "$1" != --help ]; then
	DIR="$1"
	calculateLength
else
	echo "$0 Help."
	echo "This script calculates length of the videos (mp4,mkv,avi,webm)"
	echo "Usage         : $0 [DIR]"
	echo "Another usage : $0"
fi

