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

  if [[ $(cat $track) -gt 0 ]]; then
    say "IT'S ME, MARIO"
  fi
  trace_application
  last=$(date +%s)
  if [[ ! $((now-last+runInterval+1)) -lt $((runInterval)) ]]; then
    sleep $((now-last+runInterval))
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
  execute-module)
    enable_module
    ;;
  stop-module)
    disable_module
    ;;
  *)
  complain "usage $0 { start | stop | restart | status }"
  exit 1
esac

exit 0
