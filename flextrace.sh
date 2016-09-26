#!/bin/bash

base_directory="$(dirname "$0")"
continuous_pid=0

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

  # Startover
  loop
}

function capture()
{
  # TODO: You should read this value in the configuration file
  continuous_collect_data '/tmp/collect_xpto' cpu continuous_pid
  echo $continuous_pid > '.continuous'
  say "Start collect"
}

function release()
{
  if [[ $(cat .continuous) -gt 0 ]]; then
    say 'Stopped continuous collect'
    continuous_pid=$(cat .continuous)
    echo $continuous_pid
    kill -SIGTERM $continuous_pid
  fi
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
