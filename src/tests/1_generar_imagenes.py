#!/usr/bin/env python3

from libtest import *
import subprocess
import sys

# Este script crea las multiples imagenes de prueba a partir de unas
# pocas imagenes base.

IMAGENES=["Misery.bmp","SweetNovember.bmp"]

assure_dirs()

sizes=['400x300', '800x600', '1600x1200', '512x256', '256x128', '128x64', '64x32', '32x16']

for filename in IMAGENES:
	print(filename)
	for size in sizes:
		sys.stdout.write("  " + size)
		name = filename.split('.')
		file_in  = DATADIR + "/" + filename
		file_out = TESTINDIR + "/" + name[0] + "." + size + "." + name[1]
		resize = "convert -resize " + size + "! " + file_in + " " + file_out
		subprocess.call(resize, shell=True)
	print("")
