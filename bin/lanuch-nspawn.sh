#!/bin/sh
exec /usr/bin/systemd-nspawn \
    --machine=ubuntu-container \
    --boot \
    --setenv=DISPLAY="$DISPLAY" \
    --bind-ro=/tmp/.X11-unix \
    --bind-ro=/etc/resolv.conf

# token
# XAUTH=/tmp/container_xauth
# touch $XAUTH
# xauth nextract - "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -

# sudo systemd-nspawn -D /var/lib/machines/ubuntu-container --bind-ro=/etc/resolv.conf --bind-ro=/tmp/.X11-unix/X0 --bind="$XAUTH" -E DISPLAY="$DISPLAY" -E XAUT
# HORITY="$XAUTH
