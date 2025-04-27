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
  echo "usage: ./benchmark.sh <executable> <size>"
}

# Argumentos posicionales
if [[ $# -ne 2 ]]; then
    usage
    exit 1
fi

EXECUTABLE=$1
SIZE=$2

LOG_FILE=$LOG_DIR/$(basename $EXECUTABLE).out

# Estadisticas a seguir
INSTS=instructions
SCALAR_FLAG=fp_arith_inst_retired.scalar
SSE_FLAG=fp_arith_inst_retired.128b_packed_single
AVX_FLAG=fp_arith_inst_retired.256b_packed_single

EVENTS="$INSTS,$SCALAR_FLAG,$SSE_FLAG,$AVX_FLAG"

get_field_value () {
  FIELD=$1
  grep -e "$FIELD" | awk '{ print $1 }' | tr -d ','
}

profile () {
  # Ejecutar el programa haciendo profiling con perf stat
  # De aca nos quedamos con cantidad de flops y de instrucciones
  perf stat -e $EVENTS $EXECUTABLE $SIZE >> $LOG_FILE
}

log_profiling () {
  read ATOM_INSTS < <(get_field_value "cpu_atom"     < $PROF_FILE)
  read CORE_INSTS < <(get_field_value "cpu_core"     < $PROF_FILE)
  read SCALAR_OPS < <(get_field_value $SCALAR_FLAG   < $PROF_FILE)
  read SSE_OPS    < <(get_field_value $SSE_FLAG      < $PROF_FILE)
  read AVX_OPS    < <(get_field_value $AVX_FLAG      < $PROF_FILE)
  read USER_TIME  < <(get_field_value "seconds user" < $PROF_FILE)
  TOTAL_INSTS=$(( $ATOM_INSTS + $CORE_INSTS ))
  TOTAL_FLOPS=$(( $SCALAR_OPS + $SSE_OPS * 4 + $AVX_OPS * 8 ))
  echo "N=$SIZE"
  echo "TOTAL_FLOPS (M)=$(( $TOTAL_FLOPS / 1000000 ))"
  echo "FLOPS/IPS (%)=$(bc -l <<< "scale=2; $TOTAL_FLOPS/$TOTAL_INSTS * 100")"
  echo "USER_TIME=$USER_TIME"
  echo "FLOPS/ns=$(bc -l <<< "scale=0; $TOTAL_FLOPS / ($USER_TIME * 1000000)")"
}

run_benchmark () {
  profile 2> $PROF_FILE
  log_profiling
}

PROF_FILE=prof.tmp
enable_perf
run_benchmark
# rm $PROF_FILE
