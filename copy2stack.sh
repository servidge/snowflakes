#!/bin/bash
# Umsetzung von Sebastian Boenning
# Part of https://github.com/servidge/snowflakes
# kopiert eine Datei per scp auf einen Cisco Router ins flash
# ip scp server enable auf router notwendig
# sshpass zur passwortübergabe notwendig 
# nicht wirklich schnell. vom Router aus ist ein http und selbst tftp transfer schneller
#
VERSION="Version 0.0.1 vom 2021-06-28 12:12 Uhr"
DEVICE=$1
USERNAME=$2
PASSWORT=$3
DATEI=$4
STACKNUM=$5
BIN=/tmp/kleinkram/bin
FEHLERSUMME=0

test -z $DEVICE && echo "# Es fehlt der Geraetename oder IP Adresse, Beispielaufruf $0 HOSTNAME USERNAME PASSWORT DATEI STACKNUM" &&  exit
test -z $STACKNUM && echo "# Es fehlt der Geraetename oder IP Adresse, Beispielaufruf $0 HOSTNAME USERNAME PASSWORT DATEI STACKNUM" &&  exit

ZIEL=`basename $DATEI`
echo "# "
echo "# Die Datei wird per SCP auf das Zielsystem in das jeweilige Flasch kopiert."
echo "# Es laeuft durch eine Schleife von 1 bis Eingegebener Stacknummer"
echo "# Damit der Zugriff funktioniert muss [ip scp server enable] auf dem Device konfiguriert sein. "
echo "# Ansonsten kommt es zu einer [Administratively disabled.] Fehlermeldung"
echo "# "
echo "# Der Befehl [ip scp server enable] ist konfiguriert."
read -r -p "# y oder Enter fuer OK, Alles andere Neuauswah. Auswahl:" key
        if [ "$key" = "y" ] || [ "$key" = "" ]; then
              echo "# Ok "
        else
            exit
        fi

#Pingtest
echo "# Pingtest auf $DEVICE"
if ping -c 3 -W 1 $DEVICE &>/dev/null ; then
    echo "# $DEVICE ist per Ping erreichbar. "
else 
    echo "# $DEVICE ist per Ping nicht erreichbar. Abbruch"
    exit
fi
echo "# "
echo "# Updateschleife Start"

for i in $(seq 1 $STACKNUM)
do
    echo "# "
    echo "# Update in flash$i"
    $BIN/sshpass -p $PASSWORT scp $DATEI $USERNAME@$DEVICE:flash$i:/$ZIEL
    FEHLERCODE=$?
    FEHLERSUMME=$((FEHLERSUMME+$FEHLERCODE))
    if [[ "$FEHLERCODE" != "0" ]] ; then 
        echo "# Fehler bei Transfer in flash$i - $FEHLERCODE "
    fi
    echo "# "
done
echo "# "
echo "# Updateschleife Ende "
echo "# "
echo "# Fehlersumme bei Aufrufen $FEHLERSUMME. Sollte 0 NULL sein"
echo "# "
