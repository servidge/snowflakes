#!/bin/bash
# Umsetzung von Sebastian Boenning
# Part of https://github.com/servidge/snowflakes
# 
VERSION="Version 0.0.1 vom 2021-02-19 11:35 Uhr"
TOOLDIR=/tmp
DEVICE="$1"

echo Adaptiver Graphping zu $DEVICE
echo Einen Moment noch. ...
SCALE=$( ping -c3 $DEVICE | grep min/avg/max/mdev | cut -d"/" -f 6 )
SCALES=$(echo $SCALE |  awk '{printf "%.0f\n", $1 * 2}' )

# ttyplot >>> https://github.com/tenox7/ttyplot 
ping -A $DEVICE | sed -u 's/^.*time=//g; s/ ms//g' |  $TOOLDIR/kleinkram/bin/ttyplot -c# -s $SCALES -t "Adaptive ping zu $DEVICE - Startlaufzeit=$SCALE Softmax=$SCALES" -u ms

