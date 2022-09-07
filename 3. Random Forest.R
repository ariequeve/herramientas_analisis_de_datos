

# Librería a Instalar
install.packages("randomForest")
library(randomForest)

# Base para Entrenar
base = iris

table(base$Species)

# Definimos un Target Binario
base$Species = ifelse(iris$Species == "versicolor", 1, 0)

table(base$Species)

# Entrenamos un modelo de Random Forest
rf = randomForest(as.factor(Species) ~ ., base, ntree = 10, mytry = 20, replace = TRUE)

# Graficamos la imortancia de las variables
varImpPlot(rf)

# Predecimos sobre una base "nueva" (en este caso la misma a modo de ejemplo)
prediccion = data.frame(base$Species, predict(rf, base[,1:4], type="response"))


# Parametros Modelables:
#	Ntree: Cantidad de árboles de decisión a entrenar.
#	Mytry: Cantidad de variables, seleccionadas de forma aleatoria, que son seleccionadas como candidatas para cada árbol de decisión individual.
#	Replace: Parámetro binario Verdadero/Falso, que determina si el muestreo para entrenar debe realizarse con o sin remplazo.





for (iter in 1:100) {
  ptm = proc.time()
  Rtdo = data.frame()
  ntree = sample(100:700, 1)
  mytry = sample(5:50, 1)
  r = sample(c(T,F), 1)
  for(i in 1:number_folds)  {
    rf = randomForest(as.factor(Ind_Cobro) ~ ., base2[folds$subsets[folds$which != i],], 
                  ntree = ntree, mytry = mytry, replace = r)
    validation = data.frame(base2[folds$subsets[folds$which == i],"Ind_Cobro"],
                            predict(rf, base2[folds$subsets[folds$which == i],], type="response"))
    names(validation) = c("real", "predict")
    Rtdo = rbind(Rtdo, validation)
    print(paste("Fold Nro", i,"- Modelo Nro",iter))
    }
  Rtdo$predict = as.numeric(as.character(Rtdo$predict))
  Salida = data.frame(ntree, mytry, r, auc(Rtdo$real, Rtdo$predict), as.numeric(proc.time()-ptm)[3])
  names(Salida) = c("ntree","mytry","replace","AUC", "Time")
  print(paste0("Modelo Nro ",iter," - ROC = ", round(Salida$AUC*100, digits = 2),"%"))
  AUCs = rbind(AUCs, Salida)
}

rm(Rtdo, rf, i, iter,  ntree, mytry, r, Salida, validation, ptm)

##############

