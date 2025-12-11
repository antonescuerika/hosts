#!/bin/bash

DNS_SERVER="8.8.8.8"

check_entry() {
    local name="$1"
    local ip="$2"
    local dns="$3"

    ns_ip=$(nslookup "$name" "$dns" 2>/dev/null \
        | awk '/^Name:/ {flag=1} flag && /^Address: / {print $2; exit}')

    [[ -z "$ns_ip" ]] && return 0  

    if [[ "$ns_ip" != "$ip" ]]; then
        echo "Bogus IP for $name in /etc/hosts!"
    fi
}
cat /etc/hosts | while read ip name rest; do
    [[ -z "$ip" || "${ip:0:1}" == "#" ]] && continue
    if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ && -n "$name" ]]; then
        check_entry "$name" "$ip" "$DNS_SERVER"
    fi
done
