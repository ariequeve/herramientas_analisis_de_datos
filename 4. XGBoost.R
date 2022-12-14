
# Librer?a a Instalar
install.packages("xgboost")
library(xgboost)

# Base para Entrenar
base = iris

table(base$Species)

# Definimos un Target Binario
base$Species = ifelse(iris$Species == "versicolor", 1, 0)

table(base$Species)


# Crear objeto DMatrix
MXtrain = xgb.DMatrix(data = as.matrix(base[,1:4]), label = base$Species)


# Definimos los Parametros
param = list(objective = "reg:linear", # Tipo de target
             booster = "gbtree", # Tipo de booster, arbol o regresi?n
             eval_metric = "auc", # Evaluador para Optimizar
             max_depth = sample(3:25, 1), # Profundidad m?xima del ARBOL
             eta = runif(1, .001, .3), # Controla la tasa de aprendizaje
             gamma = runif(1, 0, 5), # Reducci?n de p?rdida m?nima requerida 
             subsample = runif(1, .3, 1), # Cantidad de filas aleatoria
             colsample_bytree = runif(1, .3, 1), # Cantidad de columnas aleatoria
             min_child_weight = sample(1:30, 1) # peso m?nimo para un nuevo nodo
)

# Entrenamos el Modelo
XGB = xgb.train(data=MXtrain, params=param , nrounds=300)


# Vemos la importancia de las Variables
xgb.plot.importance(xgb.importance(feature_names = colnames(base[,1,4]), model = XGB))


rm(MXtrain, param)

# Parametros Modelables:
#	Nrounds: Cantidad de Iteraciones de optimizaci?n
#	Max_depth: Profundidad que se le permite alcanzar a cada ?rbol de Decisi?n
#	Eta: Controla la tasa de aprendizaje, haciendo que el modelo sea m?s robusto a trav?s de una reducci?n en los pesos de cada ?rbol en cada paso
#	Subsample: Cantidad de filas, seleccionadas de forma aleatoria, que se utilizan para entrenar cada grupo de arboles 
#	Colsample_bytree: Cantidad de columnas, seleccionadas de forma aleatoria, que se utilizan para entrenar cada grupo de arboles 
#	Min_child_weight: Define el peso m?nimo requerido para la creaci?n de un nuevo nodo, por lo que controla la relevancia en el crecimiento del ?rbol. 
#	Gamma: Especifica la reducci?n de p?rdida m?nima requerida en la funci?n de p?rdida para hacer una nueva divisi?n en el ?rbol .


