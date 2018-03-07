#!/bin/bash -l
set -eu

# NAMD SH
# Wrapper script around NAMD

# This is how we load NAMD on Titan. These instruction are all coming from
# the Titan website. This might have to go in the bash submission script.

# module load namd/2.12

export MPICH_PTL_SEND_CREDITS=-1
export MPICH_MAX_SHORT_MSG_SIZE=8000
export MPICH_PTL_UNEX_EVENTS=80000
export MPICH_UNEX_BUFFER_SIZE=100M

# In theory this is the only application that we need for now. Maybe
# one ore more analysis steps will follow. The Simulation application
# is basically a namd execution with a customised configuration file
# as input.

operation=$1

if [[ $operation == "minimize" ]]
then
  mutation=$2 coor_out=$3 vel_out=$4 xsc_out=$5
  echo "namd minimize mutation=$mutation"
  touch $coor_out $vel_out $xsc_out
  exit 0
fi

if ! [[ $operation == "heat"        ||
        $operation == "equilibrate" ||
        $operation == "production"  ]]
then
  echo "unknown namd operation: $operation"
  exit 1
fi

# Pretend to run NAMD
shift 10 # Lots of arguments!
coor_out=$2 vel_out=$3 xsc_out=$4
echo RUNNING NAMD $operation $coor_out $vel_out $xsc_out
touch $coor_out $vel_out $xsc_out
