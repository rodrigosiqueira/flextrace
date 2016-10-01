# Copyright (C) 2016 Rodrigo Siqueira
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.

declare -r REDCOLOR="\033[1;31;49m%s\033[m\n"
declare -r GREENCOLOR="\033[1;32;49m%s\033[m\n"
declare -r PURPLECOLOR="\033[1;35;49m%s\033[m\n"
declare -r YELLOWCOLOR="\033[1;33;49m%s\033[m\n"
declare -r BLUECOLOR="\033[1;34;49m%s\033[m\n"

declare -r DAEMONNAME='FlexTrace'

pidDir='.'
pidFile="$pidDir/$DAEMONNAME.pid"

logDir='.'
logFile="$logDir/$DAEMONNAME.log"

# Log maxsize in KB
declare -r logMaxSize=1024 # 1mb

runInterval=1 # In seconds

# Script PID
myPid=$$
