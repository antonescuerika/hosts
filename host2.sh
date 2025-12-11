#!/bin/bash

cat /etc/hosts | while read ip name rest; do
	[[ -z "$ip" || "${ip:0:1}" == "#" ]] && continue
	if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ && -n "$name" ]]; then
		ns_ip=$(nslookup "$name" 8.8.8.8 2>/dev/null | awk '/^Name:/ {flag=1} flag && /^Address: / {print $2; exit}')
		if [[ -n "$ns_ip" && "$ns_ip" != "$ip" ]]; then
			echo "Bogus IP for $name in /etc/hosts!"
		fi
	fi
done
