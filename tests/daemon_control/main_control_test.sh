. utils/data_type.sh --source-only
. daemon_control/main_control.sh --source-only

declare -r target_output='tests/temp_files'

setUp()
{
  mkdir -p $target_output
  daemonName='FlexTrace'
  logDir=$target_output
  pidDir=$target_output
  logFile="$logDir/$daemonName.log"
}

tearDown()
{
  rm -rf $target_output
}

function testSetupCheckDirectory()
{
  setup
  test ! -d $pidDir
  assertEquals 'Directory should exists' $? 1
  test ! -d $logDir
  assertEquals 'Directory should exists' $? 1
  logDir='tests/temp_filess'
  test ! -d $logDir
  assertEquals 'Directory should not exists' $? 0
}

. shunit2
