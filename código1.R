###############################
# Curso de Introducción a la Investigación
# Módulo R: SMandujanoR
# Sep 28, 2020
# Este es mi primer Script R
###############################

# Cargar paquetes:
library(maptools)

# ------------------
# ejemplo 1
a <-  2 + 3

b <- 56^2

resultado <- a * b

# ---------------
# ejemplo 2 vector

(mi_obervaciones <- c(23, 4, 6, 8, 21, 43, 7, 9, 10,16, 18, 25))

mi_obervaciones

e <- mi_obervaciones*45

(promedioDAP <- mean(mi_obervaciones))
promedioDAP
SD <- sd(mi_obervaciones)

datos_estand <- mi_obervaciones - promedioDAP / SD

class(datos_estand)

# -------------------

arbol <- c("a1","a2","a3","a4","a5","a6","a7","a8","a9","a10","a11","a12","a13")
class(arbol)

mis_datos <- cbind(arbol, mi_obervaciones, datos_estand)
mis_datos
#View(mis_datos)

#write.csv(mis_datos, "mis_datos.csv")

# etctctctctctctctct

# leer mis datos

datos <- read.csv("mis_datos.csv", header = T)
View(datos)
head(datos)
tail(datos)
names(datos)
class(datos)


###############################
### FIN SCRIPT

rm(list = ls()) # limpiar memoria o borrar datos
dev.off() # borrar gráficos

