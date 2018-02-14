#!/bin/bash
# Umsetzung von iptables Log in ein von logstalgia verarbeitbares Format. 
# Conversion of iptables log into logstalgia usable format.
# logstalgia.io "..website traffic visualization..." - https://github.com/acaudwell/Logstalgia/wiki/Custom-Log-Format
# Part of https://github.com/servidge/snowflakes
# äöüß
# iptableskonfig
# -A logaccept -m state --state NEW -j LOG --log-prefix "iptables-accept "
# -A logaccept -j ACCEPT
# -A logdrop -j LOG --log-prefix "iptables-drop "
# -A logdrop -j DROP
# -A rejectlog -j LOG --log-prefix "iptables-reject "
# -A rejectlog -j REJECT --reject-with icmp-port-unreachable
# Logs:
#2018-02-14T22:36:37.851865+01:00 HOSTNAME kernel: [83172.422084] iptables-accept IN=eth11 OUT= MAC=aa:aa:aa:aa:aa:aa:aa:cc:cc:cc:cc:cc:cc:cc SRC=192.0.2.123 DST=198.51.100.11 LEN=219 TOS=0x00 PREC=0x00 TTL=251 ID=44695 PROTO=UDP SPT=56852 DPT=514 LEN=199 
#2018-02-14T22:37:27.872349+01:00 HOSTNAME kernel: [83282.443510] iptables-drop IN=eth11 OUT= MAC=aa:aa:aa:aa:aa:aa:aa:cc:cc:cc:cc:cc:cc:cc SRC=192.0.2.122 DST=198.51.100.11 LEN=40 TOS=0x00 PREC=0x00 TTL=56 ID=33017 PROTO=TCP SPT=3288 DPT=23 WINDOW=15080 RES=0x00 SYN URGP=0 
#2018-02-14T21:46:37.425024+01:00 HOSTNAME kernel: [83871.937830] iptables-reject IN=eth11 OUT= MAC=aa:aa:aa:aa:aa:aa:aa:cc:cc:cc:cc:cc:cc:cc SRC=192.0.2.110 DST=198.51.100.11 LEN=52 TOS=0x02 PREC=0x00 TTL=116 ID=3495 DF PROTO=TCP SPT=10216 DPT=22 WINDOW=8192 RES=0x00 CWR ECE SYN URGP=0 
#
#

AUSGABE=""
f_transform(){
PROTO=""
SOURCEIP=""
DSTINAIP=""
DSTPORT=""
ACTION=""
COLOR="FFFFCC"
SUCCE="0"
ZEILE=$@
ZEITSTEMPEL=$(date -d$1 +%s)a
for SPALTE in $ZEILE; do
	if [[ $SPALTE == SRC=* ]]; then
		SOURCEIP=${SPALTE:4}
	elif [[ $SPALTE == DST=* ]]; then
		DSTINAIP=${SPALTE:4}
	elif [[ $SPALTE == PROTO=* ]]; then
		PROTO=${SPALTE:6}
	elif [[ $SPALTE == DPT=* ]]; then
		DSTPORT=${SPALTE:4}
	elif [[ $SPALTE == iptables-* ]]; then
		ACTION=${SPALTE:9}
		if [[ $ACTION == accept ]]; then
			COLOR="00FF00"
			SUCCE="0"
		elif [[ $ACTION == drop ]]; then
			COLOR="FF0000"
			SUCCE="1"
		elif [[ $ACTION == reject ]]; then
			COLOR="FFA500"
			SUCCE="1"
		else
			COLOR="FFC0CB"
			SUCCE="1"
        fi
	fi
done
echo $ZEITSTEMPEL"|"$SOURCEIP"|"$DSTPORT-$PROTO"|"$ACTION"|40|"$SUCCE"|"$COLOR"|0|0|"$DSTINAIP"|PID"
 }

if [ -p /dev/stdin ]; then
	while IFS= read line; do
		f_transform ${line}
	done
else
	if [ -f "$1" ]; then
		echo "Dateiname angegeben: ${1}"
		while read line; do
			f_transform ${line}
		done < ${1} 
	else
		echo "Nichts angegeben!"
	fi
fi
