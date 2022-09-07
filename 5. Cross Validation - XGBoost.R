
# Librería a Instalar
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


#Greedy de Parametros en XGB con CV 
best_param = list()
best_seednumber = 1
best_AUC = 0
best_AUC_index = 0
Rtdo = data.frame()

for (iter in 1:20) {
  param = list(objective = "binary:logistic",
                booster = "gbtree",
                eval_metric = "auc",
                max_depth = sample(3:25, 1),
                eta = runif(1, .001, .3),
                gamma = runif(1, 0, 5), 
                subsample = runif(1, .3, 1),
                colsample_bytree = runif(1, .3, 1), 
                min_child_weight = sample(1:30, 1),
                max_delta_step = sample(1:20, 1)
  )
  seed.number = sample.int(10000, 1)[[1]]
  set.seed(seed.number)
  
  cv.xgb = xgb.cv( params = param,
                    data = MXtrain,
                    nfold = 5,
                    print_every_n = 25,
                    early_stop_round = 30,
                    maximize = T,
                    prediction = T,
                    nrounds = 300
  )
  
  max_AUC = max(cv.xgb$evaluation_log[, test_auc_mean]) 
  max_AUC_index = which.max(cv.xgb$evaluation_log[, test_auc_mean])
  print(paste0("Vuelta Nro ",iter))
  Salida = data.frame(c(param, max_AUC_index,max_AUC))
  names(Salida)[11:12] = c("Nrounds", "AUC")
  Rtdo = rbind(Rtdo, Salida)
  
  if (max_AUC > best_AUC) {
    best_AUC = max_AUC
    best_AUC_index = max_AUC_index
    best_seednumber = seed.number
    best_param = param
  }
}

rm(cv.xgb, iter, max_AUC, max_AUC_index, seed.number, param, Salida)


####################################################

#Correr modelo en XGB

set.seed(best_seednumber)
md = xgb.train(data=MXtrain, params=best_param, nrounds=best_AUC_index)

xgb.plot.importance(xgb.importance(feature_names = colnames(base[,1:4]), model = md), 
                    top_n = 4, rel_to_first = T, main = "Feature Importance (Gain)", sub = paste0("Model AUC = ",round(best_AUC*100,2),"%"))



