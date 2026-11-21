#!/usr/bin/env bash
# Setup the basics
ENDPOINT_IP=$(wg show wg0 endpoints | awk '{print $2}' | cut -d':' -f1)
DEFAULT_ROUTE=$(ip route | grep 'default via')
GW="$(echo $DEFAULT_ROUTE | cut -d ' ' -f3)"
DEV="$(echo $DEFAULT_ROUTE | cut -d ' ' -f5)"

# Check if there are other routes to be removed
if [[ $(ip route | grep $ENDPOINT_IP) ]]; then
    echo "route exists, removing..."
    ip route delete $(ip route | grep $ENDPOINT_IP)
fi

# Setup a new route
echo "Adding a new route for active connection...
executing -> ip route add $ENDPOINT_IP via $GW dev $DEV"
ip route add $ENDPOINT_IP via $GW dev $DEV
