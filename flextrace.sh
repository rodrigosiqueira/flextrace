#!/bin/bash

# Copyright (C) 2016 Rodrigo Siqueira
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.
#
# This file put all scripts together and keep option menu. Finally it has a
# basic manipulation of sample collect

BASE_DIRECTORY="$(dirname "$0")"
config_path='config/flextrace.conf'

. $BASE_DIRECTORY/utils/messages.sh --source-only
. $BASE_DIRECTORY/utils/data_type.sh --source-only
. $BASE_DIRECTORY/utils/log.sh --source-only
. $BASE_DIRECTORY/utils/handle_configuration_file.sh --source-only
. $BASE_DIRECTORY/daemon_control/main_control.sh --source-only
. $BASE_DIRECTORY/daemon_control/collect_continuous_handler.sh --source-only
. $BASE_DIRECTORY/modules/resource_track.sh --source-only

# Handling signals
trap "say 'Just a second...' && stop" SIGINT SIGTERM

function loop()
{
  now=$(date +%s)

  if [ -z $last ]; then
    last=$(date +%s)
  fi

  # Startover
  loop
}

# Command
if [ -f "$pidFile" ]; then
  oldPid=$(cat $pidFile)
fi
check_daemon

getopts "sparcfh" opt

check_configuration $config_path

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
