#!/bin/bash

# Para correr perf sin necesidad de sudo, correr cada vez que se reinicie el sistema:
# sudo sysctl -w kernel.perf_event_paranoid=1
enable_perf () {
  PARANOID_LEVEL=$(sysctl -n kernel.perf_event_paranoid)
  if [[ $PARANOID_LEVEL -ne 1 ]]; then
    sudo sysctl -n kernel.perf_event_paranoid=1
  fi
}


LOG_DIR=logs
BUILD_DIR=build

mkdir -p $LOG_DIR $BUILD_DIR
make > /dev/null

usage () {
  echo "usage: ./benchmark.sh <executable> <size> <rounds>"
}

# Argumentos posicionales
if [[ $# -ne 3 ]]; then
    usage
    exit 4
fi

EXECUTABLE=$1
SIZE=$2
ROUNDS=$3

# Estadisticas a seguir
INSTS="instructions,fp_arith_inst_retired.scalar,fp_arith_inst_retired.256b_packed_single"

# Parametros de simulacion
TIME_STEP=0.1
DIFF=0.0
VISC=0.0
SOURCE=100.0
FORCE=5.0

LOG_FILE=$LOG_DIR/$(basename $EXECUTABLE).out

file_size () {
  echo $(stat -c%s $1)
}

run_simulation () {
  SIZE=$1
  # Ejecutar el programa haciendo profiling con perf stat
  # De aca nos quedamos con cantidad de flops y de instrucciones
  perf stat -e $INSTS $EXECUTABLE $SIZE $TIME_STEP $DIFF $VISC $FORCE $SOURCE >> $LOG_FILE
}

run_profiler () {
  IPS=0
  FLOPS=0
  : > $LOG_FILE
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

enable_perf
run_benchmark