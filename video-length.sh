#! /bin/bash

# Calculates length of the videos (mp4,mkv,avi,webm)
# Usage : video-length.sh /path/to/directory
#      or video-length.sh   # without any path parameter

if [ $# -eq 0 ]; then
	mp4Length=$(find . -maxdepth 2 -iname "*.mp4" -exec \
		ffprobe -v quiet -of csv=p=0 -show_entries \
		format=duration {} \; | paste -sd+ -| bc 2>/dev/null)
	mkvLength=$(find . -maxdepth 2 -iname "*.mkv" -exec \
		ffprobe -v quiet -of csv=p=0 -show_entries \
		format=duration {} \; | paste -sd+ -| bc 2>/dev/null)
	aviLength=$(find . -maxdepth 2 -iname "*.avi" -exec \
		ffprobe -v quiet -of csv=p=0 -show_entries \
		format=duration {} \; | paste -sd+ -| bc 2>/dev/null)
	webmLength=$(find . -maxdepth 2 -iname "*.webm" -exec \
		ffprobe -v quiet -of csv=p=0 -show_entries \
		format=duration {} \; | paste -sd+ -| bc 2>/dev/null)

elif [ $# -eq 1 ] && [ "$1" != -h ] && [ "$1" != --help ]; then
	mp4Length=$(find "$1" -maxdepth 2 -iname "*.mp4" -exec \
		ffprobe -v quiet -of csv=p=0 -show_entries \
		format=duration {} \; | paste -sd+ -| bc 2>/dev/null)
	mkvLength=$(find "$1" -maxdepth 2 -iname "*.mkv" -exec \
		ffprobe -v quiet -of csv=p=0 -show_entries \
		format=duration {} \; | paste -sd+ -| bc 2>/dev/null)
	aviLength=$(find "$1" -maxdepth 2 -iname "*.avi" -exec \
		ffprobe -v quiet -of csv=p=0 -show_entries \
		format=duration {} \; | paste -sd+ -| bc 2>/dev/null)
	webmLength=$(find "$1" -maxdepth 2 -iname "*.webm" -exec \
		ffprobe -v quiet -of csv=p=0 -show_entries \
		format=duration {} \; | paste -sd+ -| bc 2>/dev/null)
else
	echo "$0 Help."
	echo "This script calculates length of the videos (mp4,mkv,avi,webm)"
	echo "Usage         : $0 [PATH]"
	echo "Another usage : $0"
fi

if [[ -n $mkvLength ]]; then
	hour=$(bc <<<  "$mkvLength / 3600")
	hourWithTrail=$(bc <<< "scale = 2; $mkvLength / 3600")
	minute=$(bc <<< "scale = 2; $(bc <<< "scale = 2; $hourWithTrail - $hour ") * 60")
	printf "\nmkv Length: %s hours %s minutes\n" "$hour" "$minute"
fi
if [[ -n $mp4Length ]] ; then
	hour=$(bc <<<  "$mp4Length / 3600")
	hourWithTrail=$(bc <<< "scale = 2; $mp4Length / 3600")
	minute=$(bc <<< "scale = 2; $(bc <<< "scale = 2; $hourWithTrail - $hour ") * 60")
	printf "\nmp4 Length: %s hours %s minutes\n" "$hour" "$minute"

fi
if [[ -n $aviLength ]] ; then
	hour=$(bc <<<  "$aviLength / 3600")
	hourWithTrail=$(bc <<< "scale = 2; $aviLength / 3600")
	minute=$(bc <<< "scale = 2; $(bc <<< "scale = 2; $hourWithTrail - $hour ") * 60")
	printf "\navi Length: %s hours %s minutes\n" "$hour" "$minute"
fi
if [[ -n $webmLength ]] ; then
	hour=$(bc <<<  "$webmLength / 3600")
	hourWithTrail=$(bc <<< "scale = 2; $webmLength / 3600")
	minute=$(bc <<< "scale = 2; $(bc <<< "scale = 2; $hourWithTrail - $hour ") * 60")
	printf "\nwebm Length: %s hours %s minutes\n" "$hour" "$minute"
fi
