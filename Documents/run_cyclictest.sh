#!/bin/bash


: ${3?"Usage: $0 NUMBER_LOOPS INTERVAL_USECONDS MODE"}

# Parse input args
case $3 in
        isolated)
               cset  set -l
               PREFIX="cset shield --exec --"
               CASE="cset"
               ;;

        *)     PREFIX=
               CASE="rt"
               ;;
esac

echo "create histogram using cyclictest tool."

# Arguments
N_LOOPS="$1"
USECONDS="$2"

# Config parameters
# ISOLATED_CORE=2
MAX_EXPECTED=200
#OUTPUT=""
OUTPUT="histogram_${USECONDS}_${N_LOOPS}_${CASE}.txt"

# Version
echo ""
$HOME/bin/rt-tests/cyclictest --version 2> /dev/null | head -n 1
echo ""

# Run tool:
# Remove --affinity ${ISOLATED_CORE} --mainaffinity=0 since it is executed in a cset
FLAGS=" --clock=1 -m -p99 --interval=${USECONDS} --loops=${N_LOOPS} -q --histofall=${MAX_EXPECTED}"
CMD="$HOME/bin/rt-tests/cyclictest ${FLAGS}"
echo "${CMD}"
${PREFIX} sudo chrt -f 99 ${CMD} > ${OUTPUT}
