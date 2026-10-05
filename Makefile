CC      = gcc
CFLAGS  = -g3 -O0 -Wall -Wextra -fPIC
BUILD   = build

all: $(BUILD)/libgini.so $(BUILD)/main_asm

$(BUILD):
	mkdir -p $(BUILD)

# Libreria que usa Python: C (capa intermedia) + asm (capa inferior)
$(BUILD)/libgini.so: c/gini.c c/gini.h asm/gini_asm.s | $(BUILD)
	$(CC) $(CFLAGS) -shared -o $@ c/gini.c asm/gini_asm.s

# Programa de C puro para depurar con GDB
$(BUILD)/main_asm: c/main_asm.c c/gini.h asm/gini_asm.s | $(BUILD)
	$(CC) $(CFLAGS) -o $@ c/main_asm.c asm/gini_asm.s

run: all
	python3 python/gini_client.py

test: all
	python3 python/gini_client.py --file tests/sample_arg.json

# Sesion de GDB: stack antes, durante y despues de gini_asm
# -nx: no carga ~/.gdbinit (gdb-dashboard) para que la salida quede limpia
gdb: $(BUILD)/main_asm
	gdb -q -nx -batch -x docs/gdb_stack.gdb $(BUILD)/main_asm

clean:
	rm -rf $(BUILD)

.PHONY: all run test gdb clean