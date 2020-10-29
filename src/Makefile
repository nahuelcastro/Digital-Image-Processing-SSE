# ************************************************************************* #
#   Organizacion del Computador II - Trabajo Practico 2                     #
# ************************************************************************* #

CFLAGS64 = -ggdb -Wall -Wno-unused-parameter -Wextra -std=c99 -no-pie -pedantic -m64 -O0 -march=native
CFLAGS64_2 = -ggdb -Wall -Wno-unused-parameter -Wextra -std=c99 -no-pie -pedantic -m64 -O2 -march=native
CFLAGS64_3 = -ggdb -Wall -Wno-unused-parameter -Wextra -std=c99 -no-pie -pedantic -m64 -O3 -march=native
CFLAGS=$(CFLAGS64)
CFLAGS2=$(CFLAGS64_2)
CFLAGS3=$(CFLAGS64_3)

BUILD_DIR = build
BUILD_DIR_2 = build2
BUILD_DIR_3 = build3
BIN = tp2

FILTROS = ColorBordes ImagenFantasma PixeladoDiferencial ReforzarBrillo

FILTROS_OBJ = $(addsuffix .o, $(FILTROS)) $(addsuffix _asm.o, $(FILTROS)) $(addsuffix _c.o, $(FILTROS))
LIBS_OBJS   = libbmp.o imagenes.o utils.o
MAIN_OBJS   = tp2.o cli.o
MAIN_OBJS_CON_PATH = $(addprefix $(BUILD_DIR)/, $(MAIN_OBJS)) 
MAIN_OBJS_CON_PATH_2 = $(addprefix $(BUILD_DIR_2)/, $(MAIN_OBJS)) 
MAIN_OBJS_CON_PATH_3 = $(addprefix $(BUILD_DIR_3)/, $(MAIN_OBJS))

OBJS = $(MAIN_OBJS) $(LIBS_OBJS) $(FILTROS_OBJ)
OBJS_CON_PATH = $(addprefix $(BUILD_DIR)/, $(OBJS))
OBJS_CON_PATH_2 = $(addprefix $(BUILD_DIR_2)/, $(OBJS))
OBJS_CON_PATH_3 = $(addprefix $(BUILD_DIR_3)/, $(OBJS))

.PHONY: all clean FORCE

all: $(BUILD_DIR)/$(BIN) $(BUILD_DIR_2)/$(BIN) $(BUILD_DIR_3)/$(BIN)

$(BUILD_DIR)/$(BIN): FORCE $(MAIN_OBJS_CON_PATH) 
	$(CC) $(CFLAGS) $(OBJS_CON_PATH) -o $@ -lm
	
$(BUILD_DIR_2)/$(BIN): FORCE $(MAIN_OBJS_CON_PATH_2) 
	$(CC) $(CFLAGS2) $(OBJS_CON_PATH_2) -o $@ -lm
	
$(BUILD_DIR_3)/$(BIN): FORCE $(MAIN_OBJS_CON_PATH_3)	
	$(CC) $(CFLAGS3) $(OBJS_CON_PATH_3) -o $@ -lm

export CFLAGS64
FORCE:
	mkdir -p build
	make -C helper
	make -C filters

$(BUILD_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $< -lm


$(BUILD_DIR_2)/%.o: %.c
	$(CC) $(CFLAGS2) -c -o $@ $< -lm
	
	
$(BUILD_DIR_3)/%.o: %.c
	$(CC) $(CFLAGS3) -c -o $@ $< -lm

clean:
	rm -fr $(BUILD_DIR)/* $(BUILD_DIR_2)/* $(BUILD_DIR_3)/*



