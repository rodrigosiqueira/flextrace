REDCOLOR="\033[1;31;49m%s\033[m\n"
GREENCOLOR="\033[1;32;49m%s\033[m\n"
PURPLECOLOR="\033[1;35;49m%s\033[m\n"
YELLOWCOLOR="\033[1;33;49m%s\033[m\n"
BLUECOLOR="\033[1;34;49m%s\033[m\n"

daemonName='FlexTrace'

pidDir='.'
pidFile="$pidDir/$daemonName.pid"

logDir='.'
logFile="$logDir/$daemonName.log"

# Log maxsize in KB
logMaxSize=1024 # 1mb

runInterval=1 # In seconds

# Script PID
myPid=$$
