#!/bin/bash
# Umsetzung von Sebastian Boenning
# Part of https://github.com/servidge/snowflakes
# 
VERSION="Version 0.0.3 vom 2021-08-27 10:30 Uhr"
SNMPDIR=/usr/bin
TOOLDIR=/tmp
DEVICE="$1"
POLLI=2

test -z $DEVICE && echo "# Es fehlt der Geraetename oder IP Adresse, Beispielaufruf $0 HOSTNAME " &&  exit

#Pfad zum menue
SNMPPROFILEENUE=$TOOLDIR/kleinkram/snmp-selektor.sh
#output des menue als variable laden ob verwendung
. ~/.SNMPCFG
if [ -z "$SNMPCFG_SNMPRO" ]; then
        echo "# kein SNMP Profil vorhanden" 
        #menue starten
        $SNMPPROFILEENUE
        . ~/.SNMPCFG
else
        echo "# "
        echo "# soll SNMP Profil       : \"$SNMPCFG_SNMPPROF\" "
        echo "# mit  SNMP Parameter    : \"$SNMPCFG_SNMP\" "
        echo "# mit  SNMP Parameter RW : \"$SNMPCFG_SNMPRW\" "
        echo "# mit  SNMP Parameter RO : \"$SNMPCFG_SNMPRO\" "
        echo "# verwendet werden? OK=y"
        echo "# "
        read -r -p "# y oder Enter OK, Alles andere Neuauswah. Auswahl:" key
        if [ "$key" = "y" ] || [ "$key" = "" ]; then
              echo "# Ok "
        else
              #menue starten
              $SNMPPROFILEENUE
              . ~/.SNMPCFG
        fi
fi


SNMPPARAMETERRO=" $SNMPCFG_SNMPRO "

echo "#  "       
echo "# Es folgt gleich eine Abfrage des Interface Index. "
echo "# Dazu werden die Interface Bezeichnung und Description ausgegeben. "
read -t 5 -n 1 -s -r -p "# OK Weiter"
echo "#  "
echo "#  "
echo "# IF-MIB::ifDescr"
$SNMPDIR/snmpwalk $SNMPPARAMETERRO $DEVICE 1.3.6.1.2.1.2.2.1.2
echo "# IF-MIB::ifAlias"
$SNMPDIR/snmpwalk $SNMPPARAMETERRO $DEVICE 1.3.6.1.2.1.31.1.1.1.18
echo "#  "       
echo "# Beispiel: IF-MIB::ifDescr.29 = STRING: Dialer1"
echo "# Beispiel: IF-MIB::ifAlias.29 = STRING: Dialer_DSL_ueber_Dial_In_Plattform_via_PPPOE"
echo "# Anzugeben ist dann    >>>>^^<<<<"
echo "#  "
read -r -p "Auswahl:" ifindex
IFDESC=$($SNMPDIR/snmpget -Oqv $SNMPPARAMETERRO $DEVICE 1.3.6.1.2.1.2.2.1.2.$ifindex)
IFALIA=$($SNMPDIR/snmpget -Oqv $SNMPPARAMETERRO $DEVICE 1.3.6.1.2.1.31.1.1.1.18.$ifindex)
IFSPEE=$($SNMPDIR/snmpget -Oqv $SNMPPARAMETERRO $DEVICE .1.3.6.1.2.1.2.2.1.5.$ifindex)
IFSPEE=$(($IFSPEE/1000/1000))
echo "#  "
echo "# Weiter mit Interface $ifindex, Interface $IFDESC mit Description $IFALIA und Speed $IFSPEE Mbit auf Router $DEVICE"
echo "# Pollintervall ist $POLLI Sekunden "
read -t 5 -n 1 -s -r -p "# OK Weiter"

# ttyplot >>> https://github.com/tenox7/ttyplot 

$SNMPDIR/snmpdelta -Cp $POLLI $SNMPPARAMETERRO $DEVICE 1.3.6.1.2.1.2.2.1.10.$ifindex 1.3.6.1.2.1.2.2.1.16.$ifindex | gawk -v d=$POLLI '{ print $NF*8/1000/1000/d; fflush(); }' | $TOOLDIR/kleinkram/bin/ttyplot -2 -c i -s $(($IFSPEE/2)) -t "Host $DEVICE, Interface $IFDESC,Speed $IFSPEE Mbit mit Descr. $IFALIA" -u Mbit/s


