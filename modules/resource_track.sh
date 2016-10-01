# Copyright (C) 2016 Rodrigo Siqueira
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.

# Constants
declare -r MEMORY_LOG='memory.log'
declare -r CPU_LOG='cpu.log'
declare -r HARDISK_LOG='hardisk.log'

# Handling collectl base on the configuration file
function collect_resource_data()
{
  local save_to=$1
  local track_target=$2

  # TODO: I believe that has a better way to do it
  case $track_target in
    memory)
      # Node Total Used Free Slab Mapped Anon AnonH Locked Inact HitPct
      collectl -c2 -sM | tail -n 1 >> $save_to/$MEMORY_LOG
    ;;
    cpu)
      # Cpu User Nice Sys Wait IRQ Soft Steal Guest NiceG Idle
      collectl -c2 -sC | tail -n 1 >> $save_to/$CPU_LOG
    ;;
    disk)
      # Name KBytes Merged IOs Size Wait KBytes Merged IOs Size Wait RWSize
      # QLen Wait SvcTim Util
      collectl -c2 -sD | tail -n 1 >> $save_to/$HARDISK_LOG
    ;;
    *)
      collectl -c2 -sM | tail -n 1 >> $save_to/$MEMORY_LOG
      collectl -c2 -sC | tail -n 1 >> $save_to/$CPU_LOG
    ;;
  esac
}

# Handling the continuous capture of data from hardware
# @param save_to Path to save all the results
# @param collectlPid Reference to PID
function continuous_collect_data()
{
  local save_to=$1
  declare -n collectlPid=$2

  local to_collect='C'
  build_flag to_collect

  collectl '-s'$to_collect -f $save_to &
  collectlPid=$!
}

# Build flag for collectl based on configuration file
# @param flag Keep the current trace requested
function build_flag()
{
  declare -n flag=$1
  check_configuration $config_path

  if ${configurations[follow_cpu]}; then
    flag='C'
  fi
  if ${configurations[follow_memory]}; then
    flag=$flag'M'
  fi
  if ${configurations[follow_disk]}; then
    flag=$flag'D'
  fi
}
