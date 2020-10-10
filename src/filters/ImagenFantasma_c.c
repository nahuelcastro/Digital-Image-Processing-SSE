#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include "../tp2.h"
#include "../helper/utils.h"

void ImagenFantasma_c(
    uint8_t *src,
    uint8_t *dst,
    int width,
    int height,
    int src_row_size,
    int dst_row_size,
    int offsetx,
    int offsety)
{
    bgra_t (*src_matrix)[(src_row_size+3)/4] = (bgra_t (*)[(src_row_size+3)/4]) src;
    bgra_t (*dst_matrix)[(dst_row_size+3)/4] = (bgra_t (*)[(dst_row_size+3)/4]) dst;

    for (int j = 0; j < height; j++) {
        for (int i = 0; i < width; i++) {

            float rr = (float)src_matrix[j][i].r;
            float gg = (float)src_matrix[j][i].g;
            float bb = (float)src_matrix[j][i].b;

            int ii = i/2 + offsetx;
            int jj = j/2 + offsety;

            float rrr = (float)src_matrix[jj][ii].r;
            float ggg = (float)src_matrix[jj][ii].g;
            float bbb = (float)src_matrix[jj][ii].b;

            float b = (rrr + 2 * ggg + bbb)/4;

            dst_matrix[j][i].r = SAT( rr * 0.9 + b/2 );
            dst_matrix[j][i].g = SAT( gg * 0.9 + b/2 );
            dst_matrix[j][i].b = SAT( bb * 0.9 + b/2 );
        }
    }
}
