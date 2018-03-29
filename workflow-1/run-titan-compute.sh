#!/bin/bash -l
set -eu

# RUN TITAN COMPUTE SH
# See http://swift-lang.github.io/swift-t/sites.html#_titan
# to set up an output directory

if (( ${#} != 1 ))
then
  echo "Requires userdir: the directory containing the drug!"
  exit 1
fi
USERDIR=$1

PATH=/lustre/atlas/world-shared/csc249/shared/swift-t/stc/bin:$PATH

# export PROJECT=@@ SET ME @@
# Use this one for CANDLE:
export PROJECT=CSC249ADOA01
export QUEUE=debug
export TITAN=true
export WALLTIME=00:01:00

export THIS=$( cd $( dirname $0 ) ; /bin/pwd )

swift-t -m cray \
        -e THIS \
        -t i:./init-titan.sh \
        workflow.swift \
        --userdir=$USERDIR
