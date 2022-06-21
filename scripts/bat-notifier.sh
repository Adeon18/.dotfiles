#!/bin/sh
# 
# A script which ckecks and notifies when the battery is low, full, or changes state

battery_level=$(acpi -b | sed -n 's/.*\ \([[:digit:]]\{1,3\}\)\%.*/\1/;p')
battery_state=$(acpi -b | awk '{print $3}' | tr -d ",")
# battery_remaining=$(acpi -b | sed -n '/Discharging/{s/^.*\ \([[:digit:]]\{2\}\)\:\([[:digit:]]\{2\}\).*/\1h \2min/;p}')

_battery_full_level="100"
_battery_warning_level="25"
_battery_low_level="15"
_battery_critical_level="10"

if [[ ! -f "/tmp/.battery" ]]; then
    echo "${battery_level}" > /tmp/.battery
    echo "${battery_state}" >> /tmp/.battery
    exit
fi

previous_battery_level=$(< /tmp/.battery head -n 1)
previous_battery_state=$(< /tmp/.battery tail -n 1)
echo "${battery_level}" > /tmp/.battery
echo "${battery_state}" >> /tmp/.battery

check_and_notify_low_bat()
{
    if [[ ${battery_state} != "Discharging" ]] || [[ "${battery_level}" == "${previous_battery_level}" ]]; then
        exit
    fi

    if [[ ${battery_level} -le ${_battery_critical_level} ]]; then
        notify-send "Low Battery" "Are you fucking stupid or something? The battery level is ${battery_level}%!" -u critical
    elif [[ ${battery_level} -le ${_battery_low_level} ]]; then
        notify-send "Low Battery" "You should really consider charging up now" -u normal
    elif [[ ${battery_level} -le ${_battery_warning_level} ]]; then
        notify-send "Low Battery" "Oh no, I sure hope you brought a changer." -u normal
    fi
}

check_and_notify_bat_state_change()
{   
    if [[ "${battery_state}" != "Discharging" ]]; then
        if [[ "${previous_battery_state}" == "Discharging" ]]; then
            notify-send "Charging" "Battery is now plugged in." -u low
        elif [[ "${battery_state}" == "${_battery_full_level}" ]]; then
            notify-send "Charged Up!" "The battery is full charged." -u low
        fi
    fi

    if [[ "${battery_state}" == "Discharging" ]] && [[ "${previous_battery_state}" != "Discharging" ]]; then
        notify-send "Power Unplugged" "The power cable got yeeted." -u low
    fi
}

check_and_notify_bat_state_change
check_and_notify_low_bat