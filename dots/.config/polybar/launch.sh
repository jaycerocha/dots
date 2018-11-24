#!/usr/bin/env sh
# Environment variables
SCREEN_WIDTH=$(xrandr | grep " connected" | cut -d ' ' -f4 | sed 's/x.*//' | head -n1)

## Bar settings
export MONITOR=$(xrandr | grep " connected" | cut -d ' ' -f1 | head -n1)
export POLYBAR_WIDTH=$(expr $SCREEN_WIDTH - 80 || expr 1366 - 80)
export NETWORK_IFACE=$(ifconfig -s | awk '{ print $1, $3}' | grep -vP '0$|^lo|^Iface' | awk '{ print $1 }')


# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar $1 &
