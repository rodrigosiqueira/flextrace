# Copyright (C) 2016 Rodrigo Siqueira
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.

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

# Help menu with explanation of each option
function help_commands()
{
  say "s - start Flextrace"
  say "p - pause Flextrace"
  say "a - status of Flextrace"
  say "r - restart Flextrace"
  say "c - start collect based on file configuration"
  say "f - stop collect"
}
