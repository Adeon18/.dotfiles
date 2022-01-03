#!/bin/sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar bar &

if [[ $(xrandr -q | grep 'HDMI1 connected') ]]; then
	polybar bar_HDMI1 &
elif [[ $(xrandr -q | grep 'HDMI2 connected') ]]; then
        polybar bar_HDMI2 &
fi
