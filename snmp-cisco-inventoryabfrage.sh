#!/bin/bash
# Umsetzung von Sebastian Boenning
# Part of https://github.com/servidge/snowflakes
# Abfrage der Eingebauten Module und deren Seriennummern
VERSION="Version 0.4 vom 2021-03-26 09:00 Uhr"

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

SNMPHOSTNAME=.1.3.6.1.2.1.1.5.0
#SNMPv2-SMI::mib-2.47.1.1.1.1.7.1064 = STRING: "TenGigabitEthernet1/0/2"
SNMPMODULPHYS=.1.3.6.1.2.1.47.1.1.1.1.7
#SNMPv2-SMI::mib-2.47.1.1.1.1.2.1064 = STRING: "SFP-10GBase-SR"
SNMPMODULNAME=.1.3.6.1.2.1.47.1.1.1.1.2
#SNMPv2-SMI::mib-2.47.1.1.1.1.13.1064 = STRING: "SFP-10G-SR-S        "
SNMPMODULID=.1.3.6.1.2.1.47.1.1.1.1.13
#SNMPv2-SMI::mib-2.47.1.1.1.1.8.1064 = STRING: "V01 "
SNMPMODULREV=.1.3.6.1.2.1.47.1.1.1.1.8
#SNMPv2-SMI::mib-2.47.1.1.1.1.11.1064 = STRING: "SNR+spaces     "
SNMPMODULSNR=.1.3.6.1.2.1.47.1.1.1.1.11


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
    echo "# Keine Parameter angegeben, "
    echo "# Aufuf mit $0 <Hostname oder IP > "
    echo "# oder fue mehrere nach vorheriger snmp Profilauswahl mit"
    echo "# Aufuf mit $0 --batch <Hostname oder IP > <Hostname oder IP > <Hostname oder IP > ..."
    echo "#"
    exit 1
else
    if [ $1 = "--batch" ]; then
    . ~/.SNMPCFG
    shift
    echo "# Batchabarbeitung der Folgenden Hostnamen oder IPs mit den voreingestellten SNMP Parametern"
    echo "# Hostnamen oder IPs: $@"
        for host in "$@"; do 
            echo "# Abfrage Hostnamen oder IPs: $host"
            f_snmp_hostname $host
            f_snmp_modulsuche $host
            f_snmp_ifstatuslog $host
        done
    else
        echo "# Abfrage Hostnamen oder IPs: $1"
        f_snmp_selekt
        f_snmp_hostname $1
        f_snmp_modulsuche $1
        f_snmp_ifstatuslog $1
    fi
fi
exit
