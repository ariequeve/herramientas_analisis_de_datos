
# Librer?a para Arboles de Decisi?n
install.packages("partykit")
library(partykit)

# Base para Entrenar
base = iris

table(base$Species)

# Definimos un Target Binario
base$Species = ifelse(iris$Species == "versicolor", 1, 0)

table(base$Species)

# Entrenamos un Arboles de Decisi?n
arbol = ctree(as.factor(Species) ~ ., base, 
              control = ctree_control(mincriterion = .01))

# Graficamos el Arboles de Decisi?n
plot(arbol)

# Predecimos sobre una base "nueva" (en este caso la misma a modo de ejemplo)
prediccion = data.frame(base$Species, predict(arbol, base[,1:4], type="response"))


# Parametros Modelables:
  #	Mincriterion: Valor del t-statisctic (1 - p-value) que debe ser superado para realizar un quiebre (Split).
  # Maxdepth: Profundidad m?xima permitida para cada ?rbol.
  #	Minsplit: Peso m?nimo exigido en un nodo para efectuar otro quiebre.
  #	Minbucket: Peso m?nimo total de un nodo final del ?rbol


