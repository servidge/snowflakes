#!/bin/bash
# Umsetzung vom Script
# von Sebastian Boenning
#
VERSION="Version 0.0.2 vom 2021-02-22 09:50 Uhr"
TOOLDIR=/tmp
DEVICE="$1"
LOGDIR=~/
LOGDDAT=`/bin/date '+%Y%m%d_%H%M%S'`

echo Adaptiver Graphping zu $DEVICE
echo Rohdaten werden gespeichert unter $LOGDIR/graphping-$1-$LOGDDAT.log
echo Einen Moment noch. ...
SCALE=$( ping -c3 $DEVICE | grep min/avg/max/mdev | cut -d"/" -f 6 )
SCALES=$(echo $SCALE |  awk '{printf "%.0f\n", $1 * 2}' )
# ttyplot >>> https://github.com/tenox7/ttyplot 
ping -A $DEVICE | tee $LOGDIR/graphping-$DEVICE-$LOGDDAT.log | sed -u 's/^.*time=//g; s/ ms//g' |  $TOOLDIR/kleinkram/bin/ttyplot -c# -s $SCALES -t "Adaptive ping zu $DEVICE - Startlaufzeit=$SCALE Softmax=$SCALES" -u ms
echo Rohdaten wurden gespeichert unter $LOGDIR/graphping-$1-$LOGDDAT.log
