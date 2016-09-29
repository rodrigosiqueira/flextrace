# This file is responsible for reading and handling the configuration file

# Keep here the configurations, if you create a new module just add here
typeset -A configurations
configurations=(
  [follow_cpu]=false
  [follow_memory]=false
  [follow_disk]=false
  [follow_interval]=false
  [strace]=false
  [folder_save_to]='/tmp'
)

# Read config file
# @param read configuration file path
function check_configuration()
{
  local config_path=$1
  while read line
  do
    if echo $line | grep -F = &>/dev/null
    then
      varname=$(echo $line | cut -d '=' -f 1)
      configurations[$varname]=$(echo "$line" | cut -d '=' -f 2-)
    fi
  done < $config_path
}
