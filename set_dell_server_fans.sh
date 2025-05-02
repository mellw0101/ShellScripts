#!/bin/bash

ARGV=$@         # Save the arguments passed.

FAN_SPEED=0x8   # The default speed is 8.

OP=0            # Default operation is none.

while [ "$#" -gt 0 ]; do
  if [ "$1" == "--fans" ]; then
    OP=1
    shift
    if [ "$#" -gt 0 ]; then
      FAN_SPEED="$1"
    fi
    echo "Setting fan speed '$FAN_SPEED'"
  fi
  shift
done

if [ "$OP" == 1 ]; then
  # Enable control over fans.
  ipmitool -I lanplus -H 192.168.0.33 -U root -P 225588 raw 0x30 0x30 0x01 0x00
  # Set fans to 8% speed.
  ipmitool -I lanplus -H 192.168.0.33 -U root -P 225588 raw 0x30 0x30 0x02 0xff $FAN_SPEED  
fi
