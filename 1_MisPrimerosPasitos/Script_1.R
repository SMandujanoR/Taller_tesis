################################
# Introducción a R y RStudio para datos biológicos: Mis primeros pasitos...
# Presentación: Salvador Mandujano R
# Ejemplos: Eva López-Tello
# Última modificación: Marzo 7, 2025
##################################

# Creación de un objeto:

manzanas <- 20 + 15
manzanas
(manzanas <- 20 + 15)
class(manzanas)

# Ejemplos de clases de objetos 

(Abies_religiosa <- "Jaugueri")
class(Abies_religiosa)

numerico <- 50.6
class(numerico)

entero <- 2022
class(entero)
Entero <- factor(entero)
class(Entero)

complejo <- 1i
class(complejo)

logico <- 3 < 2
logico
class(logico)

# -------------
# Ejemplos de estructura de datos

### Vectores

conteo_zorras <- c(2, 5, 7, 9, 20, 23, 23, 45, 66)
conteo_zorras
length(conteo_zorras)

(nombres <- c("Alberto", "Carolina", "Fernanda"))
is.vector(nombres)

vector_logico <- c(FALSE, TRUE, T, F)
is.vector(vector_logico)

### Matrices

Matriz_numerica <- matrix(1:12, nrow = 4)
Matriz_numerica

automoviles <- matrix(1:12, nrow = 4, byrow = TRUE, dimnames = list(c("Sp4", "Sp1", "Sp2", "Sp3"), c("San_Juan", "Autlán", "San_Pedro")))
automoviles

### Data.frame

sexo <- c("Macho", "Hembra", "Macho", "Hembra")
nombre <- c("Nom1", "Nom2", "Nom3", "Nom4")
peso <- c(70, 60, 57, 50)
edad <- c(3, 4, 3, 2)

venados <- data.frame(nombre, peso, sexo)
venados
class(venados)
dim(venados)
colnames(venados)

### Listas

lista_1 <- list(1:15, c("Alicia", "Ruben"), pi, c(TRUE, FALSE), list(c(-10, -15)))
lista_1
lista_1 [[1]]
lista_1 [[5]]

# -----------------
# Ejemplo de algunas funciones ya cargadas en el programa inicial R

###  Función para leer archivo:

tabla_1 <- read.csv("datos/Spp_CTs.csv", header = TRUE)

### Función para ver resumen:
View(tabla_1)
class(tabla_1)
names(tabla_1)
length(tabla_1$Especie)
unique(tabla_1$Especie)

summary(tabla_1)

### Función para obtener el número total de fotos por especie:

tabla_2 <- tapply(tabla_1$No_Fotos, tabla_1$Especie, sum)
tabla_2
barplot(tabla_2, col = "chocolate")

### Función para guardar archivo *.csv:

write.csv(tabla_2, "datos/total_fotos_especies.csv") # Observe en dónde se guardó este nuevo archivo.

# --------------
# Paquetes R

### Instalar paquete (esto se hace solo una vez):
install.packages("camtrapR")

### Cargar el paquete: 
library("camtrapR") 

### Leer los archivos que voy a utilizar en la función:

camaras <- read.csv("datos/actividad_cam.csv", header = T)
View(camaras)

registros <- read.csv("datos/registros.csv", header = T)
View(registros)

### Ejecutamos una de las funciones de este paquete, por ejemplo `detectionMaps`:

detectionMaps(CTtable = camaras,
              recordTable  = registros,
              Xcol         = "X",
              Ycol         = "Y",
              stationCol   = "Station",
              speciesCol   = "Species",
              printLabels  = TRUE,
              richnessPlot = TRUE,
              speciesPlots = FALSE,
              addLegend    = TRUE)

# ------------
# FIN SCRIPT

# Funciones para borrar la consola y los graficos
rm(list = ls()) 
dev.off()
