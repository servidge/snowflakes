#!/bin/bash
# Idee Umsetzung vom Script von Sebastian Bönning
# Abfrage der Eingebauten Module und deren Seriennummern
VERSION="Version 0.3 vom 2021-03-25 10:00 Uhr"

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
        echo "# Prüfe auf $1 $SNMPMODTYP"
        result0=`$SNMPDIR/snmpget -Onqv $SNMPCFG_SNMPRO  "$1" $SNMPMODULSNR$SNMPMODINDEX `
        FEHLER=$?
        if [[ "$FEHLER" != "0" ]] ; then 
                        result0="Fehler:$FEHLER"
        fi
        result1=`$SNMPDIR/snmpget -Onqv $SNMPCFG_SNMPRO  "$1" $SNMPMODULNAME$SNMPMODINDEX `
        FEHLER=$?
        if [[ "$FEHLER" != "0" ]] ; then 
                        result0="Fehler:$FEHLER"
        fi
                
        echo $1"; "$HOSTNAME"; "$SNMPMODINDEX"; "$SNMPMODTYP"; "$result0"; "$result1"; "$result2"; " >> $TEMPDIR$1-$DATUM.temp2
        echo $1"; "$HOSTNAME"; "$SNMPMODINDEX"; "$SNMPMODTYP"; "$result0"; "$result1"; "$result2"; "
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
