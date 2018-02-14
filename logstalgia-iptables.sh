#!/bin/bash
# Umsetzung von iptables Log in ein von logstalgia verarbeitbares Format. 
# Conversion of iptables log into logstalgia usable format.
# logstalgia.io "..website traffic visualization..." 
# Part of https://github.com/servidge/snowflakes
# äöüß
#
AUSGABE=""
f_transform(){
ZEILE=$@
for SPALTE in $ZEILE; do
	if [[ $SPALTE == SRC=* ]]; then
		AUSGABE=$SPALTE
	elif [[ $SPALTE == PROTO=* ]]; then
		AUSGABE=$AUSGABE"; "$SPALTE
	elif [[ $SPALTE == DPT=* ]]; then
		AUSGABE=$AUSGABE"; "$SPALTE
	fi
done
echo $AUSGABE
AUSGABE=""
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
		echo "No input given!"
	fi
fi

