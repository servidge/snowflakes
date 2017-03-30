#!/bin/bash
#Send telegram Messages to one or several USERID from Bot.
#Text input via file or command line arguments
USERIDS="<USERID> <USERID2> <USERID3>"
APITOKEN="<TELEGRAMTOKEN>"
TIMEOUT="11"
URL="https://api.telegram.org/bot$APITOKEN/sendMessage"
EXECDAT="$(date "+%Y-%m-%d %H:%M")"
ERRORSUM="0"
ERRORCODE="0"

if [ -f "$1" ] ; then
#the first Parameter is a file so let's use this as text input.
	MSGTEXT=$(cat $1)
else
#the first Parameter is not a file so just juse all as mesasge.
	MSGTEXT="$EXECDAT: Message: $*"
fi

for USERID in `echo $USERIDS`
do
#Markdown interpretation of given text. 
    curl -s --max-time $TIMEOUT \
	--data-urlencode "chat_id=$USERID&disable_web_page_preview=1" \
	--data-urlencode "parse_mode=Markdown" \
	--data-urlencode "text=${MSGTEXT}" $URL > /dev/null
	ERRORCODE=$?
	ERRORSUM=$(($ERRORSUM+$ERRORCODE))
done
exit $ERRORSUM
