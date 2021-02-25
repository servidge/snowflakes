#!/bin/bash
# Umsetzung von Sebastian Boenning
# Part of https://github.com/servidge/snowflakes
# 
VERSION="Version 0.0.3 vom 2021-02-19 12:30 Uhr"
echo "#"
echo "# Bitte SNMP Profil Nummer auswaehlen    "
echo "# 11. Manuelle Eingabe der Werte         "
echo "# 12. snmpv3, User: USERNAME-12          "
echo "# 13. snmpv3, User: USERNAME-13          "
echo "# 14. snmpv3, User: USERNAME-14          "
echo "# 15. snmpv3, User: USERNAME-15          "
echo "# 16. snmpv3, User: USERNAME-16          "
echo "# 17. snmpv3, User: USERNAME-17          "
echo "# 18. snmpv3, User: USERNAME-18          "
echo "# 19. snmpv3, User: USERNAME-19          "
echo "# 30. snmpv2, Community: kickstart       "
echo "# 31. snmpv2, Community: start           "
echo "# 32. snmpv2, Community: private         "
echo "# 33. snmpv2, Community: public          "
echo "# Alles andere beenden                  "
echo "#"
read -n2 -r -p "Auswahl:" key

if [ "$key" = "11" ]; then
        echo "#"
        echo "# Vergleichbaren snmpset Parameter Teil wie \"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\" angeben: "
        echo "#                                 oder wie: \"-v 2c -c snmpcommunity                                            \" angeben: "
        echo "# von                                        ^                                                                ^ bis "
        read -r -p "Eingabe: " SNMPCFG_SNMPRW
        echo "SNMPCFG_SNMPPROF=manuell" > ~/.SNMPCFG
        echo "SNMPCFG_SNMP=\"$SNMPCFG_SNMPRW\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRW=\"$SNMPCFG_SNMPRW\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRO=\"$SNMPCFG_SNMPRW\"" >> ~/.SNMPCFG
elif [ "$key" = "12" ]; then
        echo "SNMPCFG_SNMPPROF=USERNAME-12" > ~/.SNMPCFG
        echo "SNMPCFG_SNMP=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRW=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRO=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
elif [ "$key" = "13" ]; then
        echo "SNMPCFG_SNMPPROF=USERNAME-13" > ~/.SNMPCFG
        echo "SNMPCFG_SNMP=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRW=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRO=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
elif [ "$key" = "14" ]; then
        echo "SNMPCFG_SNMPPROF=USERNAME-14" > ~/.SNMPCFG
        echo "SNMPCFG_SNMP=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRW=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRO=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
elif [ "$key" = "15" ]; then
        echo "SNMPCFG_SNMPPROF=USERNAME-15" > ~/.SNMPCFG
        echo "SNMPCFG_SNMP=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRW=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRO=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
elif [ "$key" = "16" ]; then
        echo "SNMPCFG_SNMPPROF=USERNAME-16" > ~/.SNMPCFG
        echo "SNMPCFG_SNMP=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRW=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRO=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
elif [ "$key" = "17" ]; then
        echo "SNMPCFG_SNMPPROF=USERNAME-17" > ~/.SNMPCFG
        echo "SNMPCFG_SNMP=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRW=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRO=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
elif [ "$key" = "18" ]; then
        echo "SNMPCFG_SNMPPROF=USERNAME-18" > ~/.SNMPCFG
        echo "SNMPCFG_SNMP=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRW=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRO=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
elif [ "$key" = "19" ]; then
        echo "SNMPCFG_SNMPPROF=USERNAME-19" > ~/.SNMPCFG
        echo "SNMPCFG_SNMP=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRW=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRO=\"-v 3 -l authPriv -a sha -A AauthPW -x AES -X PrivPW -u RW-USERNAME\"" >> ~/.SNMPCFG
elif [ "$key" = "30" ]; then
        echo "SNMPCFG_SNMPPROF=kickstart" > ~/.SNMPCFG
        echo "SNMPCFG_SNMP=\"-v2c -c kickstart\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRW=\"-v2c -c kickstart\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRO=\"-v2c -c kickstart\"" >> ~/.SNMPCFG
elif [ "$key" = "31" ]; then
        echo "SNMPCFG_SNMPPROF=start" > ~/.SNMPCFG
        echo "SNMPCFG_SNMP=\"-v2c -c start\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRW=\"-v2c -c start\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRO=\"-v2c -c start\"" >> ~/.SNMPCFG
elif [ "$key" = "32" ]; then
        echo "SNMPCFG_SNMPPROF=private" > ~/.SNMPCFG
        echo "SNMPCFG_SNMP=\"-v2c -c private\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRW=\"-v2c -c private\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRO=\"-v2c -c private\"" >> ~/.SNMPCFG
elif [ "$key" = "33" ]; then
        echo "SNMPCFG_SNMPPROF=public" > ~/.SNMPCFG
        echo "SNMPCFG_SNMP=\"-v2c -c public\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRW=\"-v2c -c public\"" >> ~/.SNMPCFG
        echo "SNMPCFG_SNMPRO=\"-v2c -c public\"" >> ~/.SNMPCFG
else
        echo .
        echo "SNMPCFG_LEER=JA" > ~/.SNMPCFG
        echo "# Nichts ausgewaehlt. Beenden"
        exit
fi
echo .
echo "#"
echo "# Version $key gespeichert"
echo "#"
