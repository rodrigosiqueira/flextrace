#!/bin/bash

base_directory="$(dirname "$0")"
. $base_directory/utils/messages.sh --source-only
. $base_directory/utils/data_type.sh --source-only
. $base_directory/utils/log.sh --source-only
. $base_directory/daemon_control/main_control.sh --source-only

function trace_application()
{
  # This is where you put all the commands for the daemon
  echo 'Running commands'
}

function loop()
{
  now=$(date +%s)

  if [ -z $last ]; then
    last=$(date +%s)
  fi

  trace_application
  last=$(date +%s)
  if [[ ! $((now-last+runInterval+1)) -lt $((runInterval)) ]]; then
    sleep $((now-last+runInterval))
  fi

  # Startover
  loop
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
  execute-module)
    say 'moduleeee'
    ;;
  stop-module)
    say 'stoppp'
    ;;
  *)
  complain "usage $0 { start | stop | restart | status }"
  exit 1
esac

exit 0
