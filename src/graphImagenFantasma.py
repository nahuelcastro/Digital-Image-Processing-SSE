import pandas as pd           ###librería para manipular tablas de datos
import seaborn as sns         ###librería para hacer gráficos
import numpy as np            ###librería de cálculo numérico
from scipy import stats       ###librería de estadística
import seaborn_qqplot as sqp  ###librería complementaria a seaborn para hacer qqplots
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages



imagenFantasmaC0 = pd.read_csv('./build/ImagenFantasma.csv', header=None, sep=',')
imagenFantasmaC2 = pd.read_csv('./build2/ImagenFantasma.csv', header=None, sep=',')
imagenFantasmaC3 = pd.read_csv('./build3/ImagenFantasma.csv', header=None, sep=',')
tamaños = np.array([32,128,512,2048,7500,8192,30000,120000])
tamañosASM = {"512":[],"2048":[],"8192":[],"32768":[],"120000":[],"131072":[],"480000":[],"1920000":[]}
tamañosC0 = {"512":[],"2048":[],"8192":[],"32768":[],"120000":[],"131072":[],"480000":[],"1920000":[]}
tamañosC2 = {"512":[],"2048":[],"8192":[],"32768":[],"120000":[],"131072":[],"480000":[],"1920000":[]}
tamañosC3 = {"512":[],"2048":[],"8192":[],"32768":[],"120000":[],"131072":[],"480000":[],"1920000":[]}

implementacion=1
tamaño=2
ciclos=3
for index, row in imagenFantasmaC0.iterrows():
    if row[implementacion]=="ASM":
        tamañosASM[str(row[tamaño])].append(row[ciclos])
    else:
        tamañosC0[str(row[tamaño])].append(row[ciclos])

for index, row in imagenFantasmaC2.iterrows():
    if row[implementacion]=="C":
        tamañosC2[str(row[tamaño])].append(row[ciclos])
    
for index, row in imagenFantasmaC3.iterrows():
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



with PdfPages('ImagenFantasma_C_vs_ASM.pdf') as pdf:
    plt.plot(tamaños, resASM, label="ASM", marker="o")
    plt.plot(tamaños, resC0, label="C0", marker="o")
    #plt.plot(tamaños, resC2, label="C2", marker="o")
    plt.plot(tamaños, resC3, label="C3", marker="o", color='red')
    plt.legend(['ASM','C0','C3'])
    plt.xlabel("Cantidad de pixeles")
    plt.ylabel("Ciclos de clock")
    plt.title("Grafico de prueba")
    plt.grid()
    #plt.show()
    pdf.savefig()
    plt.close()

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