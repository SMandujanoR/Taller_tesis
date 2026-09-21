################################
# Introducción a R y RStudio para datos biológicos
# Exploración de la data.frame
# Datos de prueba no reales (S. Zalapa-Hernández)
# Profesor: Salvador Mandujano R
# Última modificación: Marzo 8, 2025
##################################

# EJERCICIO 1.
# Leemos los datos:
datos <- read.csv("datos_1.csv", header = T)

class(datos)
names(datos)
dim(datos)
str(datos)

# exploramos la data.frame:
View(datos)
head(datos)
tail(datos)
datos[,1]
datos[,1:3]
datos[1,]
datos[35:45,]
datos[103,5]
datos[123,2]

unique(datos$Año)
unique(datos$Especie)
unique(datos$ANP)
unique(datos$Localidad)
unique(datos$Tipo_Vegt)

datos$Especie <- gsub("dermanura phaeotis", "Dermanura phaeotis", datos$Especie)
head(datos$Especie,50)

#####################################
# EJERCICIO 2.
# contar el número de registros de cada especie:

Spp <- factor(datos$Especie)
summary(Spp)
# lo mismo pero con otra función:
table(datos$Especie)

# calculamos las proporciones
(Spp_Prop <- prop.table(summary(Spp))*100)
(Spp_Prop <- round(Spp_Prop, 2)) 
(Spp_Ordenadas <- Spp_Prop[order(Spp_Prop)])
(Spp_Reversadas<-rev(Spp_Ordenadas))

#####################################
# EJERCICIO 3.
# creamos gráficos de los conteos por especie:

plot(Spp)

# mejoramos el gráfico
plot(Spp, col = "dodgerblue")

plot(Spp, col = "dodgerblue", main = "Especies de quirópteros")

plot(Spp, col = "dodgerblue", main = "Especies de quirópteros", horiz = T)

plot(Spp, col = "dodgerblue", main = "Especies de quirópteros", horiz = T, las = 1)

par(mfrow=c(1,1), mar= c(5,15,3,3))

plot(Spp, col = "dodgerblue", main = "Especies de quirópteros", horiz=T, las = 1, xlab = "Conteos")

# Otra manera de hacer este gráfico

barplot(Spp_Ordenadas, col = "darkorange3", main = "Especies de quirópteros", horiz=T, las = 1, xlab = "Proporción de conteos")

# visualizar ambos gráficos

par(mfrow=c(1,2), mar= c(5,15,3,3))

plot(Spp, col = "dodgerblue", main = "Especies de quirópteros", horiz=T, las = 1, xlab = "Conteos")

barplot(Spp_Ordenadas, col = "darkolivegreen1", main = "Especies de quirópteros", horiz=T, las = 1, xlab = "Proporción de conteos")


#####################################
# EJERCICIO 4.
# vamos a crear un gráfico de pay con estos mismos datos:

(Spp_PropMatx <- as.matrix(Spp_Prop))
length(Spp_PropMatx)

par(mfrow=c(1,1), mar= c(3,3,3,3))
pie(Spp_PropMatx, col = terrain.colors((25)), main = "Especies de quirópteros")

# pongamos los nombres de las especies y sus porcentajes:
especies <- paste(c(rownames(Spp_PropMatx)), ":", Spp_PropMatx[,1])

pie(Spp_PropMatx, col = terrain.colors((25)), main = "Especies de quirópteros", labels = especies)

###############################
# EJERCICIO 5.
# En muchos casos conviene abreviar los nombres científicos lo cual ayuda mucho para los diferentes análisis y gráficas

library(fuzzySim)

datos$Especie <- spCodes(datos$Especie, sep.spcode = "_")
View(datos)

Spp <- factor(datos$Especie)

par(mfrow=c(1,1), mar= c(5,7,3,3))
plot(Spp, col = "dodgerblue", main = "Especies de quirópteros", horiz=T, las = 1, xlab = "Conteos")

#####################################
# Es frecuente que tengamos data.frame muy grande... como en este caso 3688 registros (renglones) 25 especies y 6 columnas (hay situaciones donde pueden ser decenas de columnas).

# Para esos casos, Y DEPENDIENDO DE LOS OBJETIVOS, puede ser muy útil crear subconjuntos de esos datos.

# Aquí ejemplificamos para una especie Artibeus_lituratus:

# Leemos los datos:
datos <- read.csv("datos_1.csv", header = T)

Art_jam <- subset(datos, Especie =="Artibeus jamaicensis")
head(Art_jam); tail(Art_jam)

# a veces conviene guardar ese subconjunto:
write.csv(Art_jam, "Artibeus jamaicensis.csv")

#############################
# EJERCICIO 6.

# Con los datos de esta especie se analizarán otras columnas creando tablas de frecuencia y sus correspondientes gráficos...

# la noticia es que eso: LO REALIZARÁ CADA UNO DE USTEDES... AHORITA MISMO EN CLASE... DEMOS 15-20 MINUTOS!

# "TIP": crea un objeto en cada caso seleccionando la columna de cada caso y luego grafica ese objeto... Resolviendo el inciso a) te vas rápido con los restantes incisos...!

# Los ejercicios son:

# a) Tabla y gráfico de los conteos de esta especie en cada año:

# b) Tabla y gráfico de los conteos de esta especie en cada tipo de vegetación:

# c) Tabla y gráfico de los conteos de esta especie en cada localidad:

# d) Tabla y gráfico de los conteos de esta especie en cada tipo de vegetación:

# e) Tabla y gráfico de los conteos de esta especie a diferentes altitudes. Este es el ejercicio "más complicado" pues la altitud es una variable continua, es decir ¿Cómo podrían representar estos resultados en forma de tabla y luego graficarlos?:

# --------
# punto extra al que embellezca las gráficas...!!!

# Al terminar harán una compilación en HTML la cual guardarán poniendo su NOMBRE y me lo van enviar de preferencia HOY MISMO...!

#####################################
# FIN SCRIPT
rm(list = ls())
dev.off()

