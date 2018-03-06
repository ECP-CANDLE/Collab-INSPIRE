#!/bin/bash -l

# This is how we load NAMD on Titan. These instruction are all coming from
# the Titan website. This might have to go in the bash submission script.

module load namd/2.12
export MPICH_PTL_SEND_CREDITS=-1
export MPICH_MAX_SHORT_MSG_SIZE=8000
export MPICH_PTL_UNEX_EVENTS=80000
export MPICH_UNEX_BUFFER_SIZE=100M

# In theory this is the only application that we need for now. Maybe
# one ore more analysis steps will follow. The Simulation application
# is basically a namd execution with a customised configuration file
# as input.

# Pretend to run NAMD
echo RUNNING NAMD! $*
