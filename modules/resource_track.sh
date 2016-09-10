# Constants
declare -r memory_log='memory.log'
declare -r cpu_log='cpu.log'
declare -r hardisk_log='hardisk.log'

# Handling collectl base on the configuration file
function collect_resource_data()
{
  local save_to=$1
  local track_target=$2

  # TODO: I believe that has a better way to do it
  case $track_target in
    memory)
      # Node Total Used Free Slab Mapped Anon AnonH Locked Inact HitPct
      collectl -c2 -sM | tail -n 1 >> $save_to/$memory_log
    ;;
    cpu)
      # Cpu User Nice Sys Wait IRQ Soft Steal Guest NiceG Idle
      collectl -c2 -sC | tail -n 1 >> $save_to/$cpu_log
    ;;
    disk)
      # Name KBytes Merged IOs Size Wait KBytes Merged IOs Size Wait RWSize
      # QLen Wait SvcTim Util
      collectl -c2 -sD | tail -n 1 >> $save_to/$hardisk_log
    ;;
    *)
      collectl -c2 -sM | tail -n 1 >> $save_to/$memory_log
      collectl -c2 -sC | tail -n 1 >> $save_to/$cpu_log
    ;;
  esac
}
