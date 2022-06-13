battery_level=$(acpi -b | sed -n 's/.*\ \([[:digit:]]\{1,3\}\)\%.*/\1/;p')
battery_state=$(acpi -b | awk '{print $3}' | tr -d ",")
battery_remaining=$(acpi -b | sed -n '/Discharging/{s/^.*\ \([[:digit:]]\{2\}\)\:\([[:digit:]]\{2\}\).*/\1h \2min/;p}')

_battery_threshold_level="25"
_battery_critical_level="15"
_battery_suspend_level="5"

if [ ! -f "/tmp/.battery" ]; then
    echo "${battery_level}" > /tmp/.battery
    echo "${battery_state}" >> /tmp/.battery
    exit
fi

previous_battery_level=$(cat /tmp/.battery | head -n 1)
previous_battery_state=$(cat /tmp/.battery | tail -n 1)
echo "${battery_level}" > /tmp/.battery
echo "${battery_state}" >> /tmp/.battery

checkBatteryLevel() {
    if [ ${battery_state} != "Discharging" ] || [ "${battery_level}" == "${previous_battery_level}" ]; then
        exit
    fi

    if [ ${battery_level} -le ${_battery_suspend_level} ]; then
        notify-send "Low Battery" "Are you fucking stupid or something? The battery level is 5%!" -u critical
    elif [ ${battery_level} -le ${_battery_critical_level} ]; then
        notify-send "Low Battery" "You should really consider charging up now" -u normal
    elif [ ${battery_level} -le ${_battery_threshold_level} ]; then
        notify-send "Low Battery" "Oh no, I sure hope you brought a changer." -u normal
    fi
}

checkBatteryStateChange() {
    if [ "${battery_state}" != "Discharging" ] && [ "${previous_battery_state}" == "Discharging" ]; then
        notify-send "Charging" "Battery is now plugged in." -u low
    fi

    if [ "${battery_state}" == "Discharging" ] && [ "${previous_battery_state}" != "Discharging" ]; then
        notify-send "Power Unplugged" "The power cable got yeeted." -u low
    fi
}

checkBatteryStateChange
checkBatteryLevel

