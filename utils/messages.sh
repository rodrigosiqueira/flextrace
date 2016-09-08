# Print normal message (e.g info messages). This function verifies if stdout
# is open and print it with color, otherwise print it without color.
# @param $@ it receives text message to be printed.
function say()
{
  local message="$@"
  if [ -t 1 ]; then
    printf $YELLOWCOLOR "$message"
  else
    echo "$message"
  fi
}

# Print error message. This function verifies if stdout is open and print it
# with color, otherwise print it without color.
# @param $@ it receives text message to be printed.
function complain()
{
  message="$@"
  if [ -t 1 ]; then
    printf $REDCOLOR "$message"
  else
    echo "$message"
  fi
}
