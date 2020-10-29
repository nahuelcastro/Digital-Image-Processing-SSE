# ************************************************************************* #
#   Organizacion del Computador II - Trabajo Practico 2                     #
# ************************************************************************* #

CFLAGS64 = -ggdb -Wall -Wno-unused-parameter -Wextra -std=c99 -no-pie -pedantic -m64 -O0 -march=native
CFLAGS64_2 = -ggdb -Wall -Wno-unused-parameter -Wextra -std=c99 -no-pie -pedantic -m64 -O2 -march=native
CFLAGS64_3 = -ggdb -Wall -Wno-unused-parameter -Wextra -std=c99 -no-pie -pedantic -m64 -O3 -march=native
CFLAGS=$(CFLAGS64)
CFLAGS2=$(CFLAGS64_2)
CFLAGS3=$(CFLAGS64_3)

BUILD_DIR = ../build
BUILD_DIR_2 = ../build2
BUILD_DIR_3 = ../build3
BIN = tp2

OBJS          = libbmp.o imagenes.o utils.o
OBJS_CON_PATH = $(addprefix $(BUILD_DIR)/, $(OBJS))
OBJS_CON_PATH_2 = $(addprefix $(BUILD_DIR_2)/, $(OBJS))
OBJS_CON_PATH_3 = $(addprefix $(BUILD_DIR_3)/, $(OBJS))

BMPDIFF       = $(BUILD_DIR)/bmpdiff
BMPDIFF_2     = $(BUILD_DIR_2)/bmpdiff
BMPDIFF_3     = $(BUILD_DIR_3)/bmpdiff

# .PHONY: all clean libbmp bmpdiff

all: $(OBJS_CON_PATH) bmpdiff $(OBJS_CON_PATH_2) bmpdiff2 $(OBJS_CON_PATH_3) bmpdiff3

lib: all

$(BUILD_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<


$(BUILD_DIR_2)/%.o: %.c
	$(CC) $(CFLAGS2) -c -o $@ $<
	
	
$(BUILD_DIR_3)/%.o: %.c
	$(CC) $(CFLAGS3) -c -o $@ $<

bmpdiff: bmpdiff.c $(OBJS_CON_PATH)
	$(CC) $(CFLAGS) bmpdiff.c $(OBJS_CON_PATH) -o $(BMPDIFF)


bmpdiff2: bmpdiff.c $(OBJS_CON_PATH_2)
	$(CC) $(CFLAGS2) bmpdiff.c $(OBJS_CON_PATH_2) -o $(BMPDIFF_2)
	

bmpdiff3: bmpdiff.c $(OBJS_CON_PATH_3)
	$(CC) $(CFLAGS3) bmpdiff.c $(OBJS_CON_PATH_3) -o $(BMPDIFF_3)

clean:
	rm -f $(OBJS_CON_PATH) $(BMPDIFF) $(OBJS_CON_PATH_2) $(BMPDIFF_2) $(OBJS_CON_PATH_3) $(BMPDIFF_3)
