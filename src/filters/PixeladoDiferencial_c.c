#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include "../tp2.h"
#include "../helper/utils.h"

void PixeladoDiferencial_c(
    uint8_t *src,
    uint8_t *dst,
    int width,
    int height,
    int src_row_size,
    int dst_row_size,
    int limit)
{
    bgra_t (*src_matrix)[(src_row_size+3)/4] = (bgra_t (*)[(src_row_size+3)/4]) src;
    bgra_t (*dst_matrix)[(dst_row_size+3)/4] = (bgra_t (*)[(dst_row_size+3)/4]) dst;

    for (int j = 0; j <= height-4; j=j+4) {
        for (int i = 0; i <= width-4; i=i+4) {

            int r = 0;
            int g = 0;
            int b = 0;

            // (1) Promedio de pixeles
	        for (int jj = j; jj < j+4; jj++) {
	            for (int ii = i; ii < i+4; ii++) {
	                r = r + src_matrix[jj][ii].r;
	                g = g + src_matrix[jj][ii].g;
	                b = b + src_matrix[jj][ii].b;
	            }
            }
            b = SAT(b/16);
            g = SAT(g/16);
            r = SAT(r/16);

            // (2) Calculo de diferencia
            int value = 0;
            for (int jj = j; jj < j+4; jj++) {
	            for (int ii = i; ii < i+4; ii++) {
                    value =+ abs(r - src_matrix[jj][ii].r) +
                             abs(g - src_matrix[jj][ii].g) +
	                         abs(b - src_matrix[jj][ii].b);
	            }
            }

            // (3) Aplicacion segun umbral
            if ( value < limit ) {
                for (int jj = j; jj < j+4; jj++) {
                    for (int ii = i; ii < i+4; ii++) {
                        dst_matrix[jj][ii].b = src_matrix[jj][ii].b;
                        dst_matrix[jj][ii].g = src_matrix[jj][ii].g;
                        dst_matrix[jj][ii].r = src_matrix[jj][ii].r;
                    }
                }
            } else {
                for (int jj = j; jj < j+4; jj++) {
                    for (int ii = i; ii < i+4; ii++) {
                        dst_matrix[jj][ii].b = b;
                        dst_matrix[jj][ii].g = g;
                        dst_matrix[jj][ii].r = r;
                    }
                }
            }
        }
    }
}
