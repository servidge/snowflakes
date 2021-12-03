#!/bin/bash
# Umsetzung von Sebastian Boenning
# Part of https://github.com/servidge/snowflakes
# Ping mit zeitstempel
echo "$(date +%Y-%m-%d_%T) | start Ping auf $1"
alttime=0
altttl=0
altseq=0
echo "Zeitstempel | Pingoutput | Zeitvarianz zu vorher | TTL Aenderung | Pingverlust zu vorherigem "
ping -A -n $1 | while read pong; do
if [[ $pong != *"icmp_seq="* ]]; then
	echo $(date +%Y-%m-%d_%T) \| $pong 
else
	time=`echo $pong | cut -d":" -f2 | cut -d" " -f4 | cut -d"=" -f2`
	ttl=`echo $pong | cut -d":" -f2 | cut -d" " -f3 | cut -d"=" -f2`
	seq=`echo $pong | cut -d":" -f2 | cut -d" " -f2 | cut -d"=" -f2`
	
	divtime=$( echo $time-$alttime | bc)
	if [[ $divtime != *"-"* ]]; then
		divtime="+$divtime"
	fi
	divttl=$((ttl-$altttl))
	divseq=$((seq-$altseq-1))
	#echo $(date +%Y-%m-%d_%T) \| $pong \| $time \| $ttl \| $seq \| $divtime \| $divttl \| $divseq
	echo $(date +%Y-%m-%d_%T) \| $pong  \| $divttl \| $divseq \| $divtime
	alttime=$time
	altttl=$ttl
	altseq=$seq  
fi
done
