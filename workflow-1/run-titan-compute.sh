#!/bin/bash -l
set -eu

# RUN TITAN COMPUTE SH
# See http://swift-lang.github.io/swift-t/sites.html#_titan
# to set up an output directory

PATH=/lustre/atlas/world-shared/csc249/shared/swift-t/stc/bin:$PATH

export PROJECT=@@ SET ME @@
# Use this one for CANDLE:
# export PROJECT=CSC249ADOA01
export QUEUE=debug
export TITAN=true

export THIS=$( cd $( dirname $0 ) ; /bin/pwd )

swift-t -m cray -e THIS -t i:./init-titan.sh workflow.swift
