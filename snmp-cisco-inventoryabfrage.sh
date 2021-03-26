#!/bin/bash
# Idee Umsetzung vom Script von Sebastian Bönning
# Abfrage der Eingebauten Module und deren Seriennummern
VERSION="Version 0.3 vom 2021-03-25 16:00 Uhr"

DATUM=`/bin/date '+%Y%m%d-%H%M%S'`
DAT=`/bin/date '+%Y-%m-%d'`
#USERNAME=$(whoami)
WORKDIR=/home/username/snmpabfragen/
TEMPDIR=/home/username/snmpabfragen/tmp/
LOGDIR=/home/username/snmpabfragen/log/
LOG=/home/username/snmpabfragen/log/$DATUM.log
SNMPDIR=/usr/bin/
TOOLDIR=/tmp
SNMPVERSION=2c
SNMPCOMMUNITYRO=$2
#SNMPCOMMUNITYRO=qwertz
SNMPTIMEOUTRO=5
SNMPTIMEOUTRW=15

SNMPMODULID=.1.3.6.1.2.1.47.1.1.1.1.13
SNMPMODULNAME=.1.3.6.1.2.1.47.1.1.1.1.2.
SNMPMODULSNR=.1.3.6.1.2.1.47.1.1.1.1.11.
#SNMPCFG_SNMPRO="-v 3 -l authPriv -a sha -A authshaPwD -x AES -X privaesPwD -u SNMPUSER-RO"

f_snmp_selekt () {
#Pfad zum menue
SNMPPROFILEENUE=$TOOLDIR/kleinkram/snmp-selektor.sh
#output des menue als variable laden ob verwendung
. ~/.SNMPCFG
if [ -z "$SNMPCFG_SNMPRW" ]; then
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
}

f_snmp_hostname () {
HOSTNAME=`$SNMPDIR/snmpget -Onqv $SNMPCFG_SNMPRO "$1" $SNMPHOSTNAME`
HOSTNAME=`echo $HOSTNAME | cut -d"." -f1 `
}

f_snmp_ifsuche () {
$SNMPDIR/snmpwalk -Onq $SNMPCFG_SNMPRO "$1" $SNMPMODULID | cut -d"." -f14,15,16,17 | grep -v '""'>$TEMPDIR$1-$DATUM.temp1
}

f_snmp_ifstatuslog () {
#echo "">$TEMPDIR$1-$DATUM.temp2
echo "Hostname; SNMPMODINDEX; SNMPMODTYP; SNMPMODUL-SNR; SNMPMODULNAME" > $TEMPDIR$1-$DATUM.temp2
#HOSTUPTIME=`$SNMPDIR/snmpget -Otqv -v$SNMPVERSION -c$SNMPCOMMUNITYRO -t$SNMPTIMEOUTRO "$1" $SNMPUPTIME`
while read line
do 
    #echo $line
    SNMPMODINDEX=`echo $line | cut -d" " -f1 `
    SNMPMODTYP=`echo $line | cut -d" " -f2 `

    entPhysicalName=`$SNMPDIR/snmpget -Onqv $SNMPCFG_SNMPRO  "$1" $SNMPMODULPHYS.$SNMPMODINDEX | tr -d "\""`
    FEHLER=$?
    if [[ "$FEHLER" != "0" ]] ; then 
        entPhysicalName="Fehler:$FEHLER"
    fi
    entPhysicalName=`echo $entPhysicalName | sed 's/ *$//g'`

    entPhysicalDescr=`$SNMPDIR/snmpget -Onqv $SNMPCFG_SNMPRO  "$1" $SNMPMODULNAME.$SNMPMODINDEX  | tr -d "\""`
    FEHLER=$?
    if [[ "$FEHLER" != "0" ]] ; then 
        entPhysicalDescr="Fehler:$FEHLER"
    fi
    entPhysicalDescr=`echo $entPhysicalDescr | sed 's/ *$//g'`

    entPhysicalModelName=`$SNMPDIR/snmpget -Onqv $SNMPCFG_SNMPRO  "$1" $SNMPMODULID.$SNMPMODINDEX  | tr -d "\""`
    FEHLER=$?
    if [[ "$FEHLER" != "0" ]] ; then 
        entPhysicalModelName="Fehler:$FEHLER"
    fi
    entPhysicalModelName=`echo $entPhysicalModelName | sed 's/ *$//g'`

    entPhysicalHardwareRev=`$SNMPDIR/snmpget -Onqv $SNMPCFG_SNMPRO  "$1" $SNMPMODULREV.$SNMPMODINDEX  | tr -d "\""`
    FEHLER=$?
    if [[ "$FEHLER" != "0" ]] ; then 
        entPhysicalHardwareRev="Fehler:$FEHLER"
    fi
    entPhysicalHardwareRev=`echo $entPhysicalHardwareRev | sed 's/ *$//g'`

    entPhysicalSerialNum=`$SNMPDIR/snmpget -Onqv $SNMPCFG_SNMPRO  "$1" $SNMPMODULSNR.$SNMPMODINDEX  | tr -d "\""`
    FEHLER=$?
    if [[ "$FEHLER" != "0" ]] ; then 
        entPhysicalSerialNum="Fehler:$FEHLER"
    fi
    entPhysicalSerialNum=`echo $entPhysicalSerialNum | sed 's/ *$//g'`
    echo INVENTORY"; "$HOSTNAME"; "$SNMPMODINDEX"; "$SNMPMODTYP"; "$result0"; "$result1"; "$result2"; " >> $TEMPDIR$1-$DATUM.temp2
    echo INVENTORY"; "$HOSTNAME"; "$entPhysicalName"; "$entPhysicalDescr"; "$entPhysicalModelName"; "$entPhysicalHardwareRev"; "$entPhysicalSerialNum"; "
done<$TEMPDIR$1-$DATUM.temp1
}

#----------- MAIN Start ------------#
if [ "$#" -eq 0 ] ; then
        echo "#"
        echo "# Keine Parameter angegeben, Aufuf mit $0 <Hostname oder IP > <snmpcommunity>"
        echo "#"
        exit 1
else
        f_snmp_selekt
        f_snmp_hostname $1
        f_snmp_ifsuche $1
        f_snmp_ifstatuslog $1
fi
exit
