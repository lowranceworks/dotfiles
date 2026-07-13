#!/bin/bash

CACHE=/tmp/sketchybar_network_quality.json
LOCK=/tmp/sketchybar_network_quality.lock
MAX_AGE=300 # re-test every 5 minutes

WIFI_ICON=󰖩
WIRED_ICON=󰈀
OFFLINE_ICON=󰤭

# Determine the active physical uplink independent of any VPN on top.
# The network service order is priority-sorted (Ethernet above Wi-Fi by
# default); the first service whose device has an active link and an IP is the
# real uplink. Wi-Fi port -> wireless, anything else -> wired.
detect_connection() {
  local line port dev
  while IFS= read -r line; do
    port=$(echo "$line" | sed -E 's/.*Hardware Port: (.*), Device:.*/\1/')
    dev=$(echo "$line" | sed -E 's/.*Device: (en[0-9]+).*/\1/')
    [ -z "$dev" ] && continue
    if ifconfig "$dev" 2>/dev/null | grep -q "status: active" &&
      ifconfig "$dev" 2>/dev/null | grep -q "inet "; then
      if [ "$port" = "Wi-Fi" ]; then
        echo "wifi"
      else
        echo "wired"
      fi
      return
    fi
  done < <(networksetup -listnetworkserviceorder 2>/dev/null | grep -E "Device: en[0-9]+")
  echo "offline"
}

run_test() {
  if [ -f "$LOCK" ]; then
    return
  fi

  touch "$LOCK"
  networkQuality -c -s 2>/dev/null > "${CACHE}.tmp" && mv "${CACHE}.tmp" "$CACHE"
  rm -f "$LOCK"
}

CONNECTION=$(detect_connection)

if [ "$CONNECTION" = "wired" ]; then
  ICON=$WIRED_ICON
else
  ICON=$WIFI_ICON
fi

# No physical uplink: show offline and don't bother testing.
if [ "$CONNECTION" = "offline" ]; then
  sketchybar --set "$NAME" icon="$OFFLINE_ICON" label="Offline" \
    label.color=0xfff38ba8 icon.color=0xfff38ba8
  exit 0
fi

# Check if we need a fresh test
NEED_TEST=false
if [ ! -f "$CACHE" ]; then
  NEED_TEST=true
else
  AGE=$(( $(date +%s) - $(stat -f%m "$CACHE") ))
  if [ "$AGE" -ge "$MAX_AGE" ]; then
    NEED_TEST=true
  fi
fi

if [ "$NEED_TEST" = true ]; then
  run_test &
fi

# Display cached results if available
if [ -f "$CACHE" ]; then
  DL=$(/usr/bin/plutil -extract dl_throughput raw -o - "$CACHE" 2>/dev/null)
  UL=$(/usr/bin/plutil -extract ul_throughput raw -o - "$CACHE" 2>/dev/null)

  if [ -n "$DL" ] && [ -n "$UL" ]; then
    DL_MBPS=$(echo "scale=0; $DL / 1000000" | bc)
    UL_MBPS=$(echo "scale=0; $UL / 1000000" | bc)

    if [ "$DL_MBPS" -ge 100 ]; then
      COLOR=0xffa6e3a1 # green
    elif [ "$DL_MBPS" -ge 25 ]; then
      COLOR=0xfff9e2af # yellow
    else
      COLOR=0xfff38ba8 # red
    fi

    sketchybar --set "$NAME" icon="$ICON" label="↓${DL_MBPS} ↑${UL_MBPS} Mbps" \
      label.color="$COLOR" icon.color="$COLOR"
  else
    sketchybar --set "$NAME" icon="$ICON" label="Testing…"
  fi
else
  sketchybar --set "$NAME" icon="$ICON" label="Testing…"
fi
