#!/bin/bash
# Umsetzung von Sebastian Boenning
# fehlersuche Q Probleme
# 
VERSION="Version 0.0.3 vom 2021-06-03 10:35 Uhr"
DATUM=`/bin/date '+%Y-%m-%d; %H:%M:%S'`
DAT=`/bin/date '+%Y-%m'`
DEVICE="$1"
POLLI="$2"
POLLDEFAULT=1
test -z $DEVICE && echo "# Es fehlt der Geraetename oder IP Adresse, Beispielaufruf $0 HOSTNAME " &&  exit
test -z $POLLI && echo "# Pollintervall ist nicht angegeben. Es wird Default Intervalll $POLLDEFAULT verwendet"
test -z $POLLI && echo "# Ansonsten Aufruf mit Beispielaufruf $0 HOSTNAME Pollintervall" && POLLI=$POLLDEFAULT

SNMPDIR=/usr/bin
SNMPTIMEOUTRO=5

LOGFILE=~/${0##*/}-$DEVICE-$DAT.txt

echo "# "
echo "# Interface Counter Abfrage von Cisco in SNMPv3 +X"
echo "# Speicherung der Counter unter $LOGFILE"
echo "# Abgefragter Host: $DEVICE mit Pollintervall $POLLI"
echo "# "

#Pfad zum menue
SNMPPROFILEENUE=/tmp/kleinkram/snmp-selektor.sh
#output des menue als variable laden ob verwendung
. ~/.SNMPCFG
if [ -z "$SNMPCFG_SNMPRO" ]; then
        echo "# kein SNMP Profil vorhanden" 
        #menue starten
        $SNMPPROFILEENUE
        . ~/.SNMPCFG
else
        echo "# "
        echo "# sollen SNMP Parameter  \"$SNMPCFG_SNMPRO\" "
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

SNMPPARAMETERRO=" -t $SNMPTIMEOUTRO -r 1 $SNMPCFG_SNMPRO "


echo "#  "       
echo "# Es folgt gleich eine Abfrage des Interface Index. "
echo "# Dazu werden die Interface Bezeichnung und Description ausgegeben. "
echo "# Anzugeben sind gleich die LAN und die WAN Schnittstelle "
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
read -r -p "Auswahl LAN Schnittstelle:" INTERFACEINID
read -r -p "Auswahl WAN Schnittstelle:" INTERFACEOUTID

SNMPPARAMETERRO=" -OQnt $SNMPPARAMETERRO "
echo "Start $DATUM"
echo "Logdaten werden in $LOGFILE gespeichert"

echo "$DEVICE;DATUM;Uhrzeit;sysUpTimeInstance;IF-MIB::ifName;IF-MIB::ifInMulticastPkts;IF-MIB::ifInBroadcastPkts;IF-MIB::ifOutMulticastPkts;IF-MIB::ifOutBroadcastPkts;IF-MIB::ifHCInOctets;IF-MIB::ifHCInUcastPkts;IF-MIB::ifHCInMulticastPkts;IF-MIB::ifHCInBroadcastPkts;IF-MIB::ifHCOutOctets;IF-MIB::ifHCOutUcastPkts;IF-MIB::ifHCOutMulticastPkts;IF-MIB::ifHCOutBroadcastPkts;IF-MIB::ifHighSpeed;IF-MIB::ifInDiscards;IF-MIB::ifInErrors;IF-MIB::ifInUnknownProtos;IF-MIB::ifOutDiscards;IF-MIB::ifOutErrors;IF-MIB::ifName;IF-MIB::ifInMulticastPkts;IF-MIB::ifInBroadcastPkts;IF-MIB::ifOutMulticastPkts;IF-MIB::ifOutBroadcastPkts;IF-MIB::ifHCInOctets;IF-MIB::ifHCInUcastPkts;IF-MIB::ifHCInMulticastPkts;IF-MIB::ifHCInBroadcastPkts;IF-MIB::ifHCOutOctets;IF-MIB::ifHCOutUcastPkts;IF-MIB::ifHCOutMulticastPkts;IF-MIB::ifHCOutBroadcastPkts;IF-MIB::ifHighSpeed;IF-MIB::ifInDiscards;IF-MIB::ifInErrors;IF-MIB::ifInUnknownProtos;IF-MIB::ifOutDiscards;IF-MIB::ifOutErrors.$INTERFACEOUTID;ETHERNT;sysUpTimeInstance;EtherLike-MIB::dot3StatsAlignmentErrors;EtherLike-MIB::dot3StatsFCSErrors;EtherLike-MIB::dot3StatsSingleCollisionFrames;EtherLike-MIB::dot3StatsMultipleCollisionFrames;EtherLike-MIB::dot3StatsSQETestErrors;EtherLike-MIB::dot3StatsDeferredTransmissions;EtherLike-MIB::dot3StatsLateCollisions;EtherLike-MIB::dot3StatsExcessiveCollisions;EtherLike-MIB::dot3StatsInternalMacTransmitErrors;EtherLike-MIB::dot3StatsCarrierSenseErrors;EtherLike-MIB::dot3StatsFrameTooLongs;EtherLike-MIB::dot3StatsInternalMacReceiveErrors;EtherLike-MIB::dot3StatsSymbolErrors;EtherLike-MIB::dot3InPauseFrames;EtherLike-MIB::dot3OutPauseFrames;EtherLike-MIB::dot3StatsAlignmentErrors;EtherLike-MIB::dot3StatsFCSErrors;EtherLike-MIB::dot3StatsSingleCollisionFrames;EtherLike-MIB::dot3StatsMultipleCollisionFrames;EtherLike-MIB::dot3StatsSQETestErrors;EtherLike-MIB::dot3StatsDeferredTransmissions;EtherLike-MIB::dot3StatsLateCollisions;EtherLike-MIB::dot3StatsExcessiveCollisions;EtherLike-MIB::dot3StatsInternalMacTransmitErrors;EtherLike-MIB::dot3StatsCarrierSenseErrors;EtherLike-MIB::dot3StatsFrameTooLongs;EtherLike-MIB::dot3StatsInternalMacReceiveErrors;EtherLike-MIB::dot3StatsSymbolErrors;EtherLike-MIB::dot3InPauseFrames;EtherLike-MIB::dot3OutPauseFrames;POLLINTERVAL" >>$LOGFILE


while true; do

DATUM=`/bin/date '+%Y-%m-%d; %H:%M:%S'`

mapfile -t interface_array < <( $SNMPDIR/snmpget $SNMPPARAMETERRO $DEVICE \
DISMAN-EVENT-MIB::sysUpTimeInstance \
IF-MIB::ifName.$INTERFACEINID \
IF-MIB::ifInMulticastPkts.$INTERFACEINID \
IF-MIB::ifInBroadcastPkts.$INTERFACEINID \
IF-MIB::ifOutMulticastPkts.$INTERFACEINID \
IF-MIB::ifOutBroadcastPkts.$INTERFACEINID \
IF-MIB::ifHCInOctets.$INTERFACEINID \
IF-MIB::ifHCInUcastPkts.$INTERFACEINID \
IF-MIB::ifHCInMulticastPkts.$INTERFACEINID \
IF-MIB::ifHCInBroadcastPkts.$INTERFACEINID \
IF-MIB::ifHCOutOctets.$INTERFACEINID \
IF-MIB::ifHCOutUcastPkts.$INTERFACEINID \
IF-MIB::ifHCOutMulticastPkts.$INTERFACEINID \
IF-MIB::ifHCOutBroadcastPkts.$INTERFACEINID \
IF-MIB::ifHighSpeed.$INTERFACEINID \
IF-MIB::ifInDiscards.$INTERFACEINID \
IF-MIB::ifInErrors.$INTERFACEINID \
IF-MIB::ifInUnknownProtos.$INTERFACEINID \
IF-MIB::ifOutDiscards.$INTERFACEINID \
IF-MIB::ifOutErrors.$INTERFACEINID \
IF-MIB::ifName.$INTERFACEOUTID \
IF-MIB::ifInMulticastPkts.$INTERFACEOUTID \
IF-MIB::ifInBroadcastPkts.$INTERFACEOUTID \
IF-MIB::ifOutMulticastPkts.$INTERFACEOUTID \
IF-MIB::ifOutBroadcastPkts.$INTERFACEOUTID \
IF-MIB::ifHCInOctets.$INTERFACEOUTID \
IF-MIB::ifHCInUcastPkts.$INTERFACEOUTID \
IF-MIB::ifHCInMulticastPkts.$INTERFACEOUTID \
IF-MIB::ifHCInBroadcastPkts.$INTERFACEOUTID \
IF-MIB::ifHCOutOctets.$INTERFACEOUTID \
IF-MIB::ifHCOutUcastPkts.$INTERFACEOUTID \
IF-MIB::ifHCOutMulticastPkts.$INTERFACEOUTID \
IF-MIB::ifHCOutBroadcastPkts.$INTERFACEOUTID \
IF-MIB::ifHighSpeed.$INTERFACEOUTID \
IF-MIB::ifInDiscards.$INTERFACEOUTID \
IF-MIB::ifInErrors.$INTERFACEOUTID \
IF-MIB::ifInUnknownProtos.$INTERFACEOUTID \
IF-MIB::ifOutDiscards.$INTERFACEOUTID \
IF-MIB::ifOutErrors.$INTERFACEOUTID )

mapfile -t ethernet_array < <( $SNMPDIR/snmpget $SNMPPARAMETERRO $DEVICE \
DISMAN-EVENT-MIB::sysUpTimeInstance \
EtherLike-MIB::dot3StatsAlignmentErrors.$INTERFACEINID \
EtherLike-MIB::dot3StatsFCSErrors.$INTERFACEINID \
EtherLike-MIB::dot3StatsSingleCollisionFrames.$INTERFACEINID \
EtherLike-MIB::dot3StatsMultipleCollisionFrames.$INTERFACEINID \
EtherLike-MIB::dot3StatsSQETestErrors.$INTERFACEINID \
EtherLike-MIB::dot3StatsDeferredTransmissions.$INTERFACEINID \
EtherLike-MIB::dot3StatsLateCollisions.$INTERFACEINID \
EtherLike-MIB::dot3StatsExcessiveCollisions.$INTERFACEINID \
EtherLike-MIB::dot3StatsInternalMacTransmitErrors.$INTERFACEINID \
EtherLike-MIB::dot3StatsCarrierSenseErrors.$INTERFACEINID \
EtherLike-MIB::dot3StatsFrameTooLongs.$INTERFACEINID \
EtherLike-MIB::dot3StatsInternalMacReceiveErrors.$INTERFACEINID \
EtherLike-MIB::dot3StatsSymbolErrors.$INTERFACEINID \
EtherLike-MIB::dot3InPauseFrames.$INTERFACEINID \
EtherLike-MIB::dot3OutPauseFrames.$INTERFACEINID \
EtherLike-MIB::dot3StatsAlignmentErrors.$INTERFACEOUTID \
EtherLike-MIB::dot3StatsFCSErrors.$INTERFACEOUTID \
EtherLike-MIB::dot3StatsSingleCollisionFrames.$INTERFACEOUTID \
EtherLike-MIB::dot3StatsMultipleCollisionFrames.$INTERFACEOUTID \
EtherLike-MIB::dot3StatsSQETestErrors.$INTERFACEOUTID \
EtherLike-MIB::dot3StatsDeferredTransmissions.$INTERFACEOUTID \
EtherLike-MIB::dot3StatsLateCollisions.$INTERFACEOUTID \
EtherLike-MIB::dot3StatsExcessiveCollisions.$INTERFACEOUTID \
EtherLike-MIB::dot3StatsInternalMacTransmitErrors.$INTERFACEOUTID \
EtherLike-MIB::dot3StatsCarrierSenseErrors.$INTERFACEOUTID \
EtherLike-MIB::dot3StatsFrameTooLongs.$INTERFACEOUTID \
EtherLike-MIB::dot3StatsInternalMacReceiveErrors.$INTERFACEOUTID \
EtherLike-MIB::dot3StatsSymbolErrors.$INTERFACEOUTID \
EtherLike-MIB::dot3InPauseFrames.$INTERFACEOUTID \
EtherLike-MIB::dot3OutPauseFrames.$INTERFACEOUTID )

OUTPUTVAR2=$DEVICE";"$DATUM
for m in "${interface_array[@]}";
do
        OUTPUTVAR2=$OUTPUTVAR2";"$(echo -e $m | cut -d"=" -f2)
done

OUTPUTVAR1=$OUTPUTVAR1";"ETHERNET
OUTPUTVAR2=$OUTPUTVAR2";"ETHERNET


for m in "${ethernet_array[@]}";
do
        OUTPUTVAR2=$OUTPUTVAR2";"$(echo -e $m | cut -d"=" -f2)
done

echo $OUTPUTVAR2";"$POLLI >>$LOGFILE
echo -n "."

sleep $POLLI
 
done
