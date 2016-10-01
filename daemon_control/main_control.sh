# Copyright (C) 2016 Rodrigo Siqueira
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.

# Set up basic folder to work daemon. Basically, it creates: pid and log
# folder, and log file.
function setup()
{
  # Check directory
  if [ ! -d "$pidDir" ]; then
    mkdir "$pidDir"
  fi
  if [ ! -d "$logDir" ]; then
    mkdir "$logDir"
  fi

  # Verify if log file exists, if already exists check the size
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

# Start daemon
function start()
{
  setup
  check_daemon
  local daemon_status=$?
  if [[ $daemon_status -eq 1 ]]; then
    complain "$DAEMONNAME is already running."
    exit 1
  fi

  say " * Starting $DAEMONNAME with PID: $myPid."
  echo "$myPid" > "$pidFile"
  log '*** ' $(date +"%Y-%m-%d") ": Staring up $DAEMONNAME"

  # Start loop
  loop
}

function stop()
{
  check_daemon
  local daemon_status=$?
  # Stop flextrace
  if [[ $daemon_status -eq 0 ]]; then
    complain "$DAEMONNAME is not running"
    exit 1
  fi
  printf $PURPLECOLOR " * Stopping $DAEMONNAME"
  log '*** ' $(date +"%Y-%m-%d") ": $DAEMONNAME stopped."

  if [[ ! -z $(cat $pidFile) ]]; then
    kill -SIGTERM $(cat $pidFile) &> /dev/null
    echo '' > $pidFile
  fi
}

function status()
{
  check_daemon
  local daemon_status=$?
  if [[ $daemon_status -eq 1 ]]; then
    say " * $DAEMONNAME is running."
  else
    complain " * $DAEMONNAME is not running."
  fi
  exit 0
}

function restart()
{
  check_daemon
  local daemon_status=$?
  if [[ $daemon_status = 0 ]]; then
    complain "$DAEMONNAME is not running"
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
  elif [[ $(ps aux | grep "$DAEMONNAME" | grep -v grep | grep -v "$myPid" | grep -v "00:00.0") > /dev/null ]]; then
    log '***' $(date +"%Y-%m-%d") ": $DAEMONNAME running with invalid PID; restarting."
    restart
    return 1
  else
    return 0
  fi
  return 1
}
