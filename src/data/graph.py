import numpy as np
from matplotlib.backends.backend_pdf import PdfPages
import matplotlib.pyplot as plt
from scipy.stats import uniform
import csv as csv
import xlrd
import os
import pandas
import seaborn as sns

O0 = 'C - O0'
O3 = 'C - O3'
ASM = 'ASM - SSE'
algo = 'Algoritmo'
tam = 'Tamaño'
ticks = 'Ticks'
minTam = 4096
maxTam = 262144

plt.rcParams.update({'font.size': 12})

# sizes  =   32*16 512, 64*32 2048, 128*64 8192, 256*128 32768, 400*300 120000, 512*256 131072,
#               800*600 480000, 1600*1200 1920000 

sizes = [512, 2048, 8192, 32768, 120000, 131072, 480000, 1920000]


dicc_model = {'512': [], '2048': [],'8192': [], '32768': [], '120000': [], '131072': [], '480000': [], '1920000': []}

imagen_fantasma_asm = {'512': [], '2048': [], '8192': [], '32768': [
], '120000': [], '131072': [], '480000': [], '1920000': []}
imagen_fantasma_c_O3 = {'512': [], '2048': [], '8192': [], '32768': [
], '120000': [], '131072': [], '480000': [], '1920000': []}
imagen_fantasma_c_O2 = {'512': [], '2048': [], '8192': [], '32768': [
], '120000': [], '131072': [], '480000': [], '1920000': []}
imagen_fantasma_c_O1 = {'512': [], '2048': [], '8192': [], '32768': [
], '120000': [], '131072': [], '480000': [], '1920000': []}
imagen_fantasma_c_O0 = {'512': [], '2048': [], '8192': [], '32768': [
], '120000': [], '131072': [], '480000': [], '1920000': []}

reforzar_brillo_asm = {'512': [], '2048': [], '8192': [], '32768': [
], '120000': [], '131072': [], '480000': [], '1920000': []}
reforzar_brillo_c_O3 = {'512': [], '2048': [],'8192': [], '32768': [], '120000': [], '131072': [], '480000': [], '1920000': []}
reforzar_brillo_c_O2 = {'512': [], '2048': [],'8192': [], '32768': [], '120000': [], '131072': [], '480000': [], '1920000': []}
reforzar_brillo_c_O1 = {'512': [], '2048': [],'8192': [], '32768': [], '120000': [], '131072': [], '480000': [], '1920000': []}
reforzar_brillo_c_O0 = {'512': [], '2048': [],'8192': [], '32768': [], '120000': [], '131072': [], '480000': [], '1920000': []}

colores_bordes_asm = {'512': [], '2048': [],'8192': [], '32768': [], '120000': [], '131072': [], '480000': [], '1920000': []}
colores_bordes_c_O3 = {'512': [], '2048': [],'8192': [], '32768': [], '120000': [], '131072': [], '480000': [], '1920000': []}
colores_bordes_c_O2 = {'512': [], '2048': [],'8192': [], '32768': [], '120000': [], '131072': [], '480000': [], '1920000': []}
colores_bordes_c_O1 = {'512': [], '2048': [],'8192': [], '32768': [], '120000': [], '131072': [], '480000': [], '1920000': []}
colores_bordes_c_O0 = {'512': [], '2048': [],'8192': [], '32768': [], '120000': [], '131072': [], '480000': [], '1920000': []}

## arma diccs de imagen fantasma

with open('ImagenFantasma_asm.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        imagen_fantasma_asm[row[0]].append(int(row[1]))
    file.close()

with open('ImagenFantasma_c_O0.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        imagen_fantasma_c_O0[row[0]].append(int(row[1]))
    file.close()

with open('ImagenFantasma_c_O1.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        imagen_fantasma_c_O1[row[0]].append(int(row[1]))


with open('ImagenFantasma_c_O2.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        imagen_fantasma_c_O2[row[0]].append(int(row[1]))

with open('ImagenFantasma_c_O3.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        imagen_fantasma_c_O3[row[0]].append(int(row[1]))

# ## arma diccs de colores bordes

# imagen_fantasma_asm['512'].sort()
# imagen_fantasma_c_O0['512'].sort()
# print(imagen_fantasma_asm['512'])
# print(imagen_fantasma_c_O0['512'])

if imagen_fantasma_asm['512'] == imagen_fantasma_c_O0['512']:
    print ("Son iguales la concha del mono")
else:
    print("VAMO MANAOSS")


with open('ColorBordes_asm.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        colores_bordes_asm[row[0]].append(int(row[1]))

with open('ColorBordes_c_O0.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        colores_bordes_c_O0[row[0]].append(int(row[1]))

with open('ColorBordes_c_O1.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        colores_bordes_c_O1[row[0]].append(int(row[1]))

with open('ColorBordes_c_O2.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        colores_bordes_c_O2[row[0]].append(int(row[1]))
        
with open('ColorBordes_c_O3.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        colores_bordes_c_O3[row[0]].append(int(row[1]))

## arma diccs de reforzar brillo


with open('ReforzarBrillo_asm.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        reforzar_brillo_asm[row[0]].append(int(row[1]))

with open('ReforzarBrillo_c_O0.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        reforzar_brillo_c_O0[row[0]].append(int(row[1]))

with open('ReforzarBrillo_c_O1.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        reforzar_brillo_c_O1[row[0]].append(int(row[1]))

with open('ReforzarBrillo_c_O2.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        reforzar_brillo_c_O2[row[0]].append(int(row[1]))

with open('ReforzarBrillo_c_O3.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        reforzar_brillo_c_O3[row[0]].append(int(row[1]))

# imagen_fantasma_asm['512'].sort()
# print(imagen_fantasma_asm['512'])
# imagen_fantasma_c_O0['512'].sort()
# print(imagen_fantasma_c_O0['512'])

# hasta aca ya armamos todos los cosos

res_imagen_fantasma_asm = [] 
res_imagen_fantasma_c_O3 = []
res_imagen_fantasma_c_O2 = []
res_imagen_fantasma_c_O1 = []
res_imagen_fantasma_c_O0 = []

res_colores_bordes_asm = []
res_colores_bordes_c_O0 = []
res_colores_bordes_c_O1 = []
res_colores_bordes_c_O2 = []
res_colores_bordes_c_O3 = []

res_reforzar_brillo_asm = [] 
res_reforzar_brillo_c_O3 = []
res_reforzar_brillo_c_O2 = []
res_reforzar_brillo_c_O1 = []
res_reforzar_brillo_c_O0 = []

# def mediana(array):
#     array.sort()
#     #print (array[0])
#     res = array[int(len(array)/2)]
#     #res = array[10]
#     #res = min(array)
#     #print (res)
#     return res

# def armarArrayGraf(dicc, res_clocks):
#     for key in dicc:
#         res_clocks.append(mediana(dicc[key]))
#         #res_clocks.append(dicc[key][0])
        
        
def mediana(array):
    array.sort()
    # res = array[int(len(array)/2)]
    res = min(array)
    #res = array[10]
    #res = min(array)
    #print (res)
    return res


def armarArrayGraf(dicc, res_clocks):
    for key in dicc:
        res_clocks.append(mediana(dicc[key]))
        #res_clocks.append(dicc[key][0])

armarArrayGraf(imagen_fantasma_asm, res_imagen_fantasma_asm)
armarArrayGraf(imagen_fantasma_c_O0, res_imagen_fantasma_c_O0)
armarArrayGraf(imagen_fantasma_c_O1, res_imagen_fantasma_c_O1)
armarArrayGraf(imagen_fantasma_c_O2, res_imagen_fantasma_c_O2)
armarArrayGraf(imagen_fantasma_c_O3, res_imagen_fantasma_c_O3)


#print(colores_bordes_asm)
armarArrayGraf(colores_bordes_asm, res_colores_bordes_asm)
armarArrayGraf(colores_bordes_c_O0, res_colores_bordes_c_O0)
armarArrayGraf(colores_bordes_c_O1, res_colores_bordes_c_O1)
armarArrayGraf(colores_bordes_c_O2, res_colores_bordes_c_O2)
armarArrayGraf(colores_bordes_c_O3, res_colores_bordes_c_O3)

armarArrayGraf(reforzar_brillo_asm, res_reforzar_brillo_asm)
armarArrayGraf(reforzar_brillo_c_O0, res_reforzar_brillo_c_O0)
armarArrayGraf(reforzar_brillo_c_O1, res_reforzar_brillo_c_O1)
armarArrayGraf(reforzar_brillo_c_O2, res_reforzar_brillo_c_O2)
armarArrayGraf(reforzar_brillo_c_O3, res_reforzar_brillo_c_O3)

# # print

data = [200, 400, 600, 800, 1000, 1200, 1400, 1600]

#data2 = [200000, 400000, 600000, 800000, 1000000, 1200000, 1400000, 1600000]


# with PdfPages('imagen_fantasma.pdf') as pdf:
#     #plt.figure(figsize=(7, 5))
#     # print(res_imagen_fantasma_asm)
#     # print(res_imagen_fantasma_c_O0)
#     # print(res_imagen_fantasma_c_O1)
#     # print(res_imagen_fantasma_c_O2)
#     # print(res_imagen_fantasma_c_O3)
#     print(sizes)
#     plt.plot(sizes, res_imagen_fantasma_asm)
#     #plt.axis([0, 1920000, 0, res_imagen_fantasma_asm[7]])
#     plt.plot(sizes, res_imagen_fantasma_c_O0, label="O0")
#     #plt.plot(sizes, res_imagen_fantasma_c_O1, label="O1")
#     #plt.plot(sizes, res_imagen_fantasma_c_O2, label="O2")
#     #plt.plot(sizes, res_imagen_fantasma_c_O3,  label="O3")
#     plt.legend(loc='upper center', shadow=True, fontsize='x-large')
#     print(res_imagen_fantasma_c_O1)
#     print(res_imagen_fantasma_asm)
#     #plt.ticklabel_format(style='plain')

#     #plt.title('Rendimiento')
#     #plt.xlabel('Tamaño')
#     #plt.ylabel('Cantidad de ticks')
#     plt.show()


#     #plt.ticklabel_format(style='plain')


with PdfPages('imagen_fantasma.pdf') as pdf:
    fig, ax = plt.subplots()
    ax.plot(sizes, res_imagen_fantasma_asm, label='ASM')
    #plt.axis([0, 1920000, 0, res_imagen_fantasma_asm[7]])
    ax.plot(sizes, res_imagen_fantasma_c_O0, label="O0")
    ax.plot(sizes, res_imagen_fantasma_c_O1, label="O1")
    ax.plot(sizes, res_imagen_fantasma_c_O2, label="O2")
    ax.plot(sizes, res_imagen_fantasma_c_O3,  label="O3")
    legend = ax.legend(loc='upper right', shadow=True)
    ax.ticklabel_format(style='plain')  
    plt.title('Rendimiento')
    plt.xlabel('Tamaño')
    plt.ylabel('Cantidad de ticks')
    legend.get_frame()
    # pdf.savefig()
    # plt.close()
    plt.show()

with PdfPages('colores_bordes.pdf') as pdf:
    fig, ax = plt.subplots()
    #plt.figure(figsize=(7, 5))
    ax.plot(sizes, res_colores_bordes_asm, label='ASM')
    #plt.axis([0, 1920000, 0, res_colores_bordes_asm[7]])
    ax.plot(sizes, res_colores_bordes_c_O0, label="O0")
    ax.plot(sizes, res_colores_bordes_c_O1, label="O1")
    ax.plot(sizes, res_colores_bordes_c_O2, label="O2")
    ax.plot(sizes, res_colores_bordes_c_O3,  label="O3")
    legend = ax.legend(loc='upper right', shadow=True)
    ax.ticklabel_format(style='plain')
    plt.title('Rendimiento')
    plt.xlabel('Tamaño')
    plt.ylabel('Cantidad de ticks')
    legend.get_frame()
    pdf.savefig()
    plt.close()

with PdfPages('reforzar_brillo.pdf') as pdf:
    fig, ax = plt.subplots()
    #plt.figure(figsize=(7, 5))
    ax.plot(sizes, res_reforzar_brillo_asm, label='ASM')
    #plt.axis([0, 1920000, 0, res_imagen_fantasma_asm[7]])
    ax.plot(sizes, res_reforzar_brillo_c_O0, label="O0")
    ax.plot(sizes, res_reforzar_brillo_c_O1, label="O1")
    ax.plot(sizes, res_reforzar_brillo_c_O2, label="O2")
    ax.plot(sizes, res_reforzar_brillo_c_O3,  label="O3")
    legend = ax.legend(loc='upper right', shadow=True)
    ax.ticklabel_format(style='plain')
    plt.title('Rendimiento')
    plt.xlabel('Tamaño')
    plt.ylabel('Cantidad de ticks')
    legend.get_frame()
    pdf.savefig()
    plt.close()





    
    # plt.plot(res_imagen_fantasma_asm, color='black', linewidth=5)
    # # ax = plt.gca()
    # # ax.get_xaxis().get_major_formatter().set_useOffset(False)
    # #plt.axis([0, 6, 0, 20])
    # #plt.draw()
    # # plt.plot(data, res_imagen_fantasma_c_O0, label="O0")
    # # plt.plot(data, res_imagen_fantasma_c_O1, label="O1")
    # # plt.plot(data, res_imagen_fantasma_c_O2, label="O2")
    # # plt.plot(data, res_imagen_fantasma_c_O3,  label="O3")
    # plt.show()
    
    # g = sns.lmplot(x=tam, y=ticks, data=res_imagen_fantasma_c_O0,hue=algo, col='Conversor', truncate=True, size=7, aspect=0.7)
    # g.set_ylabels('Tiempo en ticks')
    # plt.gca().get_yaxis().get_major_formatter().set_scientific(False)
    # plt.show()
    
    
# with PdfPages('colores_bordes.pdf') as pdf:
#     plt.figure(figsize=(7, 5))
#     plt.plot(res_colores_bordes_asm, res_colores_bordes_c_O1, res_colores_bordes_c_O1, res_colores_bordes_asm, sizes)
#     plt.title('Rendimiento')
#     plt.xlabel('Cantidad de pixeles')
#     plt.ylabel('Cantidad de ticks')
#     pdf.savefig()
#     plt.close()
    
# with PdfPages('reforzar_brillo.pdf') as pdf:
#     plt.figure(figsize=(7, 5))
#     plt.plot(res_reforzar_brillo_asm, res_reforzar_brillo_c_O1, res_reforzar_brillo_c_O1, res_reforzar_brillo_asm, sizes)
#     plt.title('Rendimiento')
#     plt.xlabel('Cantidad de pixeles')
#     plt.ylabel('Cantidad de ticks')
#     pdf.savefig()
#     plt.close()
    


#current_directory = os.getcwd()

# #print (current_directory)
# #filePath = "/home/nahuel/Documents/autolim/ventas.xlsx"

# # filePath = current_directory + "/Ventas.xlsx"
# # openFile = xlrd.open_workbook(filePath)
# # sheet = openFile.sheet_by_name("Ventas AR")

# filePath = current_directory + "/resultados_c_O3.xlsx"
# openFile = xlrd.open_workbook(filePath)
# sheet = openFile.sheet_by_name("resultados_c_O3")


# for i in range(sheet.nrows):

#     cellValue_size = sheet.cell_value(i, 0)
#     cellValue_clock = sheet.cell_value(i, 1)
    
#     sizes.append(cellValue_size)
#     clocks.append(cellValue_clock)
    
# print(clocks)
# print(sizes)
