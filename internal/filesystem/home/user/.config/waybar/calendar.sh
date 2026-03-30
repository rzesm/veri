#!/usr/bin/env bash

yad_pid=""

cleanup() {
  pkill -p $yad_pid
  exit 0
}

trap cleanup SIGINT SIGTERM

yad --name="yad.calendar" --calendar --no-buttons

yad_pid=$!
wait "$yad_pid"
