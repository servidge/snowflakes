#!/bin/bash
# Download pictures // fileIDs that was sent to the bot.
# input File ID via command line arguments (no check)
# Part of https://github.com/servidge/snowflakes
USERIDS="<USERID> <USERID2> <USERID3>"
APITOKEN="<TELEGRAMTOKEN>"
TIMEOUT="30"
URL="https://api.telegram.org/bot$APITOKEN"
URLDNLDPATH="$URL/getFile"
URLDNLDFILE="https://api.telegram.org/file/bot$APITOKEN"
DNLDDIR="."
EXECDAT="$(date "+%Y-%m-%d %H:%M")"
ERRORSUM="0"
ERRORCODE="0"

for FILEID in "$@"; do 
	# get file and path 
	GETPATH=$(curl -s $URLDNLDPATH"?file_id="$FILEID)
	ERRORCODE=$?
	ERRORSUM=$(($ERRORSUM+$ERRORCODE))
	if [[ "$GETPATH" =~ \"file_path\"\:\"(([a-zA-Z0-9/_]+))\" ]]; then
		FILEPATH=${BASH_REMATCH[1]}
		# download path/file
		OUTPUTFILE=$FILEID-${FILEPATH////_-_}
		curl -o $DNLDDIR/$OUTPUTFILE -s --max-time $TIMEOUT $URLDNLDFILE/$FILEPATH > /dev/null
		ERRORCODE=$?
		ERRORSUM=$(($ERRORSUM+$ERRORCODE))
	elif [[ "$GETPATH" =~ \"error_code\"\:(([a-zA-Z0-9/_\"\ .:,]+)) ]]; then
		ERROR=${BASH_REMATCH[1]}
		echo "ERROR: FileID:$FILEID - $ERROR"
		ERRORSUM=$(($ERRORSUM+50))
	else
		echo "ERROR: $GETPATH"
		ERRORSUM=$(($ERRORSUM+111))
	fi
done
# exit errorcode sum
exit $ERRORSUM
