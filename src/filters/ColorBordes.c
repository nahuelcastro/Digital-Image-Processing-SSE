#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include "../tp2.h"

void ColorBordes_asm (uint8_t *src, uint8_t *dst, int width, int height,
                      int src_row_size, int dst_row_size);

void ColorBordes_c   (uint8_t *src, uint8_t *dst, int width, int height,
                      int src_row_size, int dst_row_size);

typedef void (ColorBordes_fn_t) (uint8_t*, uint8_t*, int, int, int, int);


void leer_params_ColorBordes(configuracion_t *config, int argc, char *argv[]) {
}

void aplicar_ColorBordes(configuracion_t *config)
{
    ColorBordes_fn_t *ColorBordes = SWITCH_C_ASM( config, ColorBordes_c, ColorBordes_asm );
    buffer_info_t info = config->src;
    ColorBordes(info.bytes, config->dst.bytes, info.width, info.height, 
              info.row_size, config->dst.row_size);
}

void liberar_ColorBordes(configuracion_t *config) {

}

void ayuda_ColorBordes()
{
    printf ( "       * ColorBordes\n" );
    printf ( "           Ejemplo de uso : \n"
             "                         ColorBordes -i c facil.bmp\n" );
}

DEFINIR_FILTRO(ColorBordes,1)


