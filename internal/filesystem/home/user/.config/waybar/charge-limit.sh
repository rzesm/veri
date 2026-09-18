#!/bin/bash

yad_buffer=$(mktemp)
yad_pid=""

cleanup() {
    kill $yad_pid
    rm -f "$yad_buffer"
    exit 0
}

trap cleanup SIGINT SIGTERM

old_charge_limit=$(cat /var/charge-limit)

yad --name="yad.charge" \
    --text="<b> Limit battery charge</b>" \
    --scale \
    --min-value=50 \
    --max-value=100 \
    --step=5 \
    --enforce-step \
    --value=$old_charge_limit \
    --button=OK:0 \
    --button=Cancel:1 \
    --mark=50:50 \
    --mark=100:100 \
    --buttons-layout=center \
    --text-align=center \
    >"$yad_buffer" 2>/dev/null &

yad_pid=$!

wait "$yad_pid"
exit_code=$?

percentage=""
if [[ -s "$yad_buffer" ]]; then
    percentage=$(tr -d '\r\n' <"$yad_buffer")
fi

rm -f "$yad_buffer"

if [[ $exit_code -eq 0 ]]; then
    sudo /usr/local/bin/charge-limit "$percentage"
    case $? in
        0) notify-send "Charge limit set to ${percentage}%";;
        2) notify-send "Failed to set charge limit: invalid value";;
        3|4) notify-send "Failed to set charge limit: unsupported functionality";;
    esac
fi
