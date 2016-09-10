. modules/resource_track.sh --source-only
declare -r target_output='tests/temp_files'

setUp()
{
  mkdir -p $target_output
}

tearDown()
{
  rm -rf $target_output
}

function testVerifyMemoryLogWasCreated()
{
  collect_resource_data $target_output 'memory'
  test ! -f $target_output
  assertEquals 'Check if memory.log was created' $? 0
}

function testVerifyCpuLogWasCreated()
{
  collect_resource_data $target_output 'cpu'
  test ! -f $target_output
  assertEquals 'Check if cpu.log was created' $? 0
}

function testVerifyDiskLogWasCreated()
{
  collect_resource_data $target_output 'disk'
  test ! -f $target_output
  assertEquals 'Check if hardisk.log was created' $? 0
}

function testEmptinessOnLogFiles()
{
  collect_resource_data $target_output 'memory'
  collect_resource_data $target_output 'cpu'
  collect_resource_data $target_output 'disk'

  local size_memory=$(( `stat -c %s $target_output/memory.log` ))
  local size_cpu=$(( `stat -c %s $target_output/cpu.log` ))
  local size_disk=$(( `stat -c %s $target_output/hardisk.log` ))

  assertNotEquals 'Empty file' $size_memory 0
  assertNotEquals 'Empty file' $size_cpu 0
  assertNotEquals 'Empty file' $size_disk 0
}

. shunit2
