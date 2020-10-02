#!/bin/bash

# Este script ejecuta su implementacion y chequea memoria

DATADIR=./data
TESTINDIR=$DATADIR/imagenes_a_testear
CATEDRADIR=$DATADIR/resultados_catedra
ALUMNOSDIR=$DATADIR/resultados_nuestros

IMAGENES=(Misery.bmp SweetNovember.bmp)
SIZESMEM=(128x64 64x32 32x16)

TP2CAT=./tp2catedra
TP2ALU=../build/tp2

# Colores
ROJO="\e[31m"
VERDE="\e[32m"
AZUL="\e[94m"
DEFAULT="\e[39m"

img0=${IMAGENES[0]}
img0=${img0%%.*}

VALGRINDFLAGS="--error-exitcode=1 --leak-check=full -q"

#$1 : Programa Ejecutable
#$2 : Filtro
#$3 : Implementacion Ejecutar
#$4 : Archivos de Entrada
#$5 : Parametros del filtro
function run_test {
    echo -e "dale con... $VERDE $2 $DEFAULT"
    valgrind $VALGRINDFLAGS $1 $2 -i $3 -o $ALUMNOSDIR $4 $5
    if [ $? -ne 0 ]; then
      echo -e "$ROJO ERROR DE MEMORIA";
      echo -e "$AZUL Corregir errores en $2. Ver de probar la imagen $3, que se rompe.";
      echo -e "$AZUL Correr nuevamente $DEFAULT valgrind --leak-check=full $1 $2 -i $3 -o $ALUMNOSDIR $4 $5";
      ret=-1; return;
    fi
    ret=0; return;
}

for imp in asm; do

  for s in ${SIZESMEM[*]}; do
    run_test "$TP2ALU" "ColorBordes" "$imp" "$TESTINDIR/$img0.$s.bmp" ""
    if [ $ret -ne 0 ]; then exit -1; fi
  done

  for s in ${SIZESMEM[*]}; do
    run_test "$TP2ALU" "ImagenFantasma" "$imp" "$TESTINDIR/$img0.$s.bmp" "1 1"
    if [ $ret -ne 0 ]; then exit -1; fi
  done

  for s in ${SIZESMEM[*]}; do
    run_test "$TP2ALU" "PixeladoDiferencial" "$imp" "$TESTINDIR/$img0.$s.bmp" "50"
    if [ $ret -ne 0 ]; then exit -1; fi
  done
  
  for s in ${SIZESMEM[*]}; do
    run_test "$TP2ALU" "PixeladoDiferencial" "$imp" "$TESTINDIR/$img0.$s.bmp" "100 50 50 50"
    if [ $ret -ne 0 ]; then exit -1; fi
  done

done

echo ""
echo -e "$VERDE Felicitaciones los test de MEMORIA finalizaron correctamente $DEFAULT"

