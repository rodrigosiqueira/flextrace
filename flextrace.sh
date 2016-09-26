#!/bin/bash

base_directory="$(dirname "$0")"
. $base_directory/utils/messages.sh --source-only
. $base_directory/utils/data_type.sh --source-only
. $base_directory/utils/log.sh --source-only
. $base_directory/daemon_control/main_control.sh --source-only
. $base_directory/modules/resource_track.sh --source-only

function loop()
{
  now=$(date +%s)

  if [ -z $last ]; then
    last=$(date +%s)
  fi

  if [[ $(cat $track) -gt 0 ]]; then
    collect_resource_data '/tmp' cpu
  fi

  # Startover
  loop
}

function enable_module()
{
  echo 1 > $track
}

function disable_module()
{
  echo 0 > $track
}

# Command
if [ -f "$pidFile" ]; then
  oldPid=$(cat $pidFile)
fi
check_daemon
case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  status)
    status
    ;;
  restart)
    restart
    ;;
  capture)
    capture
    ;;
  release)
    release
    ;;
  *)
  complain "usage $0 { start | stop | restart | status |" \
           "run-module | stop-module | capture | release }"
  exit 1
esac

exit 0
