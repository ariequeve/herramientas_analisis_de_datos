
# Importamos Librerías

library('ggplot2') # Para Graficar
library('caret') # Para Pre-procesar
library('dplyr') # Para Pre-procesar
library('DescTools') # Para ver distribuciones de funciones
library('mice') # Para imputar datos
library('randomForest') # Para entrenar el imputador

# Leer las bases
train = read.csv(paste0('Bases/titanic/train.csv'), stringsAsFactors = F)

test  = read.csv(paste0('Bases/titanic/test.csv'), stringsAsFactors = F)


# Juntar las bases para preprocesar
train$base = "Train"
test$base = "Test"

full  = bind_rows(train, test)


# Vemos la estructura
str(full)


####################


# Vemos los valores perdidos
colSums(is.na(full))


# Vemos la distribución de las variables a imputar
Desc(full$Age)

Desc(full$Fare)


# Como Fare tiene 1 solo valor perdido, lo imputo por la media
full$Fare[is.na(full$Fare)] = mean(full$Fare, na.rm = T)

# Primero creamos Variable Dummy para los casos que vamos a imputar
full$Age_NA = 0
full$Age_NA[is.na(full$Age)] = 1

table(full$Age_NA)

# Vamos a imputar los valores numericos usando Random Forest como predictor
imputador = mice(subset(full, select = c(Pclass, Sex, Age, SibSp, Parch, Fare, Embarked)), 
                 method='rf') 

mice_output = complete(imputador)

# Graficamos las distribuciones
par(mfrow=c(1,2))
hist(full$Age, freq=F, main='Age: Datos originales', 
     col='darkgreen', ylim=c(0,0.04))

hist(mice_output$Age, freq=F, main='Age: MICE Output', 
     col='lightgreen', ylim=c(0,0.04))

# Remplazamos la variable imputada
full$Age = mice_output$Age

# Vemos los valores perdidos nuevamente
colSums(is.na(full))

rm(mice_output)
rm(imputador)


####################

# Vemos los valores ceros
colSums(full=='')


# Vemos la distribución de las variables con ceros
Desc(full$Embarked)

Desc(full$Cabin)

# Tenemos dos valores cero en Embarked que es categórica
# Vamos a remplazar por el valor más frecuente

table(full$Embarked)

# Remplazamos por "S"
full$Embarked[full$Embarked==""]= "S"

table(full$Embarked)


# Vemos los valores ceros
colSums(full=='')


##############


# Vamos a hacer algunos análisis exploratorios con gráficos

# Vemos como correlaciona la supervivencia con la Clase
ggplot(full[full$base == "Train",],aes(x = Pclass,fill=factor(Survived))) +
  geom_bar() +
  ggtitle("Pclass v/s Survival Rate")+
  xlab("Pclass") +
  ylab("Total Count") +
  labs(fill = "Survived")  

# Qué sucede si le agregamos además la variable de sexo?
ggplot(full[full$base == "Train",], aes(x = Sex, fill = factor(Survived))) +
  geom_bar() +
  facet_wrap(~Pclass) + 
  ggtitle("Sex, pclass, and survival") +
  xlab("Sex") +
  ylab("Total Count") +
  labs(fill = "Survived")

##############

# Creación de Varialbes

# Vamos a crear una variable familia, sumando al pasajero que estamos contando
full$Fsize = full$SibSp + full$Parch + 1

# Graficamos la Supervivencia por esta variable
ggplot(full[full$base == "Train",], aes(x = Fsize, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  scale_x_continuous(breaks=c(1:11)) +
  labs(x = 'Family Size') 


# Discretizamos el tamaño de la familia en grupos
full$FsizeD[full$Fsize == 1] = '1.single'
full$FsizeD[full$Fsize < 5 & full$Fsize > 1] = '2.small'
full$FsizeD[full$Fsize > 4] = '3.large'

table(full$FsizeD, full$Survived)

# Graficamos la Supervivencia por esta variable
ggplot(full[full$base == "Train",], aes(x = FsizeD, fill = factor(Survived))) +
  geom_bar()


# Porque no sobreviven familias grandes?
ggplot(full[full$base == "Train",], aes(x = FsizeD, fill = factor(Survived))) +
  geom_bar() +
  facet_wrap(~Pclass)


##############

# Veamos como empiezan los nombres de los pasajeros
head(full$Name)


full$Title <- gsub('(.*, )|(\\..*)', '', full$Name)

table(full$Title)

# Agrupamos los titulos raros
otros_titulos <- c('Dona', 'Lady', 'the Countess','Capt', 'Col', 'Don', 
                'Dr', 'Major', 'Rev', 'Sir', 'Jonkheer', 'Mlle', 'Ms', 'Mme')

full$Title[full$Title %in% otros_titulos]  <- 'Other'

# Graficamos como sobreviven esas clases
ggplot(full[full$base == "Train",], aes(x = Title, fill = factor(Survived))) +
  geom_bar() +
  facet_wrap(~Sex) + 
  ggtitle("3-way relationship of Title, Pclass, and Survival") +
  xlab("Title") +
  ylab("Total Count") +
  labs(fill = "Survived")



##############

# Mujeres y Niños primero

# Vemos la supervivencia por Edad
ggplot(full[full$base == "Train",], aes(Age, fill = factor(Survived))) + 
  geom_histogram() 

# Podemos crear la variable "Niño" y "Adulto"
full$Child[full$Age < 18] = 'Child'
full$Child[full$Age >= 18] = 'Adult'

# Vemos la distribución
table(full$Child, full$Survived)

# Graficando
Desc(table(full$Child, full$Survived))



##############

# Que sucede si creamos la variable Madre
full$Mother = 'Not Mother'
full$Mother[full$Sex == 'female' & full$Parch > 0 & full$Age > 18 & full$Title != 'Miss'] = 'Mother'

# Vemos la distribución
table(full$Mother, full$Survived)
Desc(table(full$Mother, full$Survived))



