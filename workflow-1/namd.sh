#!/bin/bash -l
set -eu

# NAMD SH
# Wrapper script around NAMD

# This is from the NAMD2 binary download
NAMD2=/lustre/atlas/proj-shared/csc249/sfw/NAMD_2.12_Linux-x86_64-multicore/namd2

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

mutation=$2
basedir=$3
mutation_dir="$basedir/$2"
rep_no=$4
#rep_no=$((rep_no+))
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

# $NAMD2 ++ppn 7 +setcpuaffinity \
#        +pemap 0,2,4,6,8,10,12 +commap 14 +idlepoll +devices 0 \
#        $conf > $logfile 2>&1

# The NAMD2 arguments above do not work but the following does:
#   (Need to iterate to make sure we are using node resources well)
$NAMD2 $conf > $logfile
# Return NAMD2 exit code to Swift/T
