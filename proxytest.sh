#!/bin/bash
# Test Proxy Connection and get External IP 
# 
# Part of https://github.com/servidge/snowflakes

read -p 'Please Type your Username: ' USERMANE
read -sp 'Please Type your Password: ' PASSWORT
echo  
echo Using your username is $USERMANE
echo Using your password is $PASSWORT
echo  

line=`cat <<EOF  
10.10.11.15:8080
10.11.11.15:8080
pr001.emea1.example.com:8080
pr001.emea2.example.com:8080
pr001.apac1.example.com:8080
pr001.apac2.example.com:8080
pr001.ncsa1.example.com:8080
pr002.ncsa1.example.com:8080
127.0.0.1:3128
EOF`

for PROXY in $line
do 
	echo Proxy Test: $PROXY
	#curl debug -v
	#curl -v -U $USERMANE:$PASSWORT -x $PROXY --url  http://api.ipify.org 
	curl --proxy-ntlm -U $USERMANE:$PASSWORT -x $PROXY --url http://api.ipify.org
	echo ""
done   

