CC      = gcc
CFLAGS  = -g3 -O0 -Wall -Wextra -fPIC
BUILD   = build

all: $(BUILD)/libgini.so

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/libgini.so: c/gini.c c/gini.h | $(BUILD)
	$(CC) $(CFLAGS) -shared -o $@ c/gini.c

run: all
	python3 python/gini_client.py

test: all
	python3 python/gini_client.py --file tests/sample_arg.json

clean:
	rm -rf $(BUILD)

.PHONY: all run test clean
