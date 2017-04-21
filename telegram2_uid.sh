#!/bin/bash
# Send telegram Messages to one or several USERID from Bot.
# Text input via file or command line arguments
# Part of https://github.com/servidge/snowflakes
USERIDS="<USERID> <USERID2> <USERID3>"
APITOKEN="<TELEGRAMTOKEN>"
TIMEOUT="11"
URL="https://api.telegram.org/bot$APITOKEN"
URLMESSAGE="$URL/sendMessage"
EXECDAT="$(date "+%Y-%m-%d %H:%M")"
ERRORSUM="0"
ERRORCODE="0"
MAXCHAR=4000 # https://core.telegram.org/method/messages.sendMessage 4096 - somewhat

f_sendmessage () {
#function for reuse
TEXT="$1"
for USERID in `echo $USERIDS`; do 
	#Markdown interpretation of given text. 
	curl -s --max-time $TIMEOUT $URLMESSAGE\
		--data-urlencode "chat_id=$USERID&disable_web_page_preview=1" \
		--data-urlencode "parse_mode=Markdown" \
		--data-urlencode "text=${TEXT}" > /dev/null
	ERRORCODE=$?
	ERRORSUM=$(($ERRORSUM+$ERRORCODE))
done
}

if [ -f "$1" ] ; then
# "the first Parameter is a file so let's use this as text input."
FILETYPE="$(file -b "$1")"
	if [[ $FILETYPE == *"text" ]] || [[ $FILETYPE == *"text"*"long lines" ]]; then
		# "file think it's text"
		MSGTEXT=$(cat $1)
	else
		# "file doesn't think it's text"
		MSGTEXT="$EXECDAT: File: $*, but not text."
	fi
else
	#the first Parameter is not a file so just use all as mesasge.
	MSGTEXT="$EXECDAT: Message: $*"
fi

# "truncate text into array because of maxsize."
for ((i=0;i<${#MSGTEXT};i+=$MAXCHAR)); do
	ARRAY[$i]="${MSGTEXT:$i:$MAXCHAR}"
done

COUNT1=1
for i in "${ARRAY[@]}" ; do 
	if [[ "${#ARRAY[@]}" -eq 1 ]]; then
		f_sendmessage "$i"
	else
		#generate multi message with counter n of x prefix 
		f_sendmessage "MM $COUNT1 of ${#ARRAY[@]} -#- $i"
	fi
	#increase counter
	((COUNT1++))
done
#exit with curl errorcode sum
exit $ERRORSUM
