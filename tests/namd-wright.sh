#!/bin/bash -l
set -eu

# NAMD WRIGHT SH
# Wrapper script around NAMD
# Based on David Wright email 2018/03/16

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
if ! [[ $operation == "minimize"    ||
        $operation == "heat"        ||
        $operation == "equilibrate" ||
        $operation == "production"  ]]
then
  echo "unknown namd operation: $operation"
  exit 1
fi

echo "I'm alive"

mutation=$2
basedir=$3
mutation_dir="$basedir/$2"
rep_no=$4
rep_no=$((rep_no+1))
replica_dir="$mutation_dir/replicas/rep$rep_no"
logfile=$5

if [[ $operation == "minimize" ]]
then
  cp -r $mutation_dir/mineq_confs $replica_dir
  cd $replica_dir/mineq_confs
  conf="eq0.conf"
  echo "namd minimize system: $mutation rep$rep_no"
elif [[ $operation == "heat" ]]
then
  cd $replica_dir/mineq_confs
  conf="eq1.conf"
  echo "namd heat system: $mutation rep$rep_no"
elif [[ $operation == "equilibrate" ]]
then
  cd $replica_dir/mineq_confs
  conf="eq2.conf"
  echo "namd equilibrate system: $mutation rep$rep_no"
elif [[ $operation == "production" ]]
then
  cp -r $mutation_dir/sim_confs $replica_dir
  cd $replica_dir/sim_confs
  conf="sim1.conf"
  echo "namd run production: $mutation rep$rep_no"
fi

namd2 ++ppn 7 +setcpuaffinity \
      +pemap 0,2,4,6,8,10,12 +commap 14 +idlepoll +devices 0 \
      $conf >& $logfile
