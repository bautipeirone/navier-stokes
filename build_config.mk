CC=ispc
# Banderas basicas de compilacion
CFLAGS=-Wall -Wextra -Wno-unused-parameter
# Banderas lab1
CFLAGS+=-ffast-math -O3 -funsafe-math-optimizations -funroll-loops 
CFLAGS+=-march=native -mtune=native
#-funsafe-loop-optimizations #-fno-tree-loop-distribute-patterns
# Banderas lab2
CFLAGS+=-ftree-vectorize
CFLAGS+=-DAUTOVEC
CFLAGS+=-DINTRINSICS
CDEBUG=

ifeq ($(CC), gcc)
    CDEBUG+=-fopt-info-vec -fopt-info-vec-missed
else ifeq ($(CC), clang)
		CDEBUG+=-Rpass=loop-vectorize -Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize
else ifeq ($(CC), icx)
    CDEBUG+=-qopt-report=max -qopt-report-phase=vec -qopt-report-file=my_report.txt
endif
# LDFLAGS=-flto
