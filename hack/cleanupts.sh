#!/usr/bin/env bash

for host in 192.168.2.32 192.168.2.33 192.168.2.34 192.168.2.35; do
	ssh root@$host systemctl stop tailscaled.service
	ssh root@$host ip link delete tailscale0
done
