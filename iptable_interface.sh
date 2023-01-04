# fw3 -q reload

run_cmd() {
 # RUNNING
  iptables -t nat "$@"
  iptables -t filter "$@"
  ip6tables -t filter "$@"

}

refer_chain() {
 # REFERENCE

  iptables -t nat -C zone_wan_prerouting -j $1 || iptables -t nat -I zone_wan_prerouting -j $1
  iptables -t filter -C zone_wan_input -j $1 || iptables -t filter -I zone_wan_input -j $1
  ip6tables -t filter -C zone_wan_input -j $1 || ip6tables -t filter -I zone_wan_input -j $1

}

create_chain() {
 # CREATION

 run_cmd -N $1
 run_cmd -F $1
 refer_chain $1

}

delete_chain() {
 # DELETION

 run_cmd -D zone_wan_prerouting -j $1
 run_cmd -D zone_wan_input -j $1
 run_cmd -F $1
 run_cmd -X $1

}

add_rule() {
 # SUBSTITUTION

 create_chain $1
 run_cmd -I $1 --src $2 -p tcp --dport $3 -m comment --comment "AdGuard patchy fix" -j ACCEPT
 run_cmd -I $1 --src $2 -p udp --dport $3 -m comment --comment "AdGuard patchy fix" -j ACCEPT

}
