
install.packages("cvTools") # Librería para Cross Validation
install.packages("partykit") # Librería para Arboles de Decisión
install.packages("pROC") # Librería para calculo de Curva ROC

library(cvTools) # Librería para Cross Validation
library(partykit) # Librería para Arboles de Decisión
library(pROC) # Librería para calculo de Curva ROC

# Base para Entrenar
base = iris

# Definimos un Target Binario
base$Species = ifelse(iris$Species == "versicolor", 1, 0)



#Entrenar Arbol con distintos paremtros

set.seed(1000) # Definir semilla aleatorio
number_folds = 10 # Definir la cantidad de Folds
folds = cvFolds(nrow(base), number_folds) # Armar los Folds

AUCs = data.frame() # Armar un Data Frame vacío para registrar las AUCs

for (iter in 1:100) { # En este caso probamos 100 combintaciones distintas de parámetros
  ptm = proc.time() # Mido el tiempo de ejecucion
  Rtdo = data.frame() # Armar un Data Frame vacío para registrar los Rtdos Parciales
  param = ctree_control( #Defino los parámetros del modelo
    mincriterion = runif(1, .80, .99), # Con runif saco un aleatorio entre esos valores continuos
    minsplit = sample(1:100, 1), # Con sample saco un aleatorio entre esos valores discretos
    minbucket = sample(1:15, 1), 
    minprob = runif(1, .001, .01),
    maxdepth = sample(3:30, 1)
    )
  for(i in 1:number_folds)  { # Itero sobre cada Fold para ir entrenando
    arbol = ctree(as.factor(Species) ~ ., base[folds$subsets[folds$which != i],], control = param) # Entreno el modelo
    validation = data.frame(base[folds$subsets[folds$which == i],"Species"], # Valido sobre el Fold sobrante
                            predict(arbol, base[folds$subsets[folds$which == i],], type="response"))
    names(validation) = c("real", "predict")
    Rtdo = rbind(Rtdo, validation) # Guardo el resultado en Validación
    print(paste("Fold Nro", i,"- Modelo Nro",iter)) # Hago un Log
    }
  Salida = data.frame(param$criterion, param$minsplit, param$minbucket, param$minsplit, param$maxdepth, auc(Rtdo$real, as.numeric(Rtdo$predict)), as.numeric(proc.time()-ptm)[3])
  names(Salida) = c("mincriterion","minsplit","minbucket","minprob","maxdepth","AUC", "Time") # Calculo las Metricas
  print(paste0("Modelo Nro ",iter," - ROC = ", round(Salida$AUC*100, digits = 2),"%")) # Hago un Log
  AUCs = rbind(AUCs, Salida) # Guardo en una tabla la salida
}

rm(Rtdo, arbol, i, iter, param, Salida, validation, folds, number_folds, ptm)

##############
