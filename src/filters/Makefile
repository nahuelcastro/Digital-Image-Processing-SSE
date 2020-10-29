# ************************************************************************* #
#   Organizacion del Computador II - Trabajo Practico 2                     #
# ************************************************************************* #

CFLAGS64 = -ggdb -Wall -Wno-unused-parameter -Wextra -std=c99 -no-pie -pedantic -m64 -O0 -march=native
CFLAGS64_2 = -ggdb -Wall -Wno-unused-parameter -Wextra -std=c99 -no-pie -pedantic -m64 -O2 -march=native
CFLAGS64_3 = -ggdb -Wall -Wno-unused-parameter -Wextra -std=c99 -no-pie -pedantic -m64 -O3 -march=native
CFLAGS=$(CFLAGS64)
CFLAGS2=$(CFLAGS64_2)
CFLAGS3=$(CFLAGS64_3)

ASM = nasm
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	ASMFLAGS64 = -felf64 -g -F dwarf
endif
ifeq ($(UNAME_S),Darwin)
	ASMFLAGS64 = -fmacho64 -g -DDARWIN
endif

ASMFLAGS = $(ASMFLAGS64)

BUILD_DIR = ../build
BUILD_DIR_2 = ../build2
BUILD_DIR_3 = ../build3

FILTROS = ColorBordes ImagenFantasma PixeladoDiferencial ReforzarBrillo

FILTROS_OBJ = $(addsuffix .o, $(FILTROS)) $(addsuffix _asm.o, $(FILTROS)) $(addsuffix _c.o, $(FILTROS))
FILTROS_OBJ_CON_PATH = $(addprefix  $(BUILD_DIR)/, $(FILTROS_OBJ))
FILTROS_OBJ_CON_PATH_2 = $(addprefix  $(BUILD_DIR_2)/, $(FILTROS_OBJ))
FILTROS_OBJ_CON_PATH_3 = $(addprefix  $(BUILD_DIR_3)/, $(FILTROS_OBJ))

.PHONY: filtros clean

filtros: $(FILTROS_OBJ_CON_PATH) $(FILTROS_OBJ_CON_PATH_2) $(FILTROS_OBJ_CON_PATH_3)

$(BUILD_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<


$(BUILD_DIR_2)/%.o: %.c
	$(CC) $(CFLAGS2) -c -o $@ $<


$(BUILD_DIR_3)/%.o: %.c
	$(CC) $(CFLAGS3) -c -o $@ $<

$(BUILD_DIR)/%.o: %.asm
	$(ASM) $(ASMFLAGS) -o $@ $<


$(BUILD_DIR_2)/%.o: %.asm
	$(ASM) $(ASMFLAGS) -o $@ $<
	

$(BUILD_DIR_3)/%.o: %.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

clean:
	rm -f $(FILTROS_OBJ_CON_PATH) $(FILTROS_OBJ_CON_PATH_2) $(FILTROS_OBJ_CON_PATH_3)
