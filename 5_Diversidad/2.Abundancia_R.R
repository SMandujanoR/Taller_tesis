################################
# Introducción a R y RStudio para datos biológicos
# Ejemplos de análisis de la abundancia
# Basado en: Arturo Zavaleta
# Modificado por: Salvador Mandujano R
# Última modificación: Marzo 11, 2025
##################################

# Cargas las librerias 
library(vegan)
library(ggplot2)
library(BiodiversityR)

# Datos
datos <- read.csv("datos/IAR-MAMIFEROS.csv", header = T)
View(datos)

mamiferos <- datos[,-c(1,2,3)]
head(mamiferos)

sitios  <- datos[, c(1,2,3)] 
head(sitios)

# Abundancia de mamíferos
boxplot(mamiferos,
        ylab = "Abundancia", 
        xlab = "", 
        las = 3,
        frame.plot = F,
        col = "mediumpurple")

# Separar las especies pertenecientes a cada sitio
par(mfrow = c(2,1))

S1 <- datos[datos$sitios=="Sitio-1",] 
head(S1)

S1.1 <- S1[,-c(1,2,3)] # solamente las especies
S1.1

S2 <- datos[datos$sitios=="Sitio-2",] 
S2.1 <-S2[,-c(1,2,3)] 

## Curvas de rango abundacia
(RA.S1 <- rankabundance(S1.1)) 
(RA.S2 <- rankabundance(S2.1)) 

# gráfico de las curvas utilizando "logabun"
rankabunplot(RA.S1, 
             scale = "logabun", 
             addit = F, 
             specnames = c(1:15), 
             col= "deepskyblue1", 
             lwd = 3, 
             srt = 32, 
             cex= 2, 
             las= 1, 
             ylim = c(3,210), 
             xlim = c(1,40), 
             type = "o", 
             pch = 16,
             xaxt = "n")

par(new = TRUE)
rankabunplot(RA.S2,
             scale = "logabun",
             addit = F, 
             specnames = c(1:16), 
             col= "coral", 
             xlim = c(-28,20), 
             type = "o", 
             pch =19, 
             lwd = 3, 
             srt = 45, 
             cex= 2,
             las= 1, 
             ylim = c(3,210), 
             axes=FALSE, 
             xaxt = "n", 
             cex.lab = 1.0, 
             cex.axis = 1.0)

# -------
# Separar las especies pertenecientes a cada sitio

Cons_S1 <- datos[datos$Zona=="Conservada-01",] 
Cons_S1.1 <- Cons_S1[,-c(1,2,3)] # solamente las especies

Per_S1 <- datos[datos$Zona=="Perturbada-01",] 
Per_S1.1 <- Per_S1[,-c(1,2,3)] # solamente las especies

## Curvas de rango abundacia
(RA.S1 <- rankabundance(Cons_S1.1)) 
(RA.S2 <- rankabundance(Per_S1.1)) 

# gráfico de las curvas utilizando "logabun"
rankabunplot(RA.S1, 
             scale = "logabun", 
             addit = F, 
             specnames = c(1:15), 
             col= "darkblue", 
             lwd = 3, 
             srt = 32, 
             cex= 2, 
             las= 1, 
             ylim = c(3,210), 
             xlim = c(1,40), 
             type = "o", 
             pch = 16,
             xaxt = "n",
             main = "Sitio-1")

par(new = TRUE)
rankabunplot(RA.S2,
             scale = "logabun",
             addit = F, 
             specnames = c(1:16), 
             col= "darkorange", 
             xlim = c(-28,20), 
             type = "o", 
             pch =19, 
             lwd = 3, 
             srt = 45, 
             cex= 2,
             las= 1, 
             ylim = c(3,210), 
             axes=FALSE, 
             xaxt = "n", 
             cex.lab = 1.0, 
             cex.axis = 1.0)

legend(6, 200, c("Conservado","Perturbado"),
       fill = c("darkblue", "darkorange"))

#########################
# Gráfico de burbuja con las abundancias 
abundancia<- read.csv("datos/burbuja.csv",header = T)
View(abundancia)

ggplot(abundancia, aes(x = Zona, color = Zona, y = especies, size = iar)) +
    geom_point(shape = 16, fill = "black", aes(size = iar)) +
    theme_classic() +
    scale_size_area(max_size = 20) +
    labs(x = "", y = "Especies")

######################
# FIN SCRIPT

rm(list = ls()) 
dev.off()



