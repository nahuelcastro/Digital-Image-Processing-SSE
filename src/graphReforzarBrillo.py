import pandas as pd           ###librería para manipular tablas de datos
import seaborn as sns         ###librería para hacer gráficos
import numpy as np            ###librería de cálculo numérico
from scipy import stats       ###librería de estadística
import seaborn_qqplot as sqp  ###librería complementaria a seaborn para hacer qqplots
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages


reforzarBrilloC0 = pd.read_csv(
    'data/csv_originales/3/build/ReforzarBrillo.csv', header=None, sep=',')
reforzarBrilloC2 = pd.read_csv('data/csv_originales/ReforzarVertical/ReforzarBrillo.csv', header=None, sep=',')
reforzarBrilloC3 = pd.read_csv(
    'data/csv_originales/3/build3/ReforzarBrillo.csv', header=None, sep=',')
# reforzarBrilloC3 = pd.read_csv(
#     'data/csv_originales/3/build3/ReforzarBrillo.csv', header=None, sep=',')
tamaños = np.array([512,2048,8192,32768,120000,131072,480000,1920000])
tamañosASM = {"512":[],"2048":[],"8192":[],"32768":[],"120000":[],"131072":[],"480000":[],"1920000":[]}
tamañosC0 = {"512":[],"2048":[],"8192":[],"32768":[],"120000":[],"131072":[],"480000":[],"1920000":[]}
tamañosC2 = {"512":[],"2048":[],"8192":[],"32768":[],"120000":[],"131072":[],"480000":[],"1920000":[]}
tamañosC3 = {"512":[],"2048":[],"8192":[],"32768":[],"120000":[],"131072":[],"480000":[],"1920000":[]}

implementacion=1
tamaño=2
ciclos=3
for index, row in reforzarBrilloC0.iterrows():
    if row[implementacion]=="ASM":
        tamañosASM[str(row[tamaño])].append(row[ciclos])
    else:
        tamañosC0[str(row[tamaño])].append(row[ciclos])

for index, row in reforzarBrilloC2.iterrows():
    if row[implementacion]=="ASM":
        tamañosC2[str(row[tamaño])].append(row[ciclos])
    
for index, row in reforzarBrilloC3.iterrows():
    if row[implementacion]=="C":
        tamañosC3[str(row[tamaño])].append(row[ciclos])


resASM=[]
resC0=[]
resC2=[]
resC3=[]

for index, x in enumerate(tamañosC0):
    snsArray = pd.Series(tamañosC0[x])
    tamañosC0[x] = snsArray[snsArray.between(snsArray.quantile(.10), snsArray.quantile(.90))]

for index, x in enumerate(tamañosC2):
    snsArray = pd.Series(tamañosC2[x])
    tamañosC2[x] = snsArray[snsArray.between(snsArray.quantile(.10), snsArray.quantile(.90))]

for index, x in enumerate(tamañosC3):
    snsArray = pd.Series(tamañosC3[x])
    tamañosC3[x] = snsArray[snsArray.between(snsArray.quantile(.10), snsArray.quantile(.90))]


for index, x in enumerate(tamañosASM):
    snsArray = pd.Series(tamañosASM[x])
    tamañosASM[x] = snsArray[snsArray.between(snsArray.quantile(.10), snsArray.quantile(.90))]

for index, x in enumerate(tamañosASM):
    npArray = np.array(tamañosASM[x])
    #tamañosASM[x] = tamañosASM[x].mean()
    resASM.append(tamañosASM[x].mean())


for index, x in enumerate(tamañosC0):
    npArray = np.array(tamañosC0[x])
    #tamañosC0[x] = tamañosC0[x].mean()
    resC0.append(tamañosC0[x].mean())

for index, x in enumerate(tamañosC2):
    npArray = np.array(tamañosC2[x])
    #tamañosC0[x] = tamañosC0[x].mean()
    resC2.append(tamañosC2[x].mean())

for index, x in enumerate(tamañosC3):
    npArray = np.array(tamañosC3[x])
    #tamañosC0[x] = tamañosC0[x].mean()
    resC3.append(tamañosC3[x].mean())



with PdfPages('ReforzarBrillo_C_vs_ASM.pdf') as pdf:
    fig, ax= plt.subplots()
    ax.plot(tamaños, resASM, label="ASM", marker=".")
    ax.plot(tamaños, resC0, label="C0", marker=".")
    ax.plot(tamaños, resC2, label="C2", marker=".")
    ax.plot(tamaños, resC3, label="C3", marker=".")
    ax.legend(['ASM','O0','O2','O3'], loc='upper left')
    plt.xlabel("Cantidad de pixeles")
    plt.ylabel("Ciclos de clock")
    plt.title("Reforzar Brillo")
    ax.ticklabel_format(style='plain')
    ax.axis([0, 2000000, 0, 180000000])
    plt.grid( linestyle='-', linewidth=1)
    for tick in ax.get_xticklabels():
        tick.set_rotation(55)
    #plt.show()
    pdf.savefig(bbox_inches='tight')
    plt.close()

with PdfPages('ReforzarBrillo_C_vs_ASM_Viejo.pdf') as pdf:
    fig, ax = plt.subplots()
    ax.plot(tamaños, resASM, label="ASM", marker=".")
    ax.plot(tamaños, resC2, label="ASM - V", marker=".")
    ax.legend(['ASM', 'ASM - V'], loc='upper left')
    plt.xlabel("Cantidad de pixeles")
    plt.ylabel("Ciclos de clock")
    plt.title("Reforzar Brillo")
    #ax.set_xTicks = ['512','2048','8192','32768','120000','131072','480000','1920000']
    #ax.set_yTicks = [str(yTicks[i]) for i in range(0, len(yTicks))]
    ax.ticklabel_format(style='plain')
    ax.axis([0, 2000000, 0, 30000000])
    plt.grid(linestyle='-', linewidth=1)
    for tick in ax.get_xticklabels():
        tick.set_rotation(55)
    #plt.show()
    pdf.savefig(bbox_inches='tight')
    plt.close()

with PdfPages('ReforzarBrillo_x_tamaño.pdf') as pdf:
    plt.figure(figsize=(7, 5))
    labels = 'ASM', 'O3','O2','O0'
    barValues = [resASM[7],resC3[7],resC2[7],resC0[7]]
    x = [1,2,3,4]
    fig, ax = plt.subplots()
    rects1 = ax.bar(x, barValues,0.7, label='')
    plt.ylabel('')
    plt.xlabel("Implementaciones")
    plt.ylabel("Ciclos de clock")
    plt.title("Reforzar Brillo 1600x1200")
    ax.ticklabel_format(style='plain')
    ax.set_xticks(x)
    ax.set_xticklabels(labels)
    plt.grid(linestyle='-', linewidth=1, axis='y')
    pdf.savefig(bbox_inches='tight')
    plt.close()
    
    


with PdfPages('ReforzarBrillo_x_tamaño_viejo.pdf') as pdf:
    #plt.figure(figsize=(7, 5))
    labels = 'ASM', 'ASM - V'
    barValues = [resASM[7], resC2[7]]
    x = [1, 2]
    fig, ax = plt.subplots()
    rects1 = ax.bar(x, barValues, 0.7, label='')
    plt.ylabel('')
    plt.xlabel("Implementaciones")
    plt.ylabel("Ciclos de clock")
    plt.title("Reforzar Brillo 1600x1200")
    ax.ticklabel_format(style='plain')
    ax.set_xticks(x)
    ax.set_xticklabels(labels)
    plt.grid(linestyle='-', linewidth=1, axis='y')
    pdf.savefig(bbox_inches='tight')
    plt.close()

def calcularPorcentaje(asm, c):
    print (asm)
    #print(c)
    return int((asm*100)/c)

print (resASM)

asm_vs_o3 = calcularPorcentaje(resASM[7], resC3[7])
asm_vs_o2 = calcularPorcentaje(resASM[7], resC2[7])
asm_vs_o0 = calcularPorcentaje(resASM[7], resC0[7])

print("reforzarBrillo_asm_vs_O0: " + str(asm_vs_o0) + '%')
print("reforzarBrillo_asm_vs_O2: " + str(asm_vs_o2) + '%')
print("reforzarBrillo_asm_vs_O3: " + str(asm_vs_o3) + '%' + "\n")


#Hace el de ticks divido por millon y label Ticks (Millones)

#colorBordesAsm.set_index('Tamaño')
#media = colorBordesAsm['Ciclos'].mean()
#desviacionStandard = colorBordesAsm['Ciclos'].std()
#aproximacionNormal = np.random.normal(media, desviacionStandard, len(colorBordesAsm['Ciclos']))
#
#
#
#    fig, ax = plt.subplots()
#    ax.plot(colorBordesAsm, label='ASM')
#    # ax.plot(sizes, res_imagen_fantasma_c_O0, label="O0")
#    # ax.plot(sizes, res_imagen_fantasma_c_O1, label="O1")
#    # ax.plot(sizes, res_imagen_fantasma_c_O2, label="O2")
#    # ax.plot(sizes, res_imagen_fantasma_c_O3,  label="O3")
#    legend = ax.legend(loc='upper right', shadow=True)
#    ax.ticklabel_format(style='plain')
#    plt.title('Rendimiento')
#    plt.xlabel('Tamaño')
#    plt.ylabel('Ciclos')
#    legend.get_frame()
#    pdf.savefig()
#    plt.close()
#    plt.show()
