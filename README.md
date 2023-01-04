# TelephonyPatch
Set of bash scripts to manually resolve VoIP secondary proxy server address to support mmpbxd when not using dnsmasq

Simply move these scripts to `~`, set a cronjob to run `fix_telephony.sh` periodically (I run it every 6 hours) and also add it to `/etc/rc.local` to run on boot   
Enjoy!
