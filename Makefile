CC=gcc
CFLAGS=-std=c11 -Wall -Wextra -Wno-unused-parameter -O3 -funroll-loops -march=native -mfpmath=sse -ffast-math
CFLAGS+=-Ofast
LDFLAGS=

SOURCE_DIR=src
TARGETS=demo headless
SOURCES=$(shell echo $(SOURCE_DIR)/*.c)
COMMON_OBJECTS=$(patsubst %,$(SOURCE_DIR)/%,solver.o wtime.o)

all: $(TARGETS)

demo: $(SOURCE_DIR)/demo.o $(COMMON_OBJECTS)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS) -lGL -lGLU -lglut

headless: $(SOURCE_DIR)/headless.o $(COMMON_OBJECTS)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

clean:
	rm -f $(TARGETS) *.o .depend *~

.depend: *.[ch]
	$(CC) -MM $(SOURCES) >.depend

-include .depend

.PHONY: clean all
