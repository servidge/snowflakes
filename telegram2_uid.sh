#!/bin/bash
#Send telegram Messages to one or several USERID from Bot.
USERIDS="<USERID> <USERID2> <USERID3>"
APITOKEN="<TELEGRAMTOKEN>"
TIMEOUT="11"
URL="https://api.telegram.org/bot$APITOKEN/sendMessage"
EXECDAT="$(date "+%Y-%m-%d %H:%M")"
MSGTEXT="$EXECDAT - Message: $*"
ERRORSUM="0"
ERRORCODE="0"
for USERID in `echo $USERIDS`
do
    curl -s --max-time $TIMEOUT -d "chat_id=$USERID&disable_web_page_preview=1&text=$MSGTEXT" $URL > /dev/null
ERRORCODE=$?
ERRORSUM=$(($ERRORSUM+$ERRORCODE))
done
exit $ERRORSUM
