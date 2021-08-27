#!/bin/bash
# Umsetzung vom Script
# Ping mit zeitstempel
# von Sebastian Boenning
echo "$(date +%Y-%m-%d_%T) | start Ping auf $1"
ping -A -n $1 | while read pong; do echo $(date +%Y-%m-%d_%T) \| $pong;done 

