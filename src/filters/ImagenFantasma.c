#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include "../tp2.h"

void ImagenFantasma_asm (uint8_t *src, uint8_t *dst, int width, int height,
                      int src_row_size, int dst_row_size, int offsetx, int offsety);

void ImagenFantasma_c   (uint8_t *src, uint8_t *dst, int width, int height,
                      int src_row_size, int dst_row_size, int offsetx, int offsety);

typedef void (ImagenFantasma_fn_t) (uint8_t*, uint8_t*, int, int, int, int, int, int);

typedef struct s_imagen_fantasma_params {
	int offsetx, offsety;
} imagen_fantasma_params_t;

imagen_fantasma_params_t extra;

void leer_params_ImagenFantasma(configuracion_t *config, int argc, char *argv[]) {
	config->extra_config = &extra;
    extra.offsetx = atoi(argv[argc - 2]);
    extra.offsety = atoi(argv[argc - 1]);
}

void aplicar_ImagenFantasma(configuracion_t *config)
{
    ImagenFantasma_fn_t *ImagenFantasma = SWITCH_C_ASM( config, ImagenFantasma_c, ImagenFantasma_asm );
    buffer_info_t info = config->src;
    int offsetx = extra.offsetx;
    int offsety = extra.offsety;
    if( offsetx < 0 ) offsetx = 0;
    if( offsety < 0 ) offsety = 0;
    if( offsetx > info.width ) offsetx = info.width/2;
    if( offsety > info.height ) offsety = info.height/2;
    ImagenFantasma(info.bytes, config->dst.bytes, info.width, info.height, 
              info.row_size, config->dst.row_size, offsetx, offsety);
}

void liberar_ImagenFantasma(configuracion_t *config) {

}

void ayuda_ImagenFantasma()
{
    printf ( "       * ImagenFantasma\n" );
    printf ( "           Ejemplo de uso : \n"
             "                         ImagenFantasma -i c facil.bmp <offsetX> <offsetY>\n" );
}

DEFINIR_FILTRO(ImagenFantasma,1)


