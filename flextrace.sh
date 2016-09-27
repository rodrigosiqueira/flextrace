#!/bin/bash

base_directory="$(dirname "$0")"
continuous_pid=0

. $base_directory/utils/messages.sh --source-only
. $base_directory/utils/data_type.sh --source-only
. $base_directory/utils/log.sh --source-only
. $base_directory/daemon_control/main_control.sh --source-only
. $base_directory/modules/resource_track.sh --source-only

function help_commands()
{
  say "s - start Flextrace"
  say "p - pause Flextrace"
  say "a - status of Flextrace"
  say "r - restart Flextrace"
  say "c - start collect based on file configuration"
  say "f - stop collect"
}

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

getopts "sparcfh" opt

case "$opt" in
  s)
    start >&2
    ;;
  p)
    stop >&2
    ;;
  a)
    status >&2
    ;;
  r)
    restart >&2
    ;;
  c)
    capture >&2
    ;;
  f)
    release >&2
    ;;
  h)
    help_commands >&2
    ;;
  \?)
    complain "Invalid option: -$OPTARG" >&2
    complain "usage $0 [sparcfh]"
    exit 1
    ;;
esac

exit 0
