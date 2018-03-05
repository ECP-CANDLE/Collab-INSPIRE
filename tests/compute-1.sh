#!/bin/bash -l
set -eu

# COMPUTE 1 SH

PATH=/lustre/atlas/world-shared/csc249/shared/swift-t/stc/bin:$PATH

export PROJECT=@@ SET ME @@
# Use this one for CANDLE:
# export PROJECT=CSC249ADOA01
export QUEUE=debug
export TITAN=true

swift-t -m cray hello-world.swift
