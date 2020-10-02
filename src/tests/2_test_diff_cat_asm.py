#!/usr/bin/env python3

from termcolor import colored
import subprocess
from libtest import *

if not os.path.exists(TESTINDIR):
    print(colored('ERROR: Debe correr primero el script %s'%(PRIMER_SCRIPT), 'red'))
    exit()

print(colored('Compilando el ejecutable...', 'blue'))
ret = subprocess.run(["make", "-C", "../"])
if ret.returncode!=0:
    print(colored('La compilación falló, intentá correr make desde la raíz del proyecto', 'red'))
    exit()

print(colored('Iniciando test de diferencias ASM vs. la catedra...', 'blue'))

todos_ok = True

archivos = archivos_tests()
for corrida in corridas:
    for imagen in archivos:
        ok = verificar(corrida['filtro'], corrida['params'], corrida['tolerancia'], 'asm', imagen)
        todos_ok = todos_ok and ok

if todos_ok:
    print(colored("Test de filtros finalizados correctamente", 'green'))
else:
    print(colored("se encontraron diferencias en algunas de las imagenes", 'red'))
