#!/bin/bash
#
# rotate_desktop.sh
#
# Rotates modern Linux desktop screen and input devices to match. Handy for
# convertible notebooks. Call this script from panel launchers, keyboard
# shortcuts, or touch gesture bindings (xSwipe, touchegg, etc.).
#
# Using transformation matrix bits taken from:
#   https://wiki.ubuntu.com/X/InputCoordinateTransformation
#

# Configure these to match your hardware (names taken from `xinput` output).
# TouchPad='SYNA8006:00 06CB:CD8B Touchpad'
TouchScreen='Wacom Pen and multitouch sensor Finger touch'
PenStylus='Wacom Pen and multitouch sensor Pen stylus'
PenEraser='Wacom Pen and multitouch sensor Pen eraser'

OrientationFile='/tmp/tab_orientation'
TabletModeFile='/sys/bus/platform/devices/thinkpad_acpi/hotkey_tablet_mode'

Transform='Coordinate Transformation Matrix'

function do_rotate
{
  case "$2" in
    "normal")
      xrandr --output "$1" --rotate normal
      sleep 1
      [ ! -z "$TouchPad" ]    && xinput set-prop "$TouchPad"    "$Transform" 1 0 0 0 1 0 0 0 1
      [ ! -z "$TouchScreen" ] && xinput set-prop "$TouchScreen" "$Transform" 1 0 0 0 1 0 0 0 1
      [ ! -z "$PenStylus" ]   && xinput set-prop "$PenStylus"   "$Transform" 1 0 0 0 1 0 0 0 1
      [ ! -z "$PenEraser" ]   && xinput set-prop "$PenEraser"   "$Transform" 1 0 0 0 1 0 0 0 1
      ;;
    "bottom-up")
      xrandr --output "$1" --rotate inverted
      sleep 1
      [ ! -z "$TouchPad" ]    && xinput set-prop "$TouchPad"    "$Transform" -1 0 1 0 -1 1 0 0 1
      [ ! -z "$TouchScreen" ] && xinput set-prop "$TouchScreen" "$Transform" 1 0 0 0 1 0 0 0 1
      [ ! -z "$PenStylus" ]   && xinput set-prop "$PenStylus"   "$Transform" 1 0 0 0 1 0 0 0 1
      [ ! -z "$PenEraser" ]   && xinput set-prop "$PenEraser"   "$Transform" 1 0 0 0 1 0 0 0 1
      ;;
    "left-up")
      xrandr --output "$1" --rotate left
      sleep 1
      [ ! -z "$TouchPad" ]    && xinput set-prop "$TouchPad"    "$Transform" 0 -1 1 1 0 0 0 0 1
      [ ! -z "$TouchScreen" ] && xinput set-prop "$TouchScreen" "$Transform" -1 0 1 0 -1 1 0 0 1
      [ ! -z "$PenStylus" ]   && xinput set-prop "$PenStylus"   "$Transform" -1 0 1 0 -1 1 0 0 1
      [ ! -z "$PenEraser" ]   && xinput set-prop "$PenEraser"   "$Transform" -1 0 1 0 -1 1 0 0 1
      ;;
    "right-up")
      xrandr --output "$1" --rotate right
      sleep 1
      [ ! -z "$TouchPad" ]    && xinput set-prop "$TouchPad"    "$Transform" 0 1 0 -1 0 1 0 0 1
      [ ! -z "$TouchScreen" ] && xinput set-prop "$TouchScreen" "$Transform" -1 0 1 0 -1 1 0 0 1
      [ ! -z "$PenStylus" ]   && xinput set-prop "$PenStylus"   "$Transform" -1 0 1 0 -1 1 0 0 1
      [ ! -z "$PenEraser" ]   && xinput set-prop "$PenEraser"   "$Transform" -1 0 1 0 -1 1 0 0 1
      ;;
  esac
}

XDisplay='eDP-1'
XRot=$(xrandr --verbose | awk '/^eDP-1/ {print $6}')

TabMode=$(<"$TabletModeFile")
case $XRot in
  normal)
    Orientation='normal'
    ;;
  inverted)
    Orientation='bottom-up'
    ;;
  left)
    Orientation='left-up'
    ;;
  right)
    Orientation='right-up'
    ;;
esac
echo "$Orientation" > "$OrientationFile"
LastState="$TabMode $Orientation"

monitor-sensor --accel | gawk '/changed/ {print $4 > "/tmp/tab_orientation"; close("/tmp/tab_orientation")}' &
SensorProc="$!"
trap "kill $SensorProc; exit" SIGHUP SIGINT SIGQUIT SIGABRT EXIT

while :; do
  sleep 1
  TabMode=$(<"$TabletModeFile")
  if [ "$TabMode" == "0" ]; then
    Orientation="normal"
  else
    Orientation=$(<"$OrientationFile")
  fi

  if [ "$TabMode $Orientation" != "$LastState" ]; then
    do_rotate "$XDisplay" "$Orientation"
  fi

  LastState="$TabMode $Orientation"
done
