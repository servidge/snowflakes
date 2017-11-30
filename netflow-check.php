<?php
# Der größte Teil des Quellcode ist von "Jimmy" http://blog.cactiusers.org/2014/06/06/decoding-netflow-v5-packets-with-php/
# Keine Lizenzangabe. Aber auf "... Now, for anyone wanting to write their own Netflow parser in PHP, I have included some basic code below to get you started. ..." lässt sich wohl aufbauen.
# Nur kleinere Anpassungen zum schnellen Check ob Netflow v5 Pakete am Collector ankommen. 
# Nur CLI Ausgabe. Keine weitere Verarbeitung. 
# äöüß?# ;)
#
# Most of the source code is from "Jimmy" http://blog.cactiusers.org/2014/06/06/decoding-netflow-v5-packets-with-php/
# No license information. But the "... Now, for anyone wanting to write their own Netflow parser in PHP, I have included some basic code below to get you started. ..." seems to be a good foundation.
# Just small adjustments to quickly check whether Netflow v5 packets arrive at the Collector. 
# Only CLI output. No further processing.
#
# <Start Original from http://blog.cactiusers.org/2014/06/06/decoding-netflow-v5-packets-with-php/>
#<?php
# We first setup our listening UDP Socket.  We use the default port of 2055, but that can be changed to anything
$harvester = "udp://0.0.0.0:2055"
$socket = stream_socket_server($harvester, $errno, $errstr, STREAM_SERVER_BIND);
if (!$socket) {
    die("$errstr ($errno)");

}
#Print Warning
echo "Attention, other running sockets may be terminated through this Start. ".$harvester.PHP_EOL;
echo "".PHP_EOL;

#Print Header
echo "|   |                |      |                |      |    |          |          |".PHP_EOL;
echo "|Pro|        Quell-IP|Q-Port|         Ziel-IP|Z-Port|Seku|    Pakete|     Bytes|".PHP_EOL;
echo "|Pro|       Source-IP|S-Port|  Destination-IP|D-Port| Sec|    Pacets|     Bytes|".PHP_EOL;

do {
 # We now wait for a packet.  Standard MTU is 1500.  
 # I will need to check on if this needs to be moved to 9000+ for VMWare instances using Jumbo Packets.
 $p = stream_socket_recvfrom($socket, 1500, 0, $peer);
 
 # Packet Received, so we must first check if it is version 5
 # This is were you would check to see if it is v9 or v10 also to decode those types of packets
 $version = unpack("n", substr($p, 0, 2));
 if ($version[1] == 5) {
 fv5($p, $peer);
 }
 else 
 { 
 echo 'Wrong Flowversion. Just v5 Flows are processed. Recognized Packet format: '.$version[1].PHP_EOL;
 }
} while ($p !== false);
 
function fv5 ($p, $peer) {
 # Packet Reference: http://www.cisco.com/c/en/us/td/docs/net_mgmt/netflow_collection_engine/3-6/user/guide/format.html#wp1006108
 # The headers / flowrecs in v5 packets are fixed lengths, so we set them here
 $v5_header_len = 24;
 $v5_flowrec_len = 48;
 
 # We now need to take a look at the Netflow header.  This will give us a nice array of named values, I don't make use of most of them in this example
 $header = unpack('nversion/ncount/Nsysuptime/Nunix_secs/Nunix_nsecs/Nflow_sequence/Cengine_type/Cengine_id/nsampling_interval', substr($p, 0, 24));
 
 # For now, we will just care about the count, as that will tell us how many flows are contained in this packet
 $count = $header['count'];
 
 # We will loop through each Netflow record here
 for ($i = 0; $i < $count; $i++) {
 # We need to pull the flow record out.  Since every flow is 48 bytes, and the header is 24 bytes,
 # its pretty simple to determine the location of each flow record.
 $flowrec = substr($p, $v5_header_len + ($i * $v5_flowrec_len), $v5_flowrec_len);
 
 # We now will unpack the flow record into an array that is more usable
 # For a rundown on what each field is, check the reference URL above.  They are named exactly the same
 $flowdata = unpack('C4srcaddr/C4dstaddr/C4nexthop/ninput/noutput/NdPkts/NdOctets/NFirst/NLast/nsrcport/ndstport/Cblank/Ctcp_flags/Cprot/nsrc_as/ndst_as/Csrc_mask/Cdst_mask', $flowrec);
 
 #
 # You now have the entire netflow record in a tidy named array.  From here you can manipulate it however you like.  
 # I personally just insert it into a Memory table in a MySQL database for later processing.
 #
 }
 #print_r ($flowdata)

 #Calculate flow time
 $sec = $flowdata['Last'] - $flowdata['First'];
 $sec = $sec / 1000;
 $sec = round ($sec);

 #Print 
 #|  6|   10.19.164.131| 62468|   10.127.255.18|  8080|   6|        12|      2501|
 #echo  "|".str_pad($flowdata['prot'],3," ",STR_PAD_LEFT)."|".
 #str_pad($flowdata['srcaddr1'].'.'.$flowdata['srcaddr2'].'.'.$flowdata['srcaddr3'].'.'.$flowdata['srcaddr4'],16," ",STR_PAD_LEFT)."|".
 #str_pad($flowdata['srcport'],6," ",STR_PAD_LEFT)."|".
 #str_pad($flowdata['dstaddr1'].'.'.$flowdata['dstaddr2'].'.'.$flowdata['dstaddr3'].'.'.$flowdata['dstaddr4'],16," ",STR_PAD_LEFT)."|".
 #str_pad($flowdata['dstport'],6," ",STR_PAD_LEFT)."|".
 #str_pad($sec,4," ",STR_PAD_LEFT)."|".
 #str_pad($flowdata['dPkts'],10," ",STR_PAD_LEFT)."|".
 #str_pad($flowdata['dOctets'],10," ",STR_PAD_LEFT)."|".PHP_EOL;

 #Print 
 #|  6|  10. 19.164.131| 62468|  10.127.255. 18|  8080|   6|        12|      2501|
 echo "|".str_pad($flowdata['prot'],3," ",STR_PAD_LEFT)."|".
 str_pad(str_pad($flowdata['srcaddr1'],3," ",STR_PAD_LEFT).'.'.
 str_pad($flowdata['srcaddr2'],3," ",STR_PAD_LEFT).'.'.
 str_pad($flowdata['srcaddr3'],3," ",STR_PAD_LEFT).'.'.
 str_pad($flowdata['srcaddr4'],3," ",STR_PAD_LEFT),16," ",STR_PAD_LEFT)."|".
 str_pad($flowdata['srcport'],6," ",STR_PAD_LEFT)."|".
 str_pad(str_pad($flowdata['dstaddr1'],3," ",STR_PAD_LEFT).'.'.
 str_pad($flowdata['dstaddr2'],3," ",STR_PAD_LEFT).'.'.
 str_pad($flowdata['dstaddr3'],3," ",STR_PAD_LEFT).'.'.
 str_pad($flowdata['dstaddr4'],3," ",STR_PAD_LEFT),16," ",STR_PAD_LEFT)."|".
 str_pad($flowdata['dstport'],6," ",STR_PAD_LEFT)."|".
 str_pad($sec,4," ",STR_PAD_LEFT)."|".
 str_pad($flowdata['dPkts'],10," ",STR_PAD_LEFT)."|".
 str_pad($flowdata['dOctets'],10," ",STR_PAD_LEFT)."|".PHP_EOL;

}
