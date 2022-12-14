
#### Funciones Principales ####

# Informaci?n de la Sesi?n 
sessionInfo()

# Definir entorno de Trabajo
getwd()

setwd("C:/Users/Pablo Albani/OneDrive - C&C Financial Services/Escritorio/Academicos/Austral/00.Diplomatura")


#### ### ### ### ### ### ### ### ###

# Busqueda de ayuda
help.start()

?plot

help(summary)

??read.csv

library(help = "base")

vignette("readr")


#### ### ### ### ### ### ### ### ###


#### Otros Comandos Utiles ####

dataframe1$Variable # Signo "$" para acceder a un objeto

# "#" Para Comentarios

install.packages("readr") # Instalar una Librer?a


library("readr") # Leer una Librer?a


#### ### ### ### ### ### ### ### ###

#### Tipos de Datos ####

#Variable character
Nombre = "Diplomatura en Ciencia de Datos Aplicada"
str(Nombre)

#Variable integer
Entero = 2456L
str(Entero)

#Variable numeric
Numero = 0.543
str(Numero)
  
#Variable logical
Verdadero = TRUE
str(Verdadero)

# Los nombres de los Objetos deben comenzar con letras!

#### ### ### ### ### ### ### ### ###

is.integer(Entero)  # Validaci?n de un Tipo de dato

is.factor(Numero)   # Validaci?n de un Tipo de dato

Texto2 = as.character(Numero) # Conversi?n de un Tipo de dato

Numero2 = as.numeric(Entero) # Conversi?n de un Tipo de dato


#### ### ### ### ### ### ### ### ###

#### Tipos de Objetos ####

# Generaci?n de Vectores
var = vector(mode="numeric", length=10)

numero = 1:30

texto = c("a","b","a","a","a","b","b",NA)


# Operadores sobre Vectores
unique(texto) # Distingue los valores sin repetir del vector

duplicated(texto) # Genera un Vecotr l?gico de Duplicados

summary(texto) # Sintesis de las caracter?sticas del Vector

is.na(texto) # Genera un Vecotr l?gico de Nulos

length(texto) # Recuento de longitud del Vector

min(numero) # Aplicable a numericos, m?nimo

max(numero) # Aplicable a numericos, m?ximo

sum(numero) # Aplicable a numericos, suma

mean(numero) # Aplicable a numericos, promedio

sd(numero) # Aplicable a numericos, desv?o estandar

var(numero) # Aplicable a numericos, varianza

table(texto) # Crea una tabla de contingencia, muy util luego para Data Frames


#### ### ### ### ### ### ### ### ###

# Generaci?n de Factores
var2 = factor( c("a","b","a","a","a","b","b","b"), levels=c("a","b"))

var2 # Observar el Factor con sus dos niveles


#### ### ### ### ### ### ### ### ###

# Generaci?n de Matrices
matriz  = matrix(1:50, nrow=10, ncol=5, byrow=FALSE)

# Operadores sobre Matrices

matriz2 = cbind(matriz, 1:10) # Concatenar por Filas (Agrega Columna)

matriz3 = rbind(matriz, 1:5) # Concatenar por Columna (Agrega Filas)


#### ### ### ### ### ### ### ### ###

# Generaci?n de Data Frames

dataframe1 = data.frame(c("A","B","C"),c(1,2,3),c(TRUE, TRUE, FALSE))

# Definici?n de los nombres de las columnas
names(dataframe1) = c("Letras", "Numeros", "Logicos")

# Operadores sobre Data Frames

str(dataframe1) # Estructura del Objeto

dim(dataframe1) # Dimensi?n del Objeto

nrow(dataframe1) # N? Filas del Objeto

ncol(dataframe1) # N? Columnas del Objeto

summary(dataframe1) # S?ntesis de las caracter?sticas del Objeto

table(dataframe1$Letras, dataframe1$Numeros) # Crea una tabla de contingencia

a = merge(dataframe1,dataframe2, by= "variable")


#### ### ### ### ### ### ### ### ###

# Generaci?n de Listas

Lista = list(matriz, dataframe1) # Creaci?n de una lista con una Matriz y un Data Frame

Lista[1] # Acceso a un elemento de la Lista

Lista[2] # Acceso a un elemento de la Lista


#### ### ### ### ### ### ### ### ###

texto[2] # Acceso a un elemento del Vector

matriz[2,4] # Acceso a un elemento de la Matriz

dataframe1[dataframe1$Letras != "a"]


#### ### ### ### ### ### ### ### ###

#### Lectura y Guardado de Datos ####

#Importar Datos

Ejemplo1 = read.table("Ejemplo 1.csv", sep = ",", dec = ".", header = T) # Leer un TXT

Ejemplo1 = read.csv("Ejemplo 1.csv") # Leer un CSV

str(Ejemplo1) # Ver la Estructura de la tabla le?da

readLines("Ejemplo 1.csv", 3) # Leer un numero limitado de Lineas de un archivo


# Exportar Datos

write.table(matriz, "Guardar.txt", sep = ",", dec = ".")

write.csv(matriz, "Guardar.csv")


#### ### ### ### ### ### ### ### ###

#  Funciones Generales

runif(n=5, min = 1, max = 10) #Generaci?n de Aleatorios


head(Ejemplo.1) #Ver las primeras filas del Objeto "a"


tail(Ejemplo.1) #Ver las ultimas filas del Objeto "a"


rm(Ejemplo.1) # Remover un objeto en Memoria


rm(list=ls()) #Para borrarlos todos los elementos



#### ### ### ### ### ### ### ### ###

#### Ejercitaci?n ####

# Leer el archivo fifa-statistics.csv

# Ver las primeras filas

# Ver la estructura de los datos (str)

# Ver la cantidad de columnas y filas que tiene

# Imprimir la primera columna


#### ### ### ### ### ### ### ### ###

#### Funciones de Texto ####

paste("a", Entero, sep = " - ") # Concatena Objetos en Texto con un especio entre ellos

paste0("a", Entero) # Concatena Objetos en Texto sin un especio entre ellos

substr("Hola Mundo", 1, 4) # Extrae Sub-Cadenas de texto de un objeto

letters # Vector precargado, tiene todas las letras del abecedario


#### ### ### ### ### ### ### ### ###

#### Generaci?n de Funciones simples e Iterativas ####
 
fun = function(x) {
  res = x * 2
  return(res)
}

fun(numero)

fun2 = function(x) {
  x * 2
  x / 10
}

fun2(numero)


# Funci?n sapply: Aplica una Funci?n sobre una Lista o un Vector

sapply(Ejemplo1, mean)

sapply(Ejemplo1[,c(1,3,4)], mean)


# Funci?n apply: Aplica una Funci?n sobre columnas o filas de una matriz

apply(matriz,1,sum) # Con "1" aplica la funcion sobre las filas

apply(matriz,2,sum) # Con "2" aplica la funcion sobre las columnas


# Funci?n mapply: Es una versi?n Multivariada de Sapply

mapply(function(x,y) paste0('La observaci?n ',x,' tiene un valor de ',y,' en la metrica X'),
       Ejemplo1$Nombre, Ejemplo1$Edad)



#### ### ### ### ### ### ### ### ###

#### Generaci?n de Gr?ficos ####

### Gr?fico m?s complejos y lindos ### 

install.packages("ggplot2") # Tenemos que instalar esta librer?a

library(ggplot2) # Luego de instalar la abrimos




#Gr?fico simples

plot(numero) # Gr?fico predeterminado

plot(numero*numero, type = "l") # Gr?fico de Lineas

plot(numero*numero, type = "S") # Gr?fico de Lineas por "pasos"

plot(mpg$hwy, type = "h") # Gr?fico de Histograma


hist(mpg$hwy, breaks = 10) # Histograma

barplot(mpg$hwy[1:50]) # Gr?fico de Barras

boxplot(mpg$cty, mpg$hwy) # Gr?fico BoxPlot


### Gr?fico m?s complejos y lindos ### 

qplot(mpg, wt, data = mtcars, colour = cyl) # Quick Plot para salidas r?pidas

economics

# Gr?fcios de Estilo de Series Temporales

Eco = ggplot(economics[1:50,], aes(date, unemploy)) # Datos Econ?micos

Eco + geom_path() #Gr?fico de Linea

Eco + geom_step() #Gr?fico de Linea por "pasos"

Eco + geom_polygon() # Pol?gono de diferencia respecto a la recta

Eco + geom_ribbon(aes(ymin=unemploy, ymax=unemploy+900)) # Area de diferencia entre Series

ggplot(mpg) + geom_qq(aes(sample=hwy)) # Area bajo una Serie



# Gr?ficos descriptivos de 1 variable continua

Auto1 = ggplot(mpg, aes(hwy)) # Datos de Autom?viles, 1 variable

Auto1 + geom_histogram() #  Histograma

ggplot(mpg, aes(class)) + geom_bar() # Gr?fico de Barras



# Gr?ficos descriptivos de 2 variables continuas

Auto2 = ggplot(mpg, aes(hwy,cty)) # Datos de Autom?viles, 2 variables

Auto2 + geom_label(aes(label=drv)) # Gr?fico de punos con etiquetas (drv = transmisi?n)

Auto2 + geom_jitter() # Gr?fico de Puntos de 2 var

Auto2 + geom_smooth() # Linea suavizada de tendencia con marca de dispersi?n



# Gr?ficos descriptivos de 2 variables, una continua y una discreta

Auto3 = ggplot(mpg, aes(class, hwy)) 

Auto3 + geom_col() # Gr?fico de barras con una variable como frecuencia

Auto3 + geom_violin() # Gr?fico BoxPlot

Auto3 + geom_col() + coord_cartesian()


### Gr?ficos Combinados m?s Complejos ###

?mpg 
# Distribuci?n del Consumo en ciudad y tama?o del motor por Marca

theme_set(theme_bw())  # 
ggplot(mpg[mpg$manufacturer == c("audi", "ford", "honda"),], aes(displ, cty)) + 
  labs(subtitle="mpg: Displacement vs City Mileage", title="Bubble chart") + 
  geom_jitter(aes(col=manufacturer, size=hwy)) + # Similar a puntos, pero con dimens?on
  geom_smooth(aes(col=manufacturer), method="lm", se=F) # Agrega linea de tendencia


# Tipo de Autos seg?n el tama?o del motor

ggplot(mpg, aes(displ)) + 
  scale_fill_brewer(palette = "Spectral") + 
  geom_histogram(aes(fill=class), binwidth = .1, col="black", size=.1) +
  labs(title="Histogram with Auto Binning", 
       subtitle="Engine Displacement across Vehicle Classes")  


# Tipo de Autos que ofrece por Marca

ggplot(mpg, aes(manufacturer)) + 
  geom_bar(aes(fill=class), width = 0.5) + 
  theme(axis.text.x = element_text(angle=65, vjust=0.6)) + 
  labs(title="Histogram on Categorical Variable", 
       subtitle="Manufacturer across Vehicle Classes") 


#  Distribuci?n del Consumo en ciudad seg?n el tama?o del motor

ggplot(mpg, aes(cty)) + 
  geom_density(aes(fill=factor(cyl)), alpha=0.8) + 
  labs(title="Density plot", 
       subtitle="City Mileage Grouped by Number of cylinders",
       caption="Source: mpg",
       x="City Mileage",
       fill="# Cylinders")

i = mpg


#### ### ### ### ### ### ### ### ###

#### Ejercitaci?n ####

fifa = read.csv('fifa-statistics.csv')

# Graficar la cantidad de partidos jugados por cada Equipo
fifa$Team

ggplot(fifa, aes(Team)) + geom_bar() 

# + theme(text = element_text(size = 7))  
# + coord_flip()

# Graficar la cantidad de Goles Marcados por cada Equipo
ggplot(fifa, aes(Team, Goal.Scored)) + geom_col() + coord_flip()

# Por cada Partido:
ggplot(fifa, aes(Team, Goal.Scored)) + geom_violin(scale = "area") + theme(text = element_text(size = 7))


# Comparar dos variables continuas, por ejemplo:
#         La Posesi?n de bal?n respecto a la precisi?n de los pases
#         La cantidad de tiros al arco respecto a los goles convertidos
#         La distancia recorrida respecto a la cantidad de pases
ggplot(fifa, aes(Ball.Possession.., Pass.Accuracy..)) + geom_point()


# Graficar la Posesi?n de bal?n y la precisi?n de los pases como un histograma
require(gridExtra)
plot1 = qplot(Ball.Possession.., data = fifa)
plot2 = qplot(Pass.Accuracy.., data = fifa)
grid.arrange(plot1, plot2, ncol=2)

# Que sucede si vemos estos datos para alg?n equipo puntual
ggplot(fifa[fifa$Team == 'Argentina',], aes(Ball.Possession.., Pass.Accuracy..)) + geom_point()

