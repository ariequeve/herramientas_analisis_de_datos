

##### Levantar Bases CSV y TXT rapido #####

install.packages("readr")
library(readr)

# Base descargada de: https://www.kaggle.com/husainsb/lendingclub-issued-loans

base = read_delim("Bases/Lending Club/loan.csv", delim=",", col_names = TRUE)

base = read_csv("Bases/Lending Club/loan.csv", col_names = TRUE)


# Comparativa de Tiempos de Carga para la base de Lendig Club

s = Sys.time()
Prueba = read_csv("Bases/Lending Club/loan.csv", delim=",", col_names = TRUE)
Sys.time() - s

s = Sys.time()
Prueba = read.csv("Bases/Lending Club/loan.csv", header = T)
Sys.time() - s

rm(s, Prueba)



##### Conectar a una base SQL #####

install.packages("RODBC")
library(RODBC)

#Conectar con el servidor
conect = odbcConnect("Conexion1")

#Hacer una consulta a una base
base = sqlQuery(conect, "Select * from DW..tabla")



##### Funci?n de lectura simil SQL  #####

install.packages("sqldf")
library(sqldf)


#Hacer una consulta de SQL
ej = sqldf("select * from base where grade in ('A', 'B')")  #Subset multiple de textos

ej = sqldf("select * from base where total_pymnt between 1000 and 3000")  #Subset multiple de numeros

ej = sqldf('select purpose, avg("last_pymnt_amnt") "Prom" from base group by purpose') #Agrupamiento

rm(ej)



##### Exploratory Analysis con FunModeling  #####

install.packages("funModeling")
library(funModeling)  

#Ver % zeros, % NA, Tipo de Dato y Valores Unicos

Estructura = df_status(base, print_results = F) 


library(ggplot2)

Est = Estructura[Estructura$p_na > 0,]
theme_set(theme_minimal())
ggplot(Est, aes(reorder(variable, p_na, sum), p_na)) + geom_col() + coord_flip()

Est = Estructura[Estructura$p_zeros > 0,]
ggplot(Est, aes(reorder(variable, p_zeros, sum), p_zeros)) + geom_col() + coord_flip()

rm(Estructura, Est)



##### Funci?n Simple para Chequear % de Nulos  #####

Nulos = function(x) return(paste0(round(sum(is.na(x))/length(x),4)*100,'%'))

data.frame(sapply(base,Nulos))

rm(Nulos)



##### Imputar nulos por un valor determinado #####

# Una variable
base$inq_last_12m[is.na(base$inq_last_12m)] = -1

# Todo un Data Frame
base[is.na(base)] = -999

#Otras funciones para imputar:
# De la librer?a "caret"
#   "knnImpute", "bagImpute", "medianImpute"


##### Descartar Columnas  #####

base = subset(base, select=-c(XX))

base = base[,!names(base) %in% c()]



##### Convertir variable Char a Num por orden alfabetico #####

table(base$grade)

# Definir y ordenar los valores
levels = as.character(unique(base$grade))[order(unique(base$grade))]

# Aplicar a una variable nueva
base$grade = as.integer(factor(base$grade, levels=levels))

table(base$grade)


rm(levels)



##### Crear variables Dummies  #####

install.packages("caret")
library(caret)

# Determinar la variable sobre la que vamos a construir las Dummies
dummies = dummyVars("~ home_ownership", base, fullRank = T) # "~." para todo, fullRank = T -> Coloca una sola de 2 variables excluyentes

# Crear las variables Dummies
var_dum = data.frame(base$home_ownership, predict(dummies, newdata = base)) # Fijarse el ID y Merge

# Agregarlas a la base
base2 <- cbind(base, var_dum) 



##### Crear una Muestra Aleatoria #####

# Definir una semilla para poder reproducir
set.seed(5)

# Crear un vector aleatorio (en este caso del 80%)
posicion = sample(nrow(base), size= nrow(base)*0.8)

#Aplicar a la base para generar la muestra y su complemento
train <- base[posicion,]
test <- base[-posicion,]

rm(posicion)



##### Descartar variables que no tiene Varianza  #####

install.packages("caret")
library(caret)

#Buscar los "Near Zero Variance"

ZeroVar = nearZeroVar(base[1:10000,], saveMetrics = TRUE)

table(ZeroVar$zeroVar, ZeroVar$nzv)

base_filtrada = base[,!ZeroVar$zeroVar]

rm(ZeroVar)



##### Crear Matriz de Correlaci?n  #####

install.packages("corrplot")
library(corrplot)

# Crear la matriz de Correlaci?n
M = cor(iris[1:4])

# Graficar la matriz
corrplot(M, method = "circle", tl.pos = "d", order = "FPC") 

# Graficar la matriz con dos tipos distintos de representaciones
corrplot.mixed(M, lower = "number", upper = "ellipse", tl.pos = "d", order = "FPC") # Combina dos tipos

#Tipos de Comparaci?n: circle, ellipse, number, color

#Ordenes: alphabet, AOE (Angular Order), FPC (1? principal component), hclust (hierarchical) 



### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###



#####  Funciones de la Librer?a dplyr  #####

library(dplyr)

# Flitrar una parte de la base por el valor de una variable
Grado_G = filter(base, grade == "G")


# Ordenar la base por una o mas variables
base_ordenada = arrange(base, term, id)


# Seleccionar solo algunas columnas 
montos = select(base, loan_amnt, funded_amnt, installment)


# Agregar nuevas columnas calculadas
montos2 = mutate(montos,
                no_fondeado = funded_amnt - loan_amnt,
                porc_cuota = installment / loan_amnt * 100)


montos3 = transmute(montos,
                    no_fondeado = funded_amnt - loan_amnt,
                    porc_cuota = installment / loan_amnt * 100)


# Aplicar group_by + summarise para agregar datos
agrupado = summarise(group_by(base, term), n(), sum(loan_amnt))

# Se puede usar con: mean(), median(), min(), max(), quantile(),  n(), n_distinct()


# Piping
# Pasa el objeto a la izquierda al primer argumento (o al que tenga ".")

agrupado = base %>%
  group_by(term) %>%
  summarise(n(),total_amnt = sum(loan_amnt)) 
  

rm(Grado_G, base_ordenada, montos, montos2, agrupado)



#####  Funciones de la Librer?a tidyr  #####

library(tidyr)

# Convertir un Data Frame a una tabla de relaci?n -> Variable:Valor

i = iris[,1:4]

ii = gather(i, Variable)


# Separar una variable en 2 o m?s a partir de una expresi?n regular
head(base$earliest_cr_line)

base = separate(base,earliest_cr_line,into = c("mes","anio"),sep = "-", remove = F)


rm(i, ii)




#####  Otras funciones utiles  #####


# Para manipular Cadenas de Texto: Ver el Cheat Sheet de "stringr"



# Para manipular Fechas: Ver el Cheat Sheet de "lubridate"

  # Tipos de Fecha (format())
    # %a - Abbreviated weekday
    # %A - Full weekday
    # %b or %h - Abbreviated month
    # %B - Full month
    # %d - Day of the month 0-31
    # %j - Day of the year 001-366
    # %m - Month 01-12
    # %U - Week with Sunday as first day of the week
    # %w - Weekday 0-6 Sunday is 0
    # %W - Week 00-53 with Monday as first day of the week
    # %x - Date, locale-specific
    # %y - Year without century 00-99
    # %Y - Year with century
    # %C - Century
    # %D - Date formatted %m/%d/%y
    # %u - Weekday 1-7 Monday is 1

fecha = as.Date("15/03/2017", format("%d/%m/%Y"))

lubridate::year(fecha)
lubridate::day(fecha)

format(fecha, format("%A %d de %B de %Y en el siglo %C"))



# Para analizar una variable: DescTools

install.packages("DescTools")
library(DescTools)

# Aplicar la funci?n sobre una variable (observar el tipo de dato)
Desc(base$loan_amnt)

Desc(base$grade)

# Var como reacciona respecto de una tabla:
table(base$grade, base$term)

Desc(table(base$grade, base$term))


#### Ejercitaci?n ####

# Agregar las siguientes variables calculadas al Dataset:
#         Eficiencia_Disparos: Indice de Goles por Tiros al arco
#         Pases_por_Distancia: Indice de cantidad de pases respecto a la distancia recorrida
#         Pelota_Detenida: Suma de Corners + Free Kicks



# ?Cu?l fue el total de tarjetas amarillas (Yellow Card) en cada fase del torneo (Round)?

# ?C?antos goles convirti? cada equipo en la copa?

# ?Que equipo tuvo m?s tiros libres (Free Kicks)?

# Crear una Muestra Aleatoria del 80% de los registros para entrenar y dejar 20% para testear
