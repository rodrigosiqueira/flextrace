#!/bin/sh

REDCOLOR="\033[1;31;49m%s\033[m\n"
GREENCOLOR="\033[1;32;49m%s\033[m\n"
PURPLECOLOR="\033[1;35;49m%s\033[m\n"

daemonName='flextrace'

pidDir='.'
pidFile="$pidDir/$daemonName.pid"

logDir='.'
logFile="$logDir/$daemonName.log"

# Log maxsize in KB
logMaxSize=1024 # 1mb

runInterval=60 # In seconds

function trace_application()
{
  # This is where you put all the commands for the daemon
  echo 'Running commands'
}

myPid=$$

function setup()
{
  # Check directory
  if [ ! -d "$pidDir" ]; then
    mkdir "$pidDir"
  fi
  if [ ! -d "$logDir" ]; then
    mkdir "$logDir"
  fi
  if [ ! -f "$logFile" ]; then
    touch "$logFile"
  else
    size=$(( (`stat -c %s $logFile`)/8 ))
    if [[ $size -gt $logMaxSize ]]; then
      mv $logFile "$logFile.old"
      touch "$logFile"
    fi
  fi
}

function start()
{
  setup
  check_daemon
  local daemon_status=$?
  if [[ $daemon_status -eq 1 ]]; then
    printf $REDCOLOR "$daemonName is already running."
    exit 1
  fi
  printf $GREENCOLOR " * Starting $daemonName with PID: $myPid."
  echo "$myPid" > "$pidFile"
  log '*** ' $(date +"%Y-%m-%d") ": Staring up $daemonName"

  # Start loop
  loop
}

function stop()
{
  check_daemon
  local daemon_status=$?
  # Stop flextrace
  if [[ $daemon_status -eq 0 ]]; then
    printf $REDCOLOR "$daemonName is not running"
    exit 1
  fi
  printf $PURPLECOLOR " * Stopping $daemonName"
  log '*** ' $(date +"%Y-%m-%d") ": $daemonName stopped."

  if [[ ! -z $(cat $pidFile) ]]; then
    kill -9 $(cat $pidFile) &> /dev/null
  fi
}

function status()
{
  check_daemon
  local daemon_status=$?
  if [[ $daemon_status -eq 1 ]]; then
    printf $GREENCOLOR " * $daemonName is running."
  else
    printf $REDCOLOR " * $daemonName is not running."
  fi
  exit 0
}

function restart()
{
  check_daemon
  local daemon_status=$?
  if [[ $daemon_status = 0 ]]; then
    echo "$daemonName is not running"
    exit 1
  fi
  stop
  start
}

function check_daemon()
{
  if [ -z "$oldPid" ]; then
    return 0
  elif [[ $(ps aux | grep "$oldPid" | grep -v grep) > /dev/null ]]; then
    if [ -f "$pidFile" ]; then
      if [[ $(cat "$pidFile") = "$oldPid" ]]; then
        return 1
      else
        return 0
      fi
    fi
  elif [[ $(ps aux | grep "$daemonName" | grep -v grep | grep -v "$myPid" | grep -v "00:00.0") > /dev/null ]]; then
    log '***' $(date +"%Y-%m-%d") ": $daemonName running with invalid PID; restarting."
    restart
    return 1
  else
    return 0
  fi
  return 1
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

log()
{
  echo "$@" >> "$logFile"
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
  *)
  printf $REDCOLOR "usage $0 { start | stop | restart | status }"
  exit 1
esac

exit 0
