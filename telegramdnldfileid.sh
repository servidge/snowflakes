@@ -1,31 +0,0 @@
#!/bin/bash
# Download pictures // fileIDs that was sent to the bot.
# input File ID via first command line argument
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

FILEID="$1"
# get file and path 
GETPATH=$(curl -s $URLDNLDPATH"?file_id="$FILEID)
if [[ "$GETPATH" =~ \"file_path\"\:\"(([a-zA-Z0-9/_]+))\" ]]; then
	FILEPATH=${BASH_REMATCH[1]}
else
	exit 254
fi

# download path/file
OUTPUTFILE=${FILEPATH////_-_}-$FILEID
curl -o $DNLDDIR/$OUTPUTFILE -s --max-time $TIMEOUT $URLDNLDFILE/$FILEPATH > /dev/null
ERRORCODE=$?
ERRORSUM=$(($ERRORSUM+$ERRORCODE))
# exit with curl errorcode sum
exit $ERRORSUM
