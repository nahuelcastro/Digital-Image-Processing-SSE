#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include "../tp2.h"

void PixeladoDiferencial_asm (uint8_t *src, uint8_t *dst, int width, int height,
                      int src_row_size, int dst_row_size, int limit);

void PixeladoDiferencial_c   (uint8_t *src, uint8_t *dst, int width, int height,
                      int src_row_size, int dst_row_size, int limit);

typedef void (PixeladoDiferencial_fn_t) (uint8_t*, uint8_t*, int, int, int, int, int);

typedef struct s_pixelado_diferencial_params {
	int limit;
} pixelado_diferencial_params_t;

pixelado_diferencial_params_t extra;

void leer_params_PixeladoDiferencial(configuracion_t *config, int argc, char *argv[]) {
	config->extra_config = &extra;
    extra.limit = atoi(argv[argc - 1]);
}

void aplicar_PixeladoDiferencial(configuracion_t *config)
{
    PixeladoDiferencial_fn_t *PixeladoDiferencial = SWITCH_C_ASM( config, PixeladoDiferencial_c, PixeladoDiferencial_asm );
    buffer_info_t info = config->src;
    PixeladoDiferencial(info.bytes, config->dst.bytes, info.width, info.height, 
              info.row_size, config->dst.row_size, extra.limit);
}

void liberar_PixeladoDiferencial(configuracion_t *config) {

}

void ayuda_PixeladoDiferencial()
{
    printf ( "       * PixeladoDiferencial\n" );
    printf ( "           Ejemplo de uso : \n"
             "                         PixeladoDiferencial -i c facil.bmp <limit>\n" );
}

DEFINIR_FILTRO(PixeladoDiferencial,1)


