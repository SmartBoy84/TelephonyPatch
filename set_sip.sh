
# add IPTABLES interface
source /root/TelephonyPatch/iptable_interface.sh

# variables
PROXY=wa.hybrid.connect.telstra.com
CHAIN_NAME=TELEPHONY_PATCH
PORT=5065

set_sip() {
 
 # naptr -> srv -> dns
 # note, mmpbxd can use ipv6/ipv4 so check which one; if ipv4 remove AAAA when getting IP
 # */20 * * * * sleep 7 ; /root/TelephonyPatch/get_sip.sh
 
 KEEPER=$(dig +short $PROXY NAPTR | tail -n1 | awk -F'\" ' '{print $NF}' | sed 's/\.$//')
 
 LIST=$(dig +short $KEEPER SRV | awk -F'\" ' '{print $NF}' | sed 's/\.$//')
 
 IP=""
 echo "$LIST" | while IFS= read -r LINE; do
     IP=$(dig +short $LINE AAAA | awk -F'\" ' '{print $NF}' | sed 's/\.$//')
     if [ "`ping -c1 -W3 -q $IP`" ]; then
         echo "Setting $IP";
         uci set mmpbxrvsipnet.sip_net.primary_proxy=$IP
          
	 echo "Adding rule $CHAIN_NAME $IP $PORT" 
	 uci commit mmpbxrvsipnet
	 add_rule $CHAIN_NAME $IP $PORT 
	 break;
     fi;
 done

}
