#!/bin/bash
# Umsetzung von Sebastian Boenning
# fehlersuche Q Probleme
# Ausgabe der mit interfacestat.sh aufgezeichneten Logdaten in der Konsole. 
#

cmds(){
###############################################################################
echo "Ausgabe von $DEVICE #am $DATUM#um $Uhrzeit###"
echo "Uptime in Timetics#$ACTsysUpTimeInstance1#diff zur vorherigen#$((ACTsysUpTimeInstance1-VORsysUpTimeInstance1))##"
echo "Bezeichner #Aktuell1#Differenz zu Vorher1#Aktuell 2#Differenz zu Vorher 2#"
echo "Interface #$ACTIFMIBifNameINTERFACEINID##$ACTIFMIBifNameINTERFACEOUTID##"
echo "Interface-Speed #$ACTIFMIBifHighSpeedINTERFACEINID##$ACTIFMIBifHighSpeedINTERFACEOUTID##"

echo "InMulticastPkts #$ACTIFMIBifInMulticastPktsINTERFACEINID#$((ACTIFMIBifInMulticastPktsINTERFACEINID-VORIFMIBifInMulticastPktsINTERFACEINID))#$ACTIFMIBifInMulticastPktsINTERFACEOUTID#$((ACTIFMIBifInMulticastPktsINTERFACEOUTID-VORIFMIBifInMulticastPktsINTERFACEOUTID))#"
echo "InBroadcastPkts #$ACTIFMIBifInBroadcastPktsINTERFACEINID#$((ACTIFMIBifInBroadcastPktsINTERFACEINID-VORIFMIBifInBroadcastPktsINTERFACEINID))#$ACTIFMIBifInBroadcastPktsINTERFACEOUTID#$((ACTIFMIBifInBroadcastPktsINTERFACEOUTID-VORIFMIBifInBroadcastPktsINTERFACEOUTID))#"
echo "In Summe Pkts #$((ACTIFMIBifInMulticastPktsINTERFACEINID+ACTIFMIBifInBroadcastPktsINTERFACEINID))#$((ACTIFMIBifInMulticastPktsINTERFACEINID-VORIFMIBifInMulticastPktsINTERFACEINID+ACTIFMIBifInBroadcastPktsINTERFACEINID-VORIFMIBifInBroadcastPktsINTERFACEINID))#$((ACTIFMIBifInMulticastPktsINTERFACEOUTID+ACTIFMIBifInBroadcastPktsINTERFACEOUTID))#$((ACTIFMIBifInMulticastPktsINTERFACEOUTID-VORIFMIBifInMulticastPktsINTERFACEOUTID+ACTIFMIBifInBroadcastPktsINTERFACEOUTID-VORIFMIBifInBroadcastPktsINTERFACEOUTID))#"

echo "OutMulticastPkts #$ACTIFMIBifOutMulticastPktsINTERFACEINID#$((ACTIFMIBifOutMulticastPktsINTERFACEINID-VORIFMIBifOutMulticastPktsINTERFACEINID))#$ACTIFMIBifOutMulticastPktsINTERFACEOUTID#$((ACTIFMIBifOutMulticastPktsINTERFACEOUTID-VORIFMIBifOutMulticastPktsINTERFACEOUTID))#"
echo "OutBroadcastPkts #$ACTIFMIBifOutBroadcastPktsINTERFACEINID#$((ACTIFMIBifOutBroadcastPktsINTERFACEINID-VORIFMIBifOutBroadcastPktsINTERFACEINID))#$ACTIFMIBifOutBroadcastPktsINTERFACEOUTID#$((ACTIFMIBifOutBroadcastPktsINTERFACEOUTID-VORIFMIBifOutBroadcastPktsINTERFACEOUTID))#"
echo "Out Summe Pkts #$((ACTIFMIBifOutMulticastPktsINTERFACEINID+ACTIFMIBifOutBroadcastPktsINTERFACEINID))#$((ACTIFMIBifOutMulticastPktsINTERFACEINID-VORIFMIBifOutMulticastPktsINTERFACEINID+ACTIFMIBifOutBroadcastPktsINTERFACEINID-VORIFMIBifOutBroadcastPktsINTERFACEINID))#$((ACTIFMIBifOutMulticastPktsINTERFACEOUTID+ACTIFMIBifOutBroadcastPktsINTERFACEOUTID))#$((ACTIFMIBifOutMulticastPktsINTERFACEOUTID-VORIFMIBifOutMulticastPktsINTERFACEOUTID+ACTIFMIBifOutBroadcastPktsINTERFACEOUTID-VORIFMIBifOutBroadcastPktsINTERFACEOUTID))#"

echo "InOctets #$ACTIFMIBifHCInOctetsINTERFACEINID#$((ACTIFMIBifHCInOctetsINTERFACEINID-VORIFMIBifHCInOctetsINTERFACEINID))#$ACTIFMIBifHCInOctetsINTERFACEOUTID#$((ACTIFMIBifHCInOctetsINTERFACEOUTID-VORIFMIBifHCInOctetsINTERFACEOUTID))#"
echo "MBit/s #$(($((ACTIFMIBifHCInOctetsINTERFACEINID-VORIFMIBifHCInOctetsINTERFACEINID))*8/1000/1000/100*$((ACTsysUpTimeInstance1-VORsysUpTimeInstance1))))##$(($((ACTIFMIBifHCInOctetsINTERFACEOUTID-VORIFMIBifHCInOctetsINTERFACEOUTID))*8/1000/1000/100*$((ACTsysUpTimeInstance1-VORsysUpTimeInstance1))))##"
echo "InUcastPkts #$ACTIFMIBifHCInUcastPktsINTERFACEINID#$((ACTIFMIBifHCInUcastPktsINTERFACEINID-VORIFMIBifHCInUcastPktsINTERFACEINID))#$ACTIFMIBifHCInUcastPktsINTERFACEOUTID#$((ACTIFMIBifHCInUcastPktsINTERFACEOUTID-VORIFMIBifHCInUcastPktsINTERFACEOUTID))#"
echo "InMulticastPkts #$ACTIFMIBifHCInMulticastPktsINTERFACEINID#$((ACTIFMIBifHCInMulticastPktsINTERFACEINID-VORIFMIBifHCInMulticastPktsINTERFACEINID))#$ACTIFMIBifHCInMulticastPktsINTERFACEOUTID#$((ACTIFMIBifHCInMulticastPktsINTERFACEOUTID-VORIFMIBifHCInMulticastPktsINTERFACEOUTID))#"
echo "InBroadcastPkts #$ACTIFMIBifHCInBroadcastPktsINTERFACEINID#$((ACTIFMIBifHCInBroadcastPktsINTERFACEINID-VORIFMIBifHCInBroadcastPktsINTERFACEINID))#$ACTIFMIBifHCInBroadcastPktsINTERFACEOUTID#$((ACTIFMIBifHCInBroadcastPktsINTERFACEOUTID-VORIFMIBifHCInBroadcastPktsINTERFACEOUTID))#"
echo "In Summe Pkts #$((ACTIFMIBifHCInUcastPktsINTERFACEINID+ACTIFMIBifHCInBroadcastPktsINTERFACEINID+ACTIFMIBifHCInBroadcastPktsINTERFACEINID))#$((ACTIFMIBifHCInUcastPktsINTERFACEINID-VORIFMIBifHCInUcastPktsINTERFACEINID+ACTIFMIBifHCInMulticastPktsINTERFACEINID-VORIFMIBifHCInMulticastPktsINTERFACEINID+ACTIFMIBifHCInBroadcastPktsINTERFACEINID-VORIFMIBifHCInBroadcastPktsINTERFACEINID))#$((ACTIFMIBifHCInUcastPktsINTERFACEOUTID+ACTIFMIBifHCInMulticastPktsINTERFACEOUTID+ACTIFMIBifHCInBroadcastPktsINTERFACEOUTID))#$((ACTIFMIBifHCInUcastPktsINTERFACEOUTID-VORIFMIBifHCInUcastPktsINTERFACEOUTID+ACTIFMIBifHCInMulticastPktsINTERFACEOUTID-VORIFMIBifHCInMulticastPktsINTERFACEOUTID+ACTIFMIBifHCInBroadcastPktsINTERFACEOUTID-VORIFMIBifHCInBroadcastPktsINTERFACEOUTID))#"

echo "OutOctets #$ACTIFMIBifHCOutOctetsINTERFACEINID#$((ACTIFMIBifHCOutOctetsINTERFACEINID-VORIFMIBifHCOutOctetsINTERFACEINID))#$ACTIFMIBifHCOutOctetsINTERFACEOUTID##"
echo "MBit/s #$(($((ACTIFMIBifHCOutOctetsINTERFACEINID-VORIFMIBifHCOutOctetsINTERFACEINID))*8/1000/1000/100*$((ACTsysUpTimeInstance1-VORsysUpTimeInstance1))))##$(($((ACTIFMIBifHCOutOctetsINTERFACEOUTID-VORIFMIBifHCOutOctetsINTERFACEOUTID))*8/1000/1000/100*$((ACTsysUpTimeInstance1-VORsysUpTimeInstance1))))##"
echo "OutUcastPkts #$ACTIFMIBifHCOutUcastPktsINTERFACEINID#$((ACTIFMIBifHCOutUcastPktsINTERFACEINID-VORIFMIBifHCOutUcastPktsINTERFACEINID))#$ACTIFMIBifHCOutUcastPktsINTERFACEOUTID#$((ACTIFMIBifHCOutUcastPktsINTERFACEOUTID-VORIFMIBifHCOutUcastPktsINTERFACEOUTID))#"
echo "OutMulticastPkts #$ACTIFMIBifHCOutMulticastPktsINTERFACEINID#$((ACTIFMIBifHCOutMulticastPktsINTERFACEINID-VORIFMIBifHCOutMulticastPktsINTERFACEINID))#$ACTIFMIBifHCOutMulticastPktsINTERFACEOUTID#$((ACTIFMIBifHCOutMulticastPktsINTERFACEOUTID-VORIFMIBifHCOutMulticastPktsINTERFACEOUTID))#"
echo "OutBroadcastPkts #$ACTIFMIBifHCOutBroadcastPktsINTERFACEINID#$((ACTIFMIBifHCOutBroadcastPktsINTERFACEINID-VORIFMIBifHCOutBroadcastPktsINTERFACEINID))#$ACTIFMIBifHCOutBroadcastPktsINTERFACEOUTID#$((ACTIFMIBifHCOutBroadcastPktsINTERFACEOUTID-VORIFMIBifHCOutBroadcastPktsINTERFACEOUTID))#"
echo "Out Summe Pkts #$((ACTIFMIBifHCOutUcastPktsINTERFACEINID+ACTIFMIBifHCOutMulticastPktsINTERFACEINID+ACTIFMIBifHCOutBroadcastPktsINTERFACEINID))#$((ACTIFMIBifHCOutUcastPktsINTERFACEINID-VORIFMIBifHCOutUcastPktsINTERFACEINID+ACTIFMIBifHCOutMulticastPktsINTERFACEINID-VORIFMIBifHCOutMulticastPktsINTERFACEINID+ACTIFMIBifHCOutBroadcastPktsINTERFACEINID-VORIFMIBifHCOutBroadcastPktsINTERFACEINID))#$((ACTIFMIBifHCOutUcastPktsINTERFACEOUTID+ACTIFMIBifHCOutMulticastPktsINTERFACEOUTID+ACTIFMIBifHCOutBroadcastPktsINTERFACEOUTID))#$((ACTIFMIBifHCOutUcastPktsINTERFACEOUTID-VORIFMIBifHCOutUcastPktsINTERFACEOUTID+ACTIFMIBifHCOutMulticastPktsINTERFACEOUTID-VORIFMIBifHCOutMulticastPktsINTERFACEOUTID+ACTIFMIBifHCOutBroadcastPktsINTERFACEOUTID-VORIFMIBifHCOutBroadcastPktsINTERFACEOUTID))#"

echo "InDiscards #$ACTIFMIBifInDiscardsINTERFACEINID#$((ACTIFMIBifInDiscardsINTERFACEINID-VORIFMIBifInDiscardsINTERFACEINID))#$ACTIFMIBifInDiscardsINTERFACEOUTID#$((ACTIFMIBifInDiscardsINTERFACEOUTID-VORIFMIBifInDiscardsINTERFACEOUTID))#"
echo "InErrors #$ACTIFMIBifInErrorsINTERFACEINID#$((ACTIFMIBifInErrorsINTERFACEINID-VORIFMIBifInErrorsINTERFACEINID))#$ACTIFMIBifInErrorsINTERFACEOUTID#$((ACTIFMIBifInErrorsINTERFACEOUTID-VORIFMIBifInErrorsINTERFACEOUTID))#"
echo "InUnknownProtos #$ACTIFMIBifInUnknownProtosINTERFACEINID#$((ACTIFMIBifInUnknownProtosINTERFACEINID-VORIFMIBifInUnknownProtosINTERFACEINID))#$ACTIFMIBifInUnknownProtosINTERFACEOUTID#$((ACTIFMIBifInUnknownProtosINTERFACEOUTID-VORIFMIBifInUnknownProtosINTERFACEOUTID))#"
echo "Fehler OutDiscards #$ACTIFMIBifOutDiscardsINTERFACEINID#$((ACTIFMIBifOutDiscardsINTERFACEINID-VORIFMIBifOutDiscardsINTERFACEINID))#$ACTIFMIBifOutDiscardsINTERFACEOUTID#$((ACTIFMIBifOutDiscardsINTERFACEOUTID-VORIFMIBifOutDiscardsINTERFACEOUTID))#"
echo "Fehler OutErrors #$ACTIFMIBifOutErrorsINTERFACEINID#$((ACTIFMIBifOutErrorsINTERFACEINID-VORIFMIBifOutErrorsINTERFACEINID))#$ACTIFMIBifOutErrorsINTERFACEOUTID#$((ACTIFMIBifOutErrorsINTERFACEOUTID-VORIFMIBifOutErrorsINTERFACEOUTID))#"
echo "#####"
echo "Uptime in Timetics#$ACTsysUpTimeInstance2#diff zur vorherigen#$((ACTsysUpTimeInstance2-VORsysUpTimeInstance2))##"

echo "AlignmentErrors #$ACTEtherLikeMIBdot3StatsAlignmentErrorsINTERFACEINID #$((ACTEtherLikeMIBdot3StatsAlignmentErrorsINTERFACEINID-$VOREtherLikeMIBdot3StatsAlignmentErrorsINTERFACEINID))#$ACTEtherLikeMIBdot3StatsAlignmentErrorsINTERFACEOUTID#$((ACTEtherLikeMIBdot3StatsAlignmentErrorsINTERFACEOUTID-$VOREtherLikeMIBdot3StatsAlignmentErrorsINTERFACEOUTID))#"

echo "FCSErrors #$ACTEtherLikeMIBdot3StatsFCSErrorsINTERFACEINID#$((ACTEtherLikeMIBdot3StatsFCSErrorsINTERFACEINID-$VOREtherLikeMIBdot3StatsFCSErrorsINTERFACEINID))#$ACTEtherLikeMIBdot3StatsFCSErrorsINTERFACEOUTID#$((ACTEtherLikeMIBdot3StatsFCSErrorsINTERFACEOUTID-$VOREtherLikeMIBdot3StatsFCSErrorsINTERFACEOUTID))#"
echo "SingleCollisionFrames #$ACTEtherLikeMIBdot3StatsSingleCollisionFramesINTERFACEINID#$((ACTEtherLikeMIBdot3StatsSingleCollisionFramesINTERFACEINID-$VOREtherLikeMIBdot3StatsSingleCollisionFramesINTERFACEINID))#$ACTEtherLikeMIBdot3StatsSingleCollisionFramesINTERFACEOUTID#$((ACTEtherLikeMIBdot3StatsSingleCollisionFramesINTERFACEOUTID-$VOREtherLikeMIBdot3StatsSingleCollisionFramesINTERFACEOUTID))#"
echo "MultipleCollisionFrames #$ACTEtherLikeMIBdot3StatsMultipleCollisionFramesINTERFACEINID#$((ACTEtherLikeMIBdot3StatsMultipleCollisionFramesINTERFACEINID-$VOREtherLikeMIBdot3StatsMultipleCollisionFramesINTERFACEINID))#$ACTEtherLikeMIBdot3StatsMultipleCollisionFramesINTERFACEOUTID#$((ACTEtherLikeMIBdot3StatsMultipleCollisionFramesINTERFACEOUTID-$VOREtherLikeMIBdot3StatsMultipleCollisionFramesINTERFACEOUTID))#"
echo "SQETestErrors #$ACTEtherLikeMIBdot3StatsSQETestErrorsINTERFACEINID#$((ACTEtherLikeMIBdot3StatsSQETestErrorsINTERFACEINID-$VOREtherLikeMIBdot3StatsSQETestErrorsINTERFACEINID))#$ACTEtherLikeMIBdot3StatsSQETestErrorsINTERFACEOUTID#$((ACTEtherLikeMIBdot3StatsSQETestErrorsINTERFACEOUTID-$VOREtherLikeMIBdot3StatsSQETestErrorsINTERFACEOUTID))#"
echo "DeferredTransmissions #$ACTEtherLikeMIBdot3StatsDeferredTransmissionsINTERFACEINID#$((ACTEtherLikeMIBdot3StatsDeferredTransmissionsINTERFACEINID-$VOREtherLikeMIBdot3StatsDeferredTransmissionsINTERFACEINID))#$ACTEtherLikeMIBdot3StatsDeferredTransmissionsINTERFACEOUTID#$((ACTEtherLikeMIBdot3StatsDeferredTransmissionsINTERFACEOUTID-$VOREtherLikeMIBdot3StatsDeferredTransmissionsINTERFACEOUTID))#"
echo "LateCollisions #$ACTEtherLikeMIBdot3StatsLateCollisionsINTERFACEINID#$((ACTEtherLikeMIBdot3StatsLateCollisionsINTERFACEINID-$VOREtherLikeMIBdot3StatsLateCollisionsINTERFACEINID))#$ACTEtherLikeMIBdot3StatsLateCollisionsINTERFACEOUTID#$((ACTEtherLikeMIBdot3StatsLateCollisionsINTERFACEOUTID-$VOREtherLikeMIBdot3StatsLateCollisionsINTERFACEOUTID))#"
echo "ExcessiveCollisions #$ACTEtherLikeMIBdot3StatsExcessiveCollisionsINTERFACEINID#$((ACTEtherLikeMIBdot3StatsExcessiveCollisionsINTERFACEINID-$VOREtherLikeMIBdot3StatsExcessiveCollisionsINTERFACEINID))#$ACTEtherLikeMIBdot3StatsExcessiveCollisionsINTERFACEOUTID#$((ACTEtherLikeMIBdot3StatsExcessiveCollisionsINTERFACEOUTID-$VOREtherLikeMIBdot3StatsExcessiveCollisionsINTERFACEOUTID))#"
echo "InternalMacTransmitErrors #$ACTEtherLikeMIBdot3StatsInternalMacTransmitErrorsINTERFACEINID#$((ACTEtherLikeMIBdot3StatsInternalMacTransmitErrorsINTERFACEINID-$VOREtherLikeMIBdot3StatsInternalMacTransmitErrorsINTERFACEINID))#$ACTEtherLikeMIBdot3StatsInternalMacTransmitErrorsINTERFACEOUTID#$((ACTEtherLikeMIBdot3StatsInternalMacTransmitErrorsINTERFACEOUTID-$VOREtherLikeMIBdot3StatsInternalMacTransmitErrorsINTERFACEOUTID))#"
echo "CarrierSenseErrors #$ACTEtherLikeMIBdot3StatsCarrierSenseErrorsINTERFACEINID#$((ACTEtherLikeMIBdot3StatsCarrierSenseErrorsINTERFACEINID-$VOREtherLikeMIBdot3StatsCarrierSenseErrorsINTERFACEINID))#$ACTEtherLikeMIBdot3StatsCarrierSenseErrorsINTERFACEOUTID#$((ACTEtherLikeMIBdot3StatsCarrierSenseErrorsINTERFACEOUTID-$VOREtherLikeMIBdot3StatsCarrierSenseErrorsINTERFACEOUTID))#"
echo "FrameTooLongs #$ACTEtherLikeMIBdot3StatsFrameTooLongsINTERFACEINID#$((ACTEtherLikeMIBdot3StatsFrameTooLongsINTERFACEINID-$VOREtherLikeMIBdot3StatsFrameTooLongsINTERFACEINID))#$ACTEtherLikeMIBdot3StatsFrameTooLongsINTERFACEOUTID#$((ACTEtherLikeMIBdot3StatsFrameTooLongsINTERFACEOUTID-$VOREtherLikeMIBdot3StatsFrameTooLongsINTERFACEOUTID))#"
echo "InternalMacReceiveErrors #$ACTEtherLikeMIBdot3StatsInternalMacReceiveErrorsINTERFACEINID#$((ACTEtherLikeMIBdot3StatsInternalMacReceiveErrorsINTERFACEINID-$VOREtherLikeMIBdot3StatsInternalMacReceiveErrorsINTERFACEINID))#$ACTEtherLikeMIBdot3StatsInternalMacReceiveErrorsINTERFACEOUTID#$((ACTEtherLikeMIBdot3StatsInternalMacReceiveErrorsINTERFACEOUTID-$VOREtherLikeMIBdot3StatsInternalMacReceiveErrorsINTERFACEOUTID))#"
echo "SymbolErrors #$ACTEtherLikeMIBdot3StatsSymbolErrorsINTERFACEINID#$((ACTEtherLikeMIBdot3StatsSymbolErrorsINTERFACEINID-$VOREtherLikeMIBdot3StatsSymbolErrorsINTERFACEINID))#$ACTEtherLikeMIBdot3StatsSymbolErrorsINTERFACEOUTID#$((ACTEtherLikeMIBdot3StatsSymbolErrorsINTERFACEOUTID-$VOREtherLikeMIBdot3StatsSymbolErrorsINTERFACEOUTID))#"
echo "InPauseFrames #$ACTEtherLikeMIBdot3InPauseFramesINTERFACEINID#$((ACTEtherLikeMIBdot3InPauseFramesINTERFACEINID-$VOREtherLikeMIBdot3InPauseFramesINTERFACEINID))#$ACTEtherLikeMIBdot3InPauseFramesINTERFACEOUTID#$((ACTEtherLikeMIBdot3InPauseFramesINTERFACEOUTID-$VOREtherLikeMIBdot3InPauseFramesINTERFACEOUTID))#"
echo "OutPauseFrames #$ACTEtherLikeMIBdot3OutPauseFramesINTERFACEINID#$((ACTEtherLikeMIBdot3OutPauseFramesINTERFACEINID-$VOREtherLikeMIBdot3OutPauseFramesINTERFACEINID))#$ACTEtherLikeMIBdot3OutPauseFramesINTERFACEOUTID#$((ACTEtherLikeMIBdot3OutPauseFramesINTERFACEOUTID-$VOREtherLikeMIBdot3OutPauseFramesINTERFACEOUTID))#"

}


f_decode(){
ZEILE=$@
ZEILE=$( echo $ZEILE | tr -d " " )
if [[ $ZEILE = *ETHERNET* ]] && [[ $ZEILE != *"Ausschlusskriterium"* ]]; then
VORsysUpTimeInstance1=$ACTsysUpTimeInstance1
VORIFMIBifNameINTERFACEINID=$ACTIFMIBifNameINTERFACEINID
VORIFMIBifInMulticastPktsINTERFACEINID=$ACTIFMIBifInMulticastPktsINTERFACEINID
VORIFMIBifInBroadcastPktsINTERFACEINID=$ACTIFMIBifInBroadcastPktsINTERFACEINID
VORIFMIBifOutMulticastPktsINTERFACEINID=$ACTIFMIBifOutMulticastPktsINTERFACEINID
VORIFMIBifOutBroadcastPktsINTERFACEINID=$ACTIFMIBifOutBroadcastPktsINTERFACEINID
VORIFMIBifHCInOctetsINTERFACEINID=$ACTIFMIBifHCInOctetsINTERFACEINID
VORIFMIBifHCInUcastPktsINTERFACEINID=$ACTIFMIBifHCInUcastPktsINTERFACEINID
VORIFMIBifHCInMulticastPktsINTERFACEINID=$ACTIFMIBifHCInMulticastPktsINTERFACEINID
VORIFMIBifHCInBroadcastPktsINTERFACEINID=$ACTIFMIBifHCInBroadcastPktsINTERFACEINID
VORIFMIBifHCOutOctetsINTERFACEINID=$ACTIFMIBifHCOutOctetsINTERFACEINID
VORIFMIBifHCOutUcastPktsINTERFACEINID=$ACTIFMIBifHCOutUcastPktsINTERFACEINID
VORIFMIBifHCOutMulticastPktsINTERFACEINID=$ACTIFMIBifHCOutMulticastPktsINTERFACEINID
VORIFMIBifHCOutBroadcastPktsINTERFACEINID=$ACTIFMIBifHCOutBroadcastPktsINTERFACEINID
VORIFMIBifHighSpeedINTERFACEINID=$ACTIFMIBifHighSpeedINTERFACEINID
VORIFMIBifInDiscardsINTERFACEINID=$ACTIFMIBifInDiscardsINTERFACEINID
VORIFMIBifInErrorsINTERFACEINID=$ACTIFMIBifInErrorsINTERFACEINID
VORIFMIBifInUnknownProtosINTERFACEINID=$ACTIFMIBifInUnknownProtosINTERFACEINID
VORIFMIBifOutDiscardsINTERFACEINID=$ACTIFMIBifOutDiscardsINTERFACEINID
VORIFMIBifOutErrorsINTERFACEINID=$ACTIFMIBifOutErrorsINTERFACEINID
VORIFMIBifNameINTERFACEOUTID=$ACTIFMIBifNameINTERFACEOUTID
VORIFMIBifInMulticastPktsINTERFACEOUTID=$ACTIFMIBifInMulticastPktsINTERFACEOUTID
VORIFMIBifInBroadcastPktsINTERFACEOUTID=$ACTIFMIBifInBroadcastPktsINTERFACEOUTID
VORIFMIBifOutMulticastPktsINTERFACEOUTID=$ACTIFMIBifOutMulticastPktsINTERFACEOUTID
VORIFMIBifOutBroadcastPktsINTERFACEOUTID=$ACTIFMIBifOutBroadcastPktsINTERFACEOUTID
VORIFMIBifHCInOctetsINTERFACEOUTID=$ACTIFMIBifHCInOctetsINTERFACEOUTID
VORIFMIBifHCInUcastPktsINTERFACEOUTID=$ACTIFMIBifHCInUcastPktsINTERFACEOUTID
VORIFMIBifHCInMulticastPktsINTERFACEOUTID=$ACTIFMIBifHCInMulticastPktsINTERFACEOUTID
VORIFMIBifHCInBroadcastPktsINTERFACEOUTID=$ACTIFMIBifHCInBroadcastPktsINTERFACEOUTID
VORIFMIBifHCOutOctetsINTERFACEOUTID=$ACTIFMIBifHCOutOctetsINTERFACEOUTID
VORIFMIBifHCOutUcastPktsINTERFACEOUTID=$ACTIFMIBifHCOutUcastPktsINTERFACEOUTID
VORIFMIBifHCOutMulticastPktsINTERFACEOUTID=$ACTIFMIBifHCOutMulticastPktsINTERFACEOUTID
VORIFMIBifHCOutBroadcastPktsINTERFACEOUTID=$ACTIFMIBifHCOutBroadcastPktsINTERFACEOUTID
VORIFMIBifHighSpeedINTERFACEOUTID=$ACTIFMIBifHighSpeedINTERFACEOUTID
VORIFMIBifInDiscardsINTERFACEOUTID=$ACTIFMIBifInDiscardsINTERFACEOUTID
VORIFMIBifInErrorsINTERFACEOUTID=$ACTIFMIBifInErrorsINTERFACEOUTID
VORIFMIBifInUnknownProtosINTERFACEOUTID=$ACTIFMIBifInUnknownProtosINTERFACEOUTID
VORIFMIBifOutDiscardsINTERFACEOUTID=$ACTIFMIBifOutDiscardsINTERFACEOUTID
VORIFMIBifOutErrorsINTERFACEOUTID=$ACTIFMIBifOutErrorsINTERFACEOUTID
VORETHERNT=$ACTETHERNT
VORsysUpTimeInstance2=$ACTsysUpTimeInstance2
VOREtherLikeMIBdot3StatsAlignmentErrorsINTERFACEINID=$ACTEtherLikeMIBdot3StatsAlignmentErrorsINTERFACEINID
VOREtherLikeMIBdot3StatsFCSErrorsINTERFACEINID=$ACTEtherLikeMIBdot3StatsFCSErrorsINTERFACEINID
VOREtherLikeMIBdot3StatsSingleCollisionFramesINTERFACEINID=$ACTEtherLikeMIBdot3StatsSingleCollisionFramesINTERFACEINID
VOREtherLikeMIBdot3StatsMultipleCollisionFramesINTERFACEINID=$ACTEtherLikeMIBdot3StatsMultipleCollisionFramesINTERFACEINID
VOREtherLikeMIBdot3StatsSQETestErrorsINTERFACEINID=$ACTEtherLikeMIBdot3StatsSQETestErrorsINTERFACEINID
VOREtherLikeMIBdot3StatsDeferredTransmissionsINTERFACEINID=$ACTEtherLikeMIBdot3StatsDeferredTransmissionsINTERFACEINID
VOREtherLikeMIBdot3StatsLateCollisionsINTERFACEINID=$ACTEtherLikeMIBdot3StatsLateCollisionsINTERFACEINID
VOREtherLikeMIBdot3StatsExcessiveCollisionsINTERFACEINID=$ACTEtherLikeMIBdot3StatsExcessiveCollisionsINTERFACEINID
VOREtherLikeMIBdot3StatsInternalMacTransmitErrorsINTERFACEINID=$ACTEtherLikeMIBdot3StatsInternalMacTransmitErrorsINTERFACEINID
VOREtherLikeMIBdot3StatsCarrierSenseErrorsINTERFACEINID=$ACTEtherLikeMIBdot3StatsCarrierSenseErrorsINTERFACEINID
VOREtherLikeMIBdot3StatsFrameTooLongsINTERFACEINID=$ACTEtherLikeMIBdot3StatsFrameTooLongsINTERFACEINID
VOREtherLikeMIBdot3StatsInternalMacReceiveErrorsINTERFACEINID=$ACTEtherLikeMIBdot3StatsInternalMacReceiveErrorsINTERFACEINID
VOREtherLikeMIBdot3StatsSymbolErrorsINTERFACEINID=$ACTEtherLikeMIBdot3StatsSymbolErrorsINTERFACEINID
VOREtherLikeMIBdot3InPauseFramesINTERFACEINID=$ACTEtherLikeMIBdot3InPauseFramesINTERFACEINID
VOREtherLikeMIBdot3OutPauseFramesINTERFACEINID=$ACTEtherLikeMIBdot3OutPauseFramesINTERFACEINID
VOREtherLikeMIBdot3StatsAlignmentErrorsINTERFACEOUTID=$ACTEtherLikeMIBdot3StatsAlignmentErrorsINTERFACEOUTID
VOREtherLikeMIBdot3StatsFCSErrorsINTERFACEOUTID=$ACTEtherLikeMIBdot3StatsFCSErrorsINTERFACEOUTID
VOREtherLikeMIBdot3StatsSingleCollisionFramesINTERFACEOUTID=$ACTEtherLikeMIBdot3StatsSingleCollisionFramesINTERFACEOUTID
VOREtherLikeMIBdot3StatsMultipleCollisionFramesINTERFACEOUTID=$ACTEtherLikeMIBdot3StatsMultipleCollisionFramesINTERFACEOUTID
VOREtherLikeMIBdot3StatsSQETestErrorsINTERFACEOUTID=$ACTEtherLikeMIBdot3StatsSQETestErrorsINTERFACEOUTID
VOREtherLikeMIBdot3StatsDeferredTransmissionsINTERFACEOUTID=$ACTEtherLikeMIBdot3StatsDeferredTransmissionsINTERFACEOUTID
VOREtherLikeMIBdot3StatsLateCollisionsINTERFACEOUTID=$ACTEtherLikeMIBdot3StatsLateCollisionsINTERFACEOUTID
VOREtherLikeMIBdot3StatsExcessiveCollisionsINTERFACEOUTID=$ACTEtherLikeMIBdot3StatsExcessiveCollisionsINTERFACEOUTID
VOREtherLikeMIBdot3StatsInternalMacTransmitErrorsINTERFACEOUTID=$ACTEtherLikeMIBdot3StatsInternalMacTransmitErrorsINTERFACEOUTID
VOREtherLikeMIBdot3StatsCarrierSenseErrorsINTERFACEOUTID=$ACTEtherLikeMIBdot3StatsCarrierSenseErrorsINTERFACEOUTID
VOREtherLikeMIBdot3StatsFrameTooLongsINTERFACEOUTID=$ACTEtherLikeMIBdot3StatsFrameTooLongsINTERFACEOUTID
VOREtherLikeMIBdot3StatsInternalMacReceiveErrorsINTERFACEOUTID=$ACTEtherLikeMIBdot3StatsInternalMacReceiveErrorsINTERFACEOUTID
VOREtherLikeMIBdot3StatsSymbolErrorsINTERFACEOUTID=$ACTEtherLikeMIBdot3StatsSymbolErrorsINTERFACEOUTID
VOREtherLikeMIBdot3InPauseFramesINTERFACEOUTID=$ACTEtherLikeMIBdot3InPauseFramesINTERFACEOUTID
VOREtherLikeMIBdot3OutPauseFramesINTERFACEOUTID=$ACTEtherLikeMIBdot3OutPauseFramesINTERFACEOUTID
IFS="~"
mapfile -t output_array < <( echo $1 | tr ";" "\n" )

DEVICE=${output_array[0]}
DATUM=${output_array[1]}
Uhrzeit=${output_array[2]}
ACTsysUpTimeInstance1=${output_array[3]}
ACTIFMIBifNameINTERFACEINID=${output_array[4]}
ACTIFMIBifInMulticastPktsINTERFACEINID=${output_array[5]}
ACTIFMIBifInBroadcastPktsINTERFACEINID=${output_array[6]}
ACTIFMIBifOutMulticastPktsINTERFACEINID=${output_array[7]}
ACTIFMIBifOutBroadcastPktsINTERFACEINID=${output_array[8]}
ACTIFMIBifHCInOctetsINTERFACEINID=${output_array[9]}
ACTIFMIBifHCInUcastPktsINTERFACEINID=${output_array[10]}
ACTIFMIBifHCInMulticastPktsINTERFACEINID=${output_array[11]}
ACTIFMIBifHCInBroadcastPktsINTERFACEINID=${output_array[12]}
ACTIFMIBifHCOutOctetsINTERFACEINID=${output_array[13]}
ACTIFMIBifHCOutUcastPktsINTERFACEINID=${output_array[14]}
ACTIFMIBifHCOutMulticastPktsINTERFACEINID=${output_array[15]}
ACTIFMIBifHCOutBroadcastPktsINTERFACEINID=${output_array[16]}
ACTIFMIBifHighSpeedINTERFACEINID=${output_array[17]}
ACTIFMIBifInDiscardsINTERFACEINID=${output_array[18]}
ACTIFMIBifInErrorsINTERFACEINID=${output_array[19]}
ACTIFMIBifInUnknownProtosINTERFACEINID=${output_array[20]}
ACTIFMIBifOutDiscardsINTERFACEINID=${output_array[21]}
ACTIFMIBifOutErrorsINTERFACEINID=${output_array[22]}
ACTIFMIBifNameINTERFACEOUTID=${output_array[23]}
ACTIFMIBifInMulticastPktsINTERFACEOUTID=${output_array[24]}
ACTIFMIBifInBroadcastPktsINTERFACEOUTID=${output_array[25]}
ACTIFMIBifOutMulticastPktsINTERFACEOUTID=${output_array[26]}
ACTIFMIBifOutBroadcastPktsINTERFACEOUTID=${output_array[27]}
ACTIFMIBifHCInOctetsINTERFACEOUTID=${output_array[28]}
ACTIFMIBifHCInUcastPktsINTERFACEOUTID=${output_array[29]}
ACTIFMIBifHCInMulticastPktsINTERFACEOUTID=${output_array[30]}
ACTIFMIBifHCInBroadcastPktsINTERFACEOUTID=${output_array[31]}
ACTIFMIBifHCOutOctetsINTERFACEOUTID=${output_array[32]}
ACTIFMIBifHCOutUcastPktsINTERFACEOUTID=${output_array[33]}
ACTIFMIBifHCOutMulticastPktsINTERFACEOUTID=${output_array[34]}
ACTIFMIBifHCOutBroadcastPktsINTERFACEOUTID=${output_array[35]}
ACTIFMIBifHighSpeedINTERFACEOUTID=${output_array[36]}
ACTIFMIBifInDiscardsINTERFACEOUTID=${output_array[37]}
ACTIFMIBifInErrorsINTERFACEOUTID=${output_array[38]}
ACTIFMIBifInUnknownProtosINTERFACEOUTID=${output_array[39]}
ACTIFMIBifOutDiscardsINTERFACEOUTID=${output_array[40]}
ACTIFMIBifOutErrorsINTERFACEOUTID=${output_array[41]}
ACTETHERNT=${output_array[42]}
ACTsysUpTimeInstance2=${output_array[43]}
ACTEtherLikeMIBdot3StatsAlignmentErrorsINTERFACEINID=${output_array[44]}
ACTEtherLikeMIBdot3StatsFCSErrorsINTERFACEINID=${output_array[45]}
ACTEtherLikeMIBdot3StatsSingleCollisionFramesINTERFACEINID=${output_array[46]}
ACTEtherLikeMIBdot3StatsMultipleCollisionFramesINTERFACEINID=${output_array[47]}
ACTEtherLikeMIBdot3StatsSQETestErrorsINTERFACEINID=${output_array[48]}
ACTEtherLikeMIBdot3StatsDeferredTransmissionsINTERFACEINID=${output_array[49]}
ACTEtherLikeMIBdot3StatsLateCollisionsINTERFACEINID=${output_array[50]}
ACTEtherLikeMIBdot3StatsExcessiveCollisionsINTERFACEINID=${output_array[51]}
ACTEtherLikeMIBdot3StatsInternalMacTransmitErrorsINTERFACEINID=${output_array[52]}
ACTEtherLikeMIBdot3StatsCarrierSenseErrorsINTERFACEINID=${output_array[53]}
ACTEtherLikeMIBdot3StatsFrameTooLongsINTERFACEINID=${output_array[54]}
ACTEtherLikeMIBdot3StatsInternalMacReceiveErrorsINTERFACEINID=${output_array[55]}
ACTEtherLikeMIBdot3StatsSymbolErrorsINTERFACEINID=${output_array[56]}
ACTEtherLikeMIBdot3InPauseFramesINTERFACEINID=${output_array[57]}
ACTEtherLikeMIBdot3OutPauseFramesINTERFACEINID=${output_array[58]}
ACTEtherLikeMIBdot3StatsAlignmentErrorsINTERFACEOUTID=${output_array[59]}
ACTEtherLikeMIBdot3StatsFCSErrorsINTERFACEOUTID=${output_array[60]}
ACTEtherLikeMIBdot3StatsSingleCollisionFramesINTERFACEOUTID=${output_array[61]}
ACTEtherLikeMIBdot3StatsMultipleCollisionFramesINTERFACEOUTID=${output_array[62]}
ACTEtherLikeMIBdot3StatsSQETestErrorsINTERFACEOUTID=${output_array[63]}
ACTEtherLikeMIBdot3StatsDeferredTransmissionsINTERFACEOUTID=${output_array[64]}
ACTEtherLikeMIBdot3StatsLateCollisionsINTERFACEOUTID=${output_array[65]}
ACTEtherLikeMIBdot3StatsExcessiveCollisionsINTERFACEOUTID=${output_array[66]}
ACTEtherLikeMIBdot3StatsInternalMacTransmitErrorsINTERFACEOUTID=${output_array[67]}
ACTEtherLikeMIBdot3StatsCarrierSenseErrorsINTERFACEOUTID=${output_array[68]}
ACTEtherLikeMIBdot3StatsFrameTooLongsINTERFACEOUTID=${output_array[69]}
ACTEtherLikeMIBdot3StatsInternalMacReceiveErrorsINTERFACEOUTID=${output_array[70]}
ACTEtherLikeMIBdot3StatsSymbolErrorsINTERFACEOUTID=${output_array[71]}
ACTEtherLikeMIBdot3InPauseFramesINTERFACEOUTID=${output_array[72]}
ACTEtherLikeMIBdot3OutPauseFramesINTERFACEOUTID=${output_array[73]}
out="$(cmds)"
clear
echo "$out" | column -c50 -t -s"#" -o"|"
fi
}

# Start
ACTsysUpTimeInstance1=1
VORsysUpTimeInstance1=0
ACTIFMIBifNameINTERFACEINID="0"
ACTIFMIBifInMulticastPktsINTERFACEINID="0"
ACTIFMIBifInBroadcastPktsINTERFACEINID="0"
ACTIFMIBifOutMulticastPktsINTERFACEINID="0"
ACTIFMIBifOutBroadcastPktsINTERFACEINID="0"
ACTIFMIBifHCInOctetsINTERFACEINID="0"
ACTIFMIBifHCInUcastPktsINTERFACEINID="0"
ACTIFMIBifHCInMulticastPktsINTERFACEINID="0"
ACTIFMIBifHCInBroadcastPktsINTERFACEINID="0"
ACTIFMIBifHCOutOctetsINTERFACEINID="0"
ACTIFMIBifHCOutUcastPktsINTERFACEINID="0"
ACTIFMIBifHCOutMulticastPktsINTERFACEINID="0"
ACTIFMIBifHCOutBroadcastPktsINTERFACEINID="0"
ACTIFMIBifHighSpeedINTERFACEINID="0"
ACTIFMIBifInDiscardsINTERFACEINID="0"
ACTIFMIBifInErrorsINTERFACEINID="0"
ACTIFMIBifInUnknownProtosINTERFACEINID="0"
ACTIFMIBifOutDiscardsINTERFACEINID="0"
ACTIFMIBifOutErrorsINTERFACEINID="0"
ACTIFMIBifNameINTERFACEOUTID="0"
ACTIFMIBifInMulticastPktsINTERFACEOUTID="0"
ACTIFMIBifInBroadcastPktsINTERFACEOUTID="0"
ACTIFMIBifOutMulticastPktsINTERFACEOUTID="0"
ACTIFMIBifOutBroadcastPktsINTERFACEOUTID="0"
ACTIFMIBifHCInOctetsINTERFACEOUTID="0"
ACTIFMIBifHCInUcastPktsINTERFACEOUTID="0"
ACTIFMIBifHCInMulticastPktsINTERFACEOUTID="0"
ACTIFMIBifHCInBroadcastPktsINTERFACEOUTID="0"
ACTIFMIBifHCOutOctetsINTERFACEOUTID="0"
ACTIFMIBifHCOutUcastPktsINTERFACEOUTID="0"
ACTIFMIBifHCOutMulticastPktsINTERFACEOUTID="0"
ACTIFMIBifHCOutBroadcastPktsINTERFACEOUTID="0"
ACTIFMIBifHighSpeedINTERFACEOUTID="0"
ACTIFMIBifInDiscardsINTERFACEOUTID="0"
ACTIFMIBifInErrorsINTERFACEOUTID="0"
ACTIFMIBifInUnknownProtosINTERFACEOUTID="0"
ACTIFMIBifOutDiscardsINTERFACEOUTID="0"
ACTIFMIBifOutErrorsINTERFACEOUTID="0"
ETHERNT="0"
ACTsysUpTimeInstance2=1
VORsysUpTimeInstance2=0
ACTEtherLikeMIBdot3StatsAlignmentErrorsINTERFACEINID="0"
ACTEtherLikeMIBdot3StatsFCSErrorsINTERFACEINID="0"
ACTEtherLikeMIBdot3StatsSingleCollisionFramesINTERFACEINID="0"
ACTEtherLikeMIBdot3StatsMultipleCollisionFramesINTERFACEINID="0"
ACTEtherLikeMIBdot3StatsSQETestErrorsINTERFACEINID="0"
ACTEtherLikeMIBdot3StatsDeferredTransmissionsINTERFACEINID="0"
ACTEtherLikeMIBdot3StatsLateCollisionsINTERFACEINID="0"
ACTEtherLikeMIBdot3StatsExcessiveCollisionsINTERFACEINID="0"
ACTEtherLikeMIBdot3StatsInternalMacTransmitErrorsINTERFACEINID="0"
ACTEtherLikeMIBdot3StatsCarrierSenseErrorsINTERFACEINID="0"
ACTEtherLikeMIBdot3StatsFrameTooLongsINTERFACEINID="0"
ACTEtherLikeMIBdot3StatsInternalMacReceiveErrorsINTERFACEINID="0"
ACTEtherLikeMIBdot3StatsSymbolErrorsINTERFACEINID="0"
ACTEtherLikeMIBdot3InPauseFramesINTERFACEINID="0"
ACTEtherLikeMIBdot3OutPauseFramesINTERFACEINID="0"
ACTEtherLikeMIBdot3StatsAlignmentErrorsINTERFACEOUTID="0"
ACTEtherLikeMIBdot3StatsFCSErrorsINTERFACEOUTID="0"
ACTEtherLikeMIBdot3StatsSingleCollisionFramesINTERFACEOUTID="0"
ACTEtherLikeMIBdot3StatsMultipleCollisionFramesINTERFACEOUTID="0"
ACTEtherLikeMIBdot3StatsSQETestErrorsINTERFACEOUTID="0"
ACTEtherLikeMIBdot3StatsDeferredTransmissionsINTERFACEOUTID="0"
ACTEtherLikeMIBdot3StatsLateCollisionsINTERFACEOUTID="0"
ACTEtherLikeMIBdot3StatsExcessiveCollisionsINTERFACEOUTID="0"
ACTEtherLikeMIBdot3StatsInternalMacTransmitErrorsINTERFACEOUTID="0"
ACTEtherLikeMIBdot3StatsCarrierSenseErrorsINTERFACEOUTID="0"
ACTEtherLikeMIBdot3StatsFrameTooLongsINTERFACEOUTID="0"
ACTEtherLikeMIBdot3StatsInternalMacReceiveErrorsINTERFACEOUTID="0"
ACTEtherLikeMIBdot3StatsSymbolErrorsINTERFACEOUTID="0"
ACTEtherLikeMIBdot3InPauseFramesINTERFACEOUTID="0"
ACTEtherLikeMIBdot3OutPauseFramesINTERFACEOUTID="0"


if [ -p /dev/stdin ]; then
    #Data piped to this script!
    while IFS= read line; do
        #echo "Line: ${line}"
        f_decode ${line}
    done
else
    #No input was found on stdin, skipping!"
    #filename was specified and that it exists?
    if [ -f "$1" ]; then
        echo "Filename specified: ${1}"
        while read line; do
            echo ${line}
            f_decode ${line}
        done < ${1} 
    else
        echo "No input given!"
    fi
fi
