

# Librer?a a Instalar
install.packages("nnet")
library(nnet)

# Base para Entrenar
base = iris

table(base$Species)

# Definimos un Target Binario
base$Species = ifelse(iris$Species == "versicolor", 1, 0)

table(base$Species)


# Convertir la base en variables con escala entre 0 y 1
maxs = apply(base, 2, max) 
mins = apply(base, 2, min)
scaled = as.data.frame(scale(base, center = mins, scale = maxs - mins))


# Entrenamos el Modelo
NNFF = nnet(as.matrix(scaled[,1:4]), as.matrix(scaled[,5]), size = 7, maxit = 200)

# Importamos Funcion para graficar
install.packages("devtools")
library(devtools)
source_url('https://gist.githubusercontent.com/Peque/41a9e20d6687f2f3108d/raw/85e14f3a292e126f1454864427e3a189c2fe33f3/nnet_plot_update.r')
install.packages("reshape")
library(reshape)

# Graficamos la Red
plot.nnet(NNFF,pos.col='darkgreen',neg.col='darkblue',rel.rsc=15, circle.col='grey')

# Caracter?sticas del Gr?fico:
# - Los pesos positivos est?n en Verde
# - Los pesos negativos est?n en Azul
# - Cuanto mayor el peso, m?s gruesa la linea
# - Los nodos iniciales representan las variables de Entrada
# - Los nodos centrales representan la Capa Oculta
# - Los nodos de tipo "B" son constantes agregadas al modelo

rm(maxs, mins, scaled, plot.nnet)

# Parametros Modelables:
#	Size: Cantidad de unidades ("neuronas") en la capa oculta de la red
#	Entropy: Par?metro binario, cuando es "Verdadero" la funci?n de optimizaci?n es la M?xima Verosimilitud, mientras que si es "Falso" realiza la optimizaci?n por el m?todo de Error Cuadr?tico Medio. 
#	Maxit: Cantidad de Iteraciones que realiza el modelo para optimizar
#	Decay: Peso asignado al decaimiento, entendido como el valor por el que son multiplicados los pesos despu?s de cada iteraci?n (valor que se encuentra entre 0 y 1)

