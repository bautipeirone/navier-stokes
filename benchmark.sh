#!/bin/bash
# Para correr perf sin necesidad de sudo, correr cada vez que se reinicie el sistema:
# sudo sysctl -w kernel.perf_event_paranoid=1

usage () {
  echo "usage: ./benchmark.sh <size> <rounds>"
}

# Parametros de benchmarking
if ! [ $# = 2 ]; then
  usage
  exit 1
fi

SIZE=$1
ROUNDS=$2

EXECUTABLE="./headless"
INSTS="instructions,fp_arith_inst_retired.scalar"

# Parametros de simulacion
SOURCE=100.0
FORCE=5.0

file_size () {
  echo $(stat -c%s $1)
}

run_simulation () {
  SIZE=$1
  # Ejecutar el programa haciendo profiling con perf stat
  # De aca nos quedamos con cantidad de flops y de instrucciones
  perf stat -e $INSTS $EXECUTABLE $SIZE 0.1 0.0 0.0 $FORCE $SOURCE > /dev/null
}

run_profiler () {
  IPS=0
  FLOPS=0
  for i in $(seq 1 $ROUNDS); do
    read IPS_TMP FLOPS_TMP < <(run_simulation $SIZE 2>&1 | grep -E "inst|ops" | tr -d ',' | awk '{if (NR <= 2) {ips+=$1} else {flops=$1}} END {print ips, flops}')
    IPS=$(( $IPS + $IPS_TMP ))
    FLOPS=$(( $FLOPS + $FLOPS_TMP ))
  done
  IPS=$(( $IPS / $ROUNDS ))
  FLOPS=$(( $FLOPS / $ROUNDS ))
  echo $IPS $FLOPS
}

run_benchmark () {
  echo "$ROUNDS benchmarks, N=$SIZE"
  echo "EXE_SIZE=$(file_size $EXECUTABLE)"
  read IPS FLOPS < <(run_profiler)
  echo "IPS=$IPS"
  echo "FLOPS=$FLOPS"
}

run_benchmark $SIZE $ROUNDS