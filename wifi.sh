#!/bin/bash
# Check Wifi and IP (v4) Connection and restart if necessary
# to compensate the worse Pi Performance with (my) far away wifi
# Part of https://github.com/servidge/snowflakes
SSID="<<SSID>>"
INTERFACE="wlan0"

iwconfig $INTERFACE | grep -q $SSID > /dev/null
if [ $? != 0 ]
then
	logger "Network connection down! Attempting reconnection."
	ifdown $INTERFACE
	sleep 15
	ifup --force $INTERFACE
	exit 2
#else
#   echo "Network ist Okay"
fi
#default
ifconfig $INTERFACE | grep -q "inet addr:" > /dev/null
#German language
#ifconfig $INTERFACE | grep -q "inet Adresse:" > /dev/null
if [ $? != 0 ]
then
	logger "Network IP connection down! Attempting reconnection."
	ifdown $INTERFACE
	sleep 15
	ifup --force $INTERFACE
	exit 5
#else
#   echo "Network ist Okay"
fi
exit 0
