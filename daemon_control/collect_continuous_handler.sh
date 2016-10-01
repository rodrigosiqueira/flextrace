# Copyright (C) 2016 Rodrigo Siqueira
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.
#
# This file keeps functions required to start and stop continuous collect of
# data.

# This variable, basically keep the PID reference to collectl. It is required
# to be possible to 
CONTINUOUS_PID=0

# Start capture data base on specified collect tools. For example, it could be
# a collectl or strace
function capture()
{
  check_configuration $config_path
  local output_result=${configurations[folder_save_to]}
  continuous_collect_data $output_result CONTINUOUS_PID
  echo $CONTINUOUS_PID > '.continuous'
  say 'Start collect'
}

# Read all PIDs inside .continuous file and stop continuous capture of data
function release()
{
  if [[ $(cat .continuous) -gt 0 ]]; then
    say 'Stopped continuous collect'
    CONTINUOUS_PID=$(cat .continuous)
    echo $CONTINUOUS_PID
    kill -SIGTERM $CONTINUOUS_PID
  fi
}
