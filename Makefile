# Los parametros de compilacion a tunear estan en un
# archivo separado
include build_config.mk

# Agrego el archivo como dependencia de compilacion
.EXTRA_PREREQS := build_config.mk

SOURCE_DIR=src
TARGETS=demo headless
SOURCES=$(shell echo $(SOURCE_DIR)/*.c)
COMMON_OBJECTS=$(patsubst %,$(SOURCE_DIR)/%,solver.o wtime.o)

all: $(TARGETS)

demo: $(SOURCE_DIR)/demo.o $(COMMON_OBJECTS)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS) -lGL -lGLU -lglut

headless: $(SOURCE_DIR)/headless.o $(COMMON_OBJECTS)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

.PHONY: as
as: src/solver.o
	$(CC) $(CFLAGS) $(CDEBUG) $(LDFLAGS) -S src/solver.c

clean:
	rm -f $(TARGETS) $(SOURCE_DIR)/*.o .depend *~

.depend: $(SOURCE_DIR)/*.[ch]
	$(CC) -MM $(SOURCES) >.depend

-include .depend

.PHONY: clean all
