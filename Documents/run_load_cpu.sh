#!/bin/bash

echo "Load cpu with workload using stress-ng tool."
echo "Press Ctrl+C to finish. Check with htop"


N_CPU=3         # number of cpu to stress
BUSY_SLOT=100   # ms

step=5
load=25

FLAGS=" --cpu ${N_CPU} --cpu-method int32 --cpu-load $load --cpu-load-slice ${BUSY_SLOT} --io 1 --hdd 1 --timer 1 --timeout 1h "
CMD="stress-ng ${FLAGS}"
echo "${CMD}"

${CMD}

# Zenity is synchronous
    #~ LOAD=$(zenity --scale --min-value=0 --max-value=100 --text="Please select CPU load")



