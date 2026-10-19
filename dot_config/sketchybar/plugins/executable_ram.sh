#!/bin/bash

TOTAL=$(sysctl -n hw.memsize)

# Get page size and memory stats from vm_stat
eval $(vm_stat | awk '
  /page size of/ { printf "PAGE_SIZE=%d\n", $8+0 }
  /Pages active/     { printf "ACTIVE=%d\n", $NF+0 }
  /Pages wired/      { printf "WIRED=%d\n", $NF+0 }
  /Pages occupied by compressor/ { printf "COMPRESSED=%d\n", $NF+0 }
  /Pages speculative/ { printf "SPECULATIVE=%d\n", $NF+0 }
')

TOTAL_PAGES=$((TOTAL / PAGE_SIZE))
USED_PAGES=$((ACTIVE + WIRED + COMPRESSED + SPECULATIVE))
PCT=$((USED_PAGES * 100 / TOTAL_PAGES))

if [ "$PCT" -lt 60 ]; then
  COLOR=0xffa6e3a1 # green
elif [ "$PCT" -lt 85 ]; then
  COLOR=0xfff9e2af # yellow
else
  COLOR=0xfff38ba8 # red
fi

sketchybar --set "$NAME" label="${PCT}%" label.color="$COLOR" icon.color="$COLOR"
