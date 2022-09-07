#### Ejercitaci?n ####

# Leer el archivo fifa-statistics.csv
getwd()
setwd("C:/Users/arielquevedo/OneDrive/Documents/Universidad Austral/Diplomatura Ciencia de Datos/Modulo 1/Clase 1/")
dataframefifa = read.csv("fifa-statistics.csv")

# Ver las primeras filas
head(dataframefifa)

# Ver la estructura de los datos (str)
str(dataframefifa) 

# Ver la cantidad de columnas y filas que tiene
dim(dataframefifa) # Dimensi?n del Objeto
ncol(dataframefifa)
nrow(dataframefifa)

# Imprimir la primera columna
head(dataframefifa$Date)


#---------------------------------------------------------------------
#### Ejercitaci?n ####

# Agregar las siguientes variables calculadas al Dataset:
#         Eficiencia_Disparos: Indice de Goles por Tiros al arco
#         Pases_por_Distancia: Indice de cantidad de pases respecto a la distancia recorrida
#         Pelota_Detenida: Suma de Corners + Free Kicks

install.packages("dplyr")
library(dplyr)

dataframefifa2 = mutate(dataframefifa,
                    Eficiencia_Disparos = Goal.Scored / On.Target,
                    Pases_por_Distancia = Passes / Distance.Covered..Kms.,
                    Pelota_Detenida = Free.Kicks + Corners)


# ?Cu?l fue el total de tarjetas amarillas (Yellow Card) en cada fase del torneo (Round)?

totalAmarillas = summarise(group_by(dataframefifa, Round), n(), sum(Yellow.Card))

# ?C?antos goles convirti? cada equipo en la copa?

# ?Que equipo tuvo m?s tiros libres (Free Kicks)?

# Crear una Muestra Aleatoria del 80% de los registros para entrenar y dejar 20% para testear

str(dataframefifa)
