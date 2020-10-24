#include <limits.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <libgen.h>
#include <string.h>

#include "helper/tiempo.h"
#include "helper/libbmp.h"
#include "helper/utils.h"
#include "helper/imagenes.h"

#define REPETITIONS 100


extern filtro_t ColorBordes;
extern filtro_t ImagenFantasma;
extern filtro_t PixeladoDiferencial;
extern filtro_t ReforzarBrillo;

filtro_t filtros[4];


filtro_t *detectar_filtro(configuracion_t *config)
{
    for (int i = 0; filtros[i].nombre != 0; i++)
    {
        if (strcmp(config->nombre_filtro, filtros[i].nombre) == 0)
            return &filtros[i];
    }
    fprintf(stderr, "Filtro '%s' desconocido\n", config->nombre_filtro);
    exit(EXIT_FAILURE);
    return NULL;
}

void imprimir_tiempos_ejecucion(unsigned long long int start, unsigned long long int end, int cant_iteraciones, FILE *output)
{
    unsigned long long int cant_ciclos = end - start;

    //printf("Tiempo de ejecución:\n");
    //printf("  Comienzo                          : %llu\n", start);
    //printf("  Fin                               : %llu\n", end);
    //printf("  # iteraciones                     : %d\n", cant_iteraciones);
    printf(/*"# de ciclos insumidos totales     :*/ "%llu", cant_ciclos);
    //printf("  # de ciclos insumidos por llamada : %.3f\n", (float)cant_ciclos/(float)cant_iteraciones);
    fprintf(output, "%llu", cant_ciclos);
}

void correr_filtro_imagen(configuracion_t *config, aplicador_fn_t aplicador, FILE *fp)
{
    imagenes_abrir(config);

    unsigned long long start, end;

    imagenes_flipVertical(&config->src, src_img);
    imagenes_flipVertical(&config->dst, dst_img);
    if (config->archivo_entrada_2 != 0)
    {
        imagenes_flipVertical(&config->src_2, src_img2);
    }
    MEDIR_TIEMPO_START(start)
    for (int i = 0; i < config->cant_iteraciones; i++)
    {
        aplicador(config);
    }
    MEDIR_TIEMPO_STOP(end)
    imagenes_flipVertical(&config->dst, dst_img);

    imagenes_guardar(config);
    imagenes_liberar(config);
    imprimir_tiempos_ejecucion(start, end, config->cant_iteraciones, fp);
}


int main(int argc, char **argv)
{


    filtros[0] = ColorBordes; 
    filtros[1] = ImagenFantasma;
    filtros[2] = PixeladoDiferencial;
    filtros[3] = ReforzarBrillo;

    configuracion_t config;
    config.dst.width = 0;
    config.bits_src = 32;
    config.bits_dst = 32;

    procesar_opciones(argc, argv, &config);

    filtro_t *filtro = detectar_filtro(&config);

    FILE *output = fopen("resultadosEpicos.csv", "a");
    for (int i = 0; i < REPETITIONS; ++i)
    {
        filtro->leer_params(&config, argc, argv);
        correr_filtro_imagen(&config, filtro->aplicador, output);
        filtro->liberar(&config);
    }
    fclose(output);

    return 0;
}