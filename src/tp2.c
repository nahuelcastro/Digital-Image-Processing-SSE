
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <libgen.h>

#include "tp2.h"
#include "helper/tiempo.h"
#include "helper/libbmp.h"
#include "helper/utils.h"
#include "helper/imagenes.h"

//#include <iostream>
#include <time.h>
// #include "libbmp.h"

// ~~~ seteo de los filtros ~~~

extern filtro_t ColorBordes;
extern filtro_t ImagenFantasma;
extern filtro_t PixeladoDiferencial;
extern filtro_t ReforzarBrillo;

filtro_t filtros[4];

// ~~~ fin de seteo de filtros ~~~

int main( int argc, char** argv ) {

    filtros[0] = ColorBordes;
    filtros[1] = ImagenFantasma;
    filtros[2] = PixeladoDiferencial;
    filtros[3] = ReforzarBrillo;

    configuracion_t config;
    config.dst.width = 0;
    config.bits_src = 32;
    config.bits_dst = 32;

    // //
    // char *filter_name = argv[0];
    // char out_asm[strlen(filter_name) + 9];
    // char out_c[strlen(filter_name) + 8];

    // strcpy(out_asm, filter_name);
    // strcat(out_asm, "_asm.csv");

    // strcpy(out_c, filter_name);
    // strcat(out_c, "_c.csv");
    // //

    procesar_opciones(argc, argv, &config);


    // Imprimo info
    if (!config.nombre) {
        // printf ( "Procesando...\n");
        // printf ( "  Filtro             : %s\n", config.nombre_filtro);
        // printf ( "  Implementación     : %s\n", C_ASM( (&config) ) );
        // printf ( "  Archivo de entrada : %s\n", config.archivo_entrada);
    }

    snprintf(config.archivo_salida, sizeof  (config.archivo_salida), "%s/%s.%s.%s%s.bmp",
            config.carpeta_salida, basename(config.archivo_entrada),
            config.nombre_filtro,  C_ASM( (&config) ), config.extra_archivo_salida );

    if (config.nombre) {
        printf("%s\n", basename(config.archivo_salida));
        return 0;
    }

    filtro_t *filtro = detectar_filtro(&config);

    for (size_t i = 0; i < 1; i++)
    {

        filtro->leer_params(&config, argc, argv);
        long before = clock();
        correr_filtro_imagen(&config, filtro->aplicador, argc, argv);
        long after = clock();
        filtro->liberar(&config);

        double cant_clocks = (double)(after - before);
        double elapsed = (double)(after - before)/CLOCKS_PER_SEC;
        printf(" # Clocks: %lf\n", cant_clocks);
        printf(" # Tiempo tomando con clock(), y dividendo con C_P_S: %lf\n\n", elapsed);


    }

    return 0;
}


filtro_t* detectar_filtro(configuracion_t *config) {
    for (int i = 0; filtros[i].nombre != 0; i++) {
        if (strcmp(config->nombre_filtro, filtros[i].nombre) == 0)
            return &filtros[i];
    }
    fprintf(stderr, "Filtro '%s' desconocido\n", config->nombre_filtro);
    exit(EXIT_FAILURE);
    return NULL;
}

void imprimir_tiempos_ejecucion(unsigned long long int start, unsigned long long int end, int cant_iteraciones, int argc, char **argv, long bmp_size_px, configuracion_t *config)
{
    unsigned long long int cant_ciclos = end - start;

    // printf("Tiempo de ejecución:\n");
    // printf("  Comienzo                          : %llu\n", start);
    //printf("  Fin                               : %llu\n", end);
    // printf("  # iteraciones                     : %d\n", cant_iteraciones);
    printf("  # de ciclos insumidos totales     : %llu\n", cant_ciclos);
    printf("  # de ciclos insumidos por llamada : %.3f\n", (float)cant_ciclos/(float)cant_iteraciones);
    //cout << "CLOCKS_PER_SEC = " << CLOCKS_PER_SEC << "\n";
    printf(" # clocks por sec : %lu\n", CLOCKS_PER_SEC);
    float f = (float)cant_ciclos/(float)cant_iteraciones;
    float t = f/(float)CLOCKS_PER_SEC;
    printf(" # Tiempo cant_ciclos_catedra/CLOCKS_PER_SEC : %3.f\n\n", t);



//              OPCION 1

    char *filter_name = config->nombre_filtro;

    char out_asm[strlen(filter_name) + 9];
    char out_c[strlen(filter_name) + 10];

    strcpy(out_asm, filter_name);
    strcat(out_asm, "_asm.csv");

    strcpy(out_c, filter_name);
    strcat(out_c, "_c_O3.csv");
    //


    if (strcmp(argv[2], "asm") == 0)
    {
        // FILE *output_asm = fopen("prueba_asm.csv", "a");
        FILE *output_asm = fopen(out_asm, "a");
        fprintf(output_asm, "%ld, %llu\n", bmp_size_px, cant_ciclos);
    }

    if  (strcmp(argv[2], "c") == 0)
    {
        FILE *output_c = fopen(out_c, "a");
        fprintf(output_c, "%ld, %llu\n", bmp_size_px, cant_ciclos);
    }
}


// //                  OPCION 2

//     if (strcmp(argv[2], "asm") == 0)
//     {
//         // FILE *output_asm = fopen("prueba_asm.csv", "a");
//         FILE *output_asm = fopen("../data/resultados_asm.csv", "a");
//         fprintf(output_asm, "%ld, %llu\n", bmp_size_px, cant_ciclos);
//     }

//     if (strcmp(argv[2], "c") == 0)
//     {
//         FILE *output_c = fopen("../data/resultados_c_O3.csv", "a");
//         fprintf(output_c, "%ld, %llu\n", bmp_size_px, cant_ciclos);
//     }

void correr_filtro_imagen(configuracion_t *config, aplicador_fn_t aplicador, int argc, char **argv)
{
    imagenes_abrir(config);

    unsigned long long start, end;

    imagenes_flipVertical(&config->src, src_img);
    imagenes_flipVertical(&config->dst, dst_img);
    if(config->archivo_entrada_2 != 0) {
        imagenes_flipVertical(&config->src_2, src_img2);
    }
    MEDIR_TIEMPO_START(start)
    for (int i = 0; i < config->cant_iteraciones; i++) {
            aplicador(config);
    }
    MEDIR_TIEMPO_STOP(end)
    imagenes_flipVertical(&config->dst, dst_img);

    imagenes_guardar(config);
    imagenes_liberar(config);



    buffer_info_t* srcc = &config->src;
    uint32_t width = srcc->width;
    uint32_t height = srcc->height;
    long int px_size = (long int)width * height;
    imprimir_tiempos_ejecucion(start, end, config->cant_iteraciones, argc, argv, px_size, config);

}
