#!/bin/bash
# Send Picture/Photo (static images) via telegram Messages to one or several USERID from Bot.
# Input file via first command line argument and comment via the following arguments 
# Part of https://github.com/servidge/snowflakes 
# A picture paints a thousand words.
USERIDS="<USERID> <USERID2> <USERID3>"
APITOKEN="<TELEGRAMTOKEN>"
TIMEOUTUP="45"
URL="https://api.telegram.org/bot$APITOKEN"
URLPHOTO="$URL/sendPhoto"
EXECDAT="$(date "+%Y-%m-%d %H:%M")"
ERRORSUM="0"
ERRORCODE="0"
CAPMAXCHAR=200 # https://core.telegram.org/method/messages.sendMessage 4096 - somewhat

f_sendphoto () {
# function for reuse
for USERID in `echo $USERIDS`; do
	curl -s --max-time $TIMEOUTUP "$URLPHOTO" \
		-F "chat_id=$USERID" \
		-F "caption=${CAPTION}" \
		-F "photo="@$FILE"" > /dev/null
	ERRORCODE=$?
	ERRORSUM=$(($ERRORSUM+$ERRORCODE))
done
}

FILE="$1"
if [ -f "$FILE" ] ; then
# the first Parameter is a file.
	FILETYPE="$(file -b "$FILE")"
	# what type of file?
	if [[ $FILETYPE == "PNG image data"* ]] || [[ $FILETYPE == "JPEG image data"* ]] || [[ $FILETYPE == "PC bitmap"* ]] || [[ $FILETYPE == "GIF image data"* ]]; then
		shift
		CAPTION="$*"
		CAPTION="${CAPTION:0:$CAPMAXCHAR}"
		f_sendphoto
		exit $ERRORSUM
	else
	# the first Parameter is not a Picture.
		echo "no Photo"
		exit 253
	fi
else
	# the first Parameter is not a File.
	echo "First Parameter is not a File"
	exit 254
fi
