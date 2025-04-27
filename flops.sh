INSTS=instructions
SCALAR_FLAG=fp_arith_inst_retired.scalar
SSE_FLAG=fp_arith_inst_retired.128b_packed_single
AVX_FLAG=fp_arith_inst_retired.256b_packed_single

EVENTS="$INSTS,$SCALAR_FLAG,$SSE_FLAG,$AVX_FLAG"

SIZE=$1
EXECUTABLE=./headless

# Para correr perf sin necesidad de sudo, correr cada vez que se reinicie el sistema:
# sudo sysctl -w kernel.perf_event_paranoid=1
enable_perf () {
  PARANOID_LEVEL=$(sysctl -n kernel.perf_event_paranoid)
  if [[ $PARANOID_LEVEL -ne 1 ]]; then
    sudo sysctl -n kernel.perf_event_paranoid=1
  fi
}

get_field_value () {
  FIELD=$1
  grep -e "$FIELD" | awk '{ print $1 }' | tr -d ','
}

profile () {
  # Ejecutar el programa haciendo profiling con perf stat
  perf stat -e $EVENTS $EXECUTABLE $SIZE 1> /dev/null
}

parse () {
  read SCALAR_OPS < <(get_field_value $SCALAR_FLAG   < $PROF_FILE)
  read SSE_OPS    < <(get_field_value $SSE_FLAG      < $PROF_FILE)
  read AVX_OPS    < <(get_field_value $AVX_FLAG      < $PROF_FILE)
  read USER_TIME  < <(get_field_value "seconds user" < $PROF_FILE)
  TOTAL_FLOPS=$(( $SCALAR_OPS + $SSE_OPS * 4 + $AVX_OPS * 8 ))
  echo "TOTAL_FLOPS (M)=$(( $TOTAL_FLOPS / 1000000 ))"
  echo "USER_TIME=$USER_TIME"
  echo "FLOPS/ns=$(bc -l <<< "scale=0; $TOTAL_FLOPS / ($USER_TIME * 1000000)")"
}

PROF_FILE=prof.tmp
enable_perf
profile 2> $PROF_FILE
parse