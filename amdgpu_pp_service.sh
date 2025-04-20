#!/bin/bash

log() {
  local text="$1"
  logger "amdgpu_pp: $text"
}

check_status() {
  local succ="$1"
  local fail="$2"
  local text="$3"
  if [ $? -eq 0 ]; then
    log "Successfully $succ$text"
  else
    log "Failed to $fail$text"
    exit 1
  fi
}

sleep 1

log "Enabling manual mode."
echo "manual" > /sys/class/drm/card1/device/power_dpm_force_performance_level 
check_status "enabled " "enable " "manual mode."

log "Enabling, and setting the 8-bit pwm value of the fan."
echo "1" > /sys/class/drm/card1/device/hwmon/hwmon2/fan1_enable
check_status "enabled " "enable " "the fan."
echo "40" > /sys/class/drm/card1/device/hwmon/hwmon2/pwm1
check_status "" "" "set fan pwm value."

log "Setting sclk:0:1600mhz mclk:1:1156mhz."
echo "s 0 1600" > /sys/class/drm/card1/device/pp_od_clk_voltage
check_status "" "" "set sclk:0 to 1600mhz."
echo "m 1 1156" > /sys/class/drm/card1/device/pp_od_clk_voltage
check_status "" "" "set mclk:1 to 1156mhz."

log "Applying the new sclk:0 and mclk:1 values."
echo "c" > /sys/class/drm/card1/device/pp_od_clk_voltage
check_status "applied " "apply " "sclk:0 and mclk:1."

log "Enabling only the max memory state."
echo "3" > /sys/class/drm/card1/device/pp_dpm_mclk
check_status "enabled " "enable " "only the max memory state."

log "Setting the power mode to custom."
echo "6" > /sys/class/drm/card1/device/pp_power_profile_mode
check_status "" "" "set custom power mode."

log "Done."
