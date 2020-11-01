
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <libgen.h>

#include "tp2.h"
#include "helper/tiempo.h"
#include "helper/libbmp.h"
#include "helper/utils.h"
#include "helper/imagenes.h"

// ~~~ seteo de los filtros ~~~

extern filtro_t ColorBordes;
extern filtro_t ImagenFantasma;
extern filtro_t PixeladoDiferencial;
extern filtro_t ReforzarBrillo;

filtro_t filtros[4];

// ~~~ fin de seteo de filtros ~~~

void newCorrerFiltro(configuracion_t *config, aplicador_fn_t aplicador, int cant);

int main( int argc, char** argv ) {

    filtros[0] = ColorBordes; 
    filtros[1] = ImagenFantasma;
    filtros[2] = PixeladoDiferencial;
    filtros[3] = ReforzarBrillo;

    configuracion_t config;
    config.dst.width = 0;
    config.bits_src = 32;
    config.bits_dst = 32;

    procesar_opciones(argc, argv, &config);
    
    // Imprimo info
    if (!config.nombre) {
        printf ( "Procesando...\n");
        printf ( "  Filtro             : %s\n", config.nombre_filtro);
        printf ( "  Implementación     : %s\n", C_ASM( (&config) ) );
        printf ( "  Archivo de entrada : %s\n", config.archivo_entrada);
    }

    snprintf(config.archivo_salida, sizeof  (config.archivo_salida), "%s/%s.%s.%s%s.bmp",
            config.carpeta_salida, basename(config.archivo_entrada),
            config.nombre_filtro,  C_ASM( (&config) ), config.extra_archivo_salida );

    if (config.nombre) {
        printf("%s\n", basename(config.archivo_salida));
        return 0;
    }


    filtro_t *filtro = detectar_filtro(&config);

    filtro->leer_params(&config, argc, argv);
<<<<<<< HEAD
    int corridas = 10;
=======
    int corridas = 150;
>>>>>>> 313e6e48776a261299b07452c683286cac37bc0e
    newCorrerFiltro(&config, filtro->aplicador, corridas);
    
    //correr_filtro_imagen(&config, filtro->aplicador);
    filtro->liberar(&config);

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

void imprimir_tiempos_ejecucion(unsigned long long int start, unsigned long long int end, int cant_iteraciones) {
    unsigned long long int cant_ciclos = end-start;

    printf("Tiempo de ejecución:\n");
    printf("  Comienzo                          : %llu\n", start);
    printf("  Fin                               : %llu\n", end);
    printf("  # iteraciones                     : %d\n", cant_iteraciones);
    printf("  # de ciclos insumidos totales     : %llu\n", cant_ciclos);
    printf("  # de ciclos insumidos por llamada : %.3f\n", (float)cant_ciclos/(float)cant_iteraciones);
}

void correr_filtro_imagen(configuracion_t *config, aplicador_fn_t aplicador) {
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
    imprimir_tiempos_ejecucion(start, end, config->cant_iteraciones);
}

void creadorCsv(unsigned long long int start, unsigned long long int end, int cant_iteraciones, FILE* file, configuracion_t *config, void* type) {
    
    unsigned long long int cant_ciclos = end-start;
    int time = end-start;
    fprintf(file, "%s,%s,%d,%d,%lli\n", config->nombre_filtro, type, config->src.width*config->src.height, time, cant_ciclos);
}

void newCorrerFiltro(configuracion_t *config, aplicador_fn_t aplicador, int cant) {
    void* type;
    if(config->tipo_filtro==0){
        type= "C";
    }else{
        type="ASM";
    }
    // Reemplazar si quiero distinto
    // if(config->tipo_filtro==1){
    //     type="ASM";
    // }else{
    //     char path[100];
    //     char str1[100] = "/home/maximo/Desktop/Facu/facu/Orga2/TP2/TP2-Orga-2/src/build\0";
    //     char str2[100] = "/home/maximo/Desktop/Facu/facu/Orga2/TP2/TP2-Orga-2/src/build2\0";
    //     char str3[100] = "/home/maximo/Desktop/Facu/facu/Orga2/TP2/TP2-Orga-2/src/build3\0";
    //     getcwd(path,100);
    //     printf("%s",path);
    //     if(strchr(path,48)){
    //         type="C0";
    //     }else if (strchr(path,51)){
    //         type="C3";
    //     }else{
    //         type="C2";
    //     }
    // }
    // printf(type);

    imagenes_abrir(config);
    void* nombre = config->nombre_filtro;
    char filtro[30];
    strcpy(filtro, nombre);
    strcat(filtro, ".csv");
    //char path[100] = "../";
    //strcat(path, filtro);
    FILE* file = fopen(filtro, "a");
    printf("A new correr llegó \n");
    
    unsigned long long start, end;

    //fprintf(file, "Filtro,Implementacion,Tamaño,Ciclos,Tiempo\n"); Agregarselo manualmente, sino se imprime con cada tamaño
    imagenes_guardar(config);
    for (int i = 0; i < cant; i++)
    {
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

        creadorCsv(start, end, config->cant_iteraciones, file, config, type);
    }
    imagenes_liberar(config);
    fclose(file);
    
}

