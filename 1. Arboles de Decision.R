
# Librería para Arboles de Decisión
install.packages("partykit")
library(partykit)

# Base para Entrenar
base = iris

table(base$Species)

# Definimos un Target Binario
base$Species = ifelse(iris$Species == "versicolor", 1, 0)

table(base$Species)

# Entrenamos un Arboles de Decisión
arbol = ctree(as.factor(Species) ~ ., base, 
              control = ctree_control(mincriterion = .01))

# Graficamos el Arboles de Decisión
plot(arbol)

# Predecimos sobre una base "nueva" (en este caso la misma a modo de ejemplo)
prediccion = data.frame(base$Species, predict(arbol, base[,1:4], type="response"))


# Parametros Modelables:
  #	Mincriterion: Valor del t-statisctic (1 - p-value) que debe ser superado para realizar un quiebre (Split).
  # Maxdepth: Profundidad máxima permitida para cada árbol.
  #	Minsplit: Peso mínimo exigido en un nodo para efectuar otro quiebre.
  #	Minbucket: Peso mínimo total de un nodo final del árbol


