#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include "../tp2.h"

void ReforzarBrillo_asm (uint8_t *src, uint8_t *dst, int width, int height,
                      int src_row_size, int dst_row_size, int umbralSup, int umbralInf, int brilloSup, int brilloInf);

void ReforzarBrillo_c   (uint8_t *src, uint8_t *dst, int width, int height,
                      int src_row_size, int dst_row_size, int umbralSup, int umbralInf, int brilloSup, int brilloInf);

typedef void (ReforzarBrillo_fn_t) (uint8_t*, uint8_t*, int, int, int, int, int, int, int, int);

typedef struct s_reforzar_brillo_params {
	int umbralSup, umbralInf, brilloSup, brilloInf;
} reforzar_brillo_params_t;

reforzar_brillo_params_t extra;

void leer_params_ReforzarBrillo(configuracion_t *config, int argc, char *argv[]) {
	config->extra_config = &extra;
    extra.brilloInf = atoi(argv[argc - 1]);
    extra.brilloSup = atoi(argv[argc - 2]);
    extra.umbralInf = atoi(argv[argc - 3]);
    extra.umbralSup = atoi(argv[argc - 4]);
}

void aplicar_ReforzarBrillo(configuracion_t *config)
{
    ReforzarBrillo_fn_t *ReforzarBrillo = SWITCH_C_ASM( config, ReforzarBrillo_c, ReforzarBrillo_asm );
    buffer_info_t info = config->src;
    ReforzarBrillo(info.bytes, config->dst.bytes, info.width, info.height, 
              info.row_size, config->dst.row_size,
              extra.umbralSup, extra.umbralInf, extra.brilloSup, extra.brilloInf);
}

void liberar_ReforzarBrillo(configuracion_t *config) {

}

void ayuda_ReforzarBrillo()
{
    printf ( "       * ReforzarBrillo\n" );
    printf ( "           Ejemplo de uso : \n"
             "                         ReforzarBrillo -i c facil.bmp <umbralSup> <umbralInf> <brilloSup> <brilloInf>\n" );
}

DEFINIR_FILTRO(ReforzarBrillo,1)


