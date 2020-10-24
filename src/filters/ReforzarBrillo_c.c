#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include "../tp2.h"
#include "../helper/utils.h"

void ReforzarBrillo_c(
    uint8_t *src,
    uint8_t *dst,
    int width,
    int height,
    int src_row_size,
    int dst_row_size,
    int umbralSup,
    int umbralInf,
    int brilloSup,
    int brilloInf)
{
    bgra_t (*src_matrix)[(src_row_size+3)/4] = (bgra_t (*)[(src_row_size+3)/4]) src;
    bgra_t (*dst_matrix)[(dst_row_size+3)/4] = (bgra_t (*)[(dst_row_size+3)/4]) dst;

// BORRAR
//int uSup = 160;
//int uInf = 60;
//int bSup = 50;
//int bInf = 50;
/*
int uSup = 60;
int uInf = 10;
int bSup = 50;
int bInf = 50;
*/

    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {

            int b = (src_matrix[i][j].r + 2*src_matrix[i][j].g + src_matrix[i][j].b)/4;
        
            if ( b > umbralSup ) {
                dst_matrix[i][j].b = SAT(src_matrix[i][j].b+brilloSup);
                dst_matrix[i][j].g = SAT(src_matrix[i][j].g+brilloSup);
                dst_matrix[i][j].r = SAT(src_matrix[i][j].r+brilloSup);
            } else if ( umbralInf > b ) {
                dst_matrix[i][j].b = SAT(src_matrix[i][j].b-brilloInf);
                dst_matrix[i][j].g = SAT(src_matrix[i][j].g-brilloInf);
                dst_matrix[i][j].r = SAT(src_matrix[i][j].r-brilloInf);
            } else {
                dst_matrix[i][j].b = src_matrix[i][j].b;
                dst_matrix[i][j].g = src_matrix[i][j].g;
                dst_matrix[i][j].r = src_matrix[i][j].r;
            }
        }
    }

}
