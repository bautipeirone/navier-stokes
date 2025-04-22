CC=gcc
CFLAGS=
CFLAGS+=-Wall -Wextra -Wno-unused-parameter -O3
CFLAGS+=-funsafe-math-optimizations -ffast-math -funroll-loops -ftree-vectorize -funsafe-loop-optimizations -fno-tree-loop-distribute-patterns
CFLAGS+=-march=native -mtune=native #-fopt-info-vec -fopt-info-vec-missed
LDFLAGS=
