################################
# Introducción a R y RStudio para datos biológicos
# Ejemplos de análisis de la diversidad
# Basado en: Arturo Zavaleta
# Modificado por: Salvador Mandujano R
# Última modificación: Marzo 11, 2025
##################################

# Paquetes
library(ade4)
library(vegan)
####library(vegetarian)
library(ggplot2)

# Datos
datos <- read.csv("datos/IAR-MAMIFEROS.csv", header = T)

# Separar datos de mamíferos y sitios
mamiferos <- datos [,-c(1,2,3)]
head(mamiferos)

sitios <- datos [, c(1,2,3)]
head(sitios)

# Riqueza de especies
(N0 <- rowSums(mamiferos > 0))

# Riqueza de especies alternativa
(N0 <- specnumber(mamiferos))           

# Shannon entropy (base e)
(H <- diversity(mamiferos))             

# Shannon entropy (base 2)
(Hb2 <- diversity(mamiferos, base = 2)) 

# Shannon diversity (base e) 
(N1 <- exp(H))                     

# Shannon diversity (base 2)
(N1b2 <- 2^Hb2)                   

# Simpson diversity
(N2 <- diversity(mamiferos, "inv"))          

# Pielou evenness
(J <- H / log(N0))                

# Shannon evenness (Hill's ratio)
(E10 <- N1 / N0)                  

# Simpson evenness (Hill's ratio)
(E20 <- N2 / N0)                  


# hacemos una data.frame con los índices  
(diversidad <- data.frame(N0, H, Hb2, N1, N2, J))

# Cargamos las covariables 
covariables <- read.csv("datos/variables.csv", header = T)
head(covariables)

# Creamos un data.frame
unidos <- data.frame(cbind(covariables, diversidad))
View(unidos)

# Guardamos la tabla
write.csv (unidos, "datos/diversidad_mamiferos.csv")

#####################
###datos <- read.csv("datos/diversidad_mamiferos.csv", header = T)
####################

# Gráfico de anovas

attach(unidos)

boxplot(N0 ~ Zona,
        main = "Diversidad N0 ***", 
        las = 1, 
        frame = F,
        ylab = "N0", 
        xlab = "Sitios", 
        col = 2:4, 
        varwidth=TRUE)

boxplot(N1 ~ Zona, 
        main = "Diversidad N1 ***", 
        las = 1, 
        frame = F,
        ylab = "N1", 
        xlab = "Sitios", 
        col =2:4, 
        varwidth = TRUE)

boxplot(N2 ~ Zona, 
        main = "Diversidad N2 ***", 
        las = 1, 
        frame = F,
        ylab = "N2", 
        xlab = "Sitios", 
        col = 2:4, 
        varwidth = TRUE)

###########################
# FIN SCRIPT

rm(list = ls()) 
dev.off()





