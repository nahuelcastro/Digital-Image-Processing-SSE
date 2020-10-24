#!/bin/bash
echo HOLITAS

cd build/


 for i in {0..50}
 do
     ./tp2 ImagenFantasma -i asm ../img/SweetNovember.32x16.bmp 30 15 
     ./tp2 ColorBordes -i asm ../img/SweetNovember.32x16.bmp 
     ./tp2 ReforzarBrillo -i asm ../img/SweetNovember.32x16.bmp 35 50 60 20
 done
 for i in {0..50}
 do
     ./tp2 ImagenFantasma -i asm ../img/SweetNovember.64x32.bmp 30 15 
     ./tp2 ColorBordes -i asm ../img/SweetNovember.64x32.bmp 
     ./tp2 ReforzarBrillo -i asm ../img/SweetNovember.64x32.bmp 35 50 60 20
 done
 for i in {0..50}
 do
     ./tp2 ImagenFantasma -i asm ../img/SweetNovember.128x64.bmp 30 15 
     ./tp2 ColorBordes -i asm ../img/SweetNovember.128x64.bmp 
     ./tp2 ReforzarBrillo -i asm ../img/SweetNovember.128x64.bmp 35 50 60 20
 done
 for i in {0..50}
 do
     ./tp2 ImagenFantasma -i asm ../img/SweetNovember.256x128.bmp 30 15 
     ./tp2 ColorBordes -i asm ../img/SweetNovember.256x128.bmp 
     ./tp2 ReforzarBrillo -i asm ../img/SweetNovember.256x128.bmp 35 50 60 20
 done
 for i in {0..50}
 do
     ./tp2 ImagenFantasma -i asm ../img/SweetNovember.400x300.bmp 30 15 
     ./tp2 ColorBordes -i asm ../img/SweetNovember.400x300.bmp 
     ./tp2 ReforzarBrillo -i asm ../img/SweetNovember.400x300.bmp 35 50 60 20
 done
 for i in {0..50}
 do
     ./tp2 ImagenFantasma -i asm ../img/SweetNovember.512x256.bmp 30 15 
     ./tp2 ColorBordes -i asm ../img/SweetNovember.512x256.bmp 
     ./tp2 ReforzarBrillo -i asm ../img/SweetNovember.512x256.bmp 35 50 60 20
 done
 for i in {0..50}
 do
     ./tp2 ImagenFantasma -i asm ../img/SweetNovember.800x600.bmp 30 15 
     ./tp2 ColorBordes -i asm ../img/SweetNovember.800x600.bmp 
     ./tp2 ReforzarBrillo -i asm ../img/SweetNovember.800x600.bmp 35 50 60 20
 done
 for i in {0..50}
 do
     ./tp2 ImagenFantasma -i asm ../img/SweetNovember.1600x1200.bmp 30 15 
     ./tp2 ColorBordes -i asm ../img/SweetNovember.1600x1200.bmp 
     ./tp2 ReforzarBrillo -i asm ../img/SweetNovember.1600x1200.bmp 35 50 60 20
 done


# c 

for i in {0..50}
do
    ./tp2 ImagenFantasma -i c ../img/SweetNovember.32x16.bmp 30 15 
    ./tp2 ColorBordes -i c ../img/SweetNovember.32x16.bmp 
    ./tp2 ReforzarBrillo -i c ../img/SweetNovember.32x16.bmp 35 50 60 20
done

for i in {0..50}
do
    ./tp2 ImagenFantasma -i c ../img/SweetNovember.64x32.bmp 30 15 
    ./tp2 ColorBordes -i c ../img/SweetNovember.64x32.bmp 
    ./tp2 ReforzarBrillo -i c ../img/SweetNovember.64x32.bmp 35 50 60 20
done


for i in {0..50}
do
    ./tp2 ImagenFantasma -i c ../img/SweetNovember.128x64.bmp 30 15 
    ./tp2 ColorBordes -i c ../img/SweetNovember.128x64.bmp 
    ./tp2 ReforzarBrillo -i c ../img/SweetNovember.128x64.bmp 35 50 60 20
done

for i in {0..50}
do
    ./tp2 ImagenFantasma -i c ../img/SweetNovember.256x128.bmp 30 15 
    ./tp2 ColorBordes -i c ../img/SweetNovember.256x128.bmp 
    ./tp2 ReforzarBrillo -i c ../img/SweetNovember.256x128.bmp 35 50 60 20
done

for i in {0..50}
do
    ./tp2 ImagenFantasma -i c ../img/SweetNovember.400x300.bmp 30 15 
    ./tp2 ColorBordes -i c ../img/SweetNovember.400x300.bmp 
    ./tp2 ReforzarBrillo -i c ../img/SweetNovember.400x300.bmp 35 50 60 20
done


for i in {0..50}
do
    ./tp2 ImagenFantasma -i c ../img/SweetNovember.512x256.bmp 30 15 
    ./tp2 ColorBordes -i c ../img/SweetNovember.512x256.bmp 
    ./tp2 ReforzarBrillo -i c ../img/SweetNovember.512x256.bmp 35 50 60 20
done

for i in {0..50}
do
    ./tp2 ImagenFantasma -i c ../img/SweetNovember.800x600.bmp 30 15 
    ./tp2 ColorBordes -i c ../img/SweetNovember.800x600.bmp 
    ./tp2 ReforzarBrillo -i c ../img/SweetNovember.800x600.bmp 35 50 60 20
done

for i in {0..50}
do
    ./tp2 ImagenFantasma -i c ../img/SweetNovember.1600x1200.bmp 30 15 
    ./tp2 ColorBordes -i c ../img/SweetNovember.1600x1200.bmp 
    ./tp2 ReforzarBrillo -i c ../img/SweetNovember.1600x1200.bmp 35 50 60 20
done


# chmod +x ./generar_csv.sh
#SweetNovember.32x16.bmp
