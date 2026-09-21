################################
# Introducción a R y RStudio para datos biológicos
# Ejemplos de análisis de la riqueza
# Basado en: Arturo Zavaleta
# Modificado por: Salvador Mandujano R
# Última modificación: Marzo 11, 2025
##################################
  
# Cargar y explorar los datos

datos <- read.csv("datos/IAR-MAMIFEROS.csv", header = T)
View(datos)

# exploramos 
head(datos)     # Muestra las primeras 6 filas
tail(datos)     # Muestra las últimas 6 filas
nrow(datos)     # Número de filas (sitios)
ncol(datos)     # Número de columnas (todas las columnas)
dim(datos)      # Dimensiones de la base de datos (filas y columnas)
colnames(datos) # Nombres de las columnas (especies)
rownames(datos) # Nombres de las filas (sitios)

# Separar datos de mamíferos y sitios
mamiferos <- datos[,-c(1,2,3)]
View(mamiferos)

sitios <- datos[, c(1,2,3)]
View(sitios)

# Exploración  de las especies de mamíferos
range(mamiferos) # valores mínimos y máximos de abundacia

# valores mínimos y máximos para cada especie
apply(mamiferos,2, range)   

#  Número de ausencias
sum(mamiferos == 0)         

# Proporción de ceros en la base de datos
sum(mamiferos == 0) / (nrow(mamiferos) * ncol(mamiferos)) 

# Gráfica de barras de todas las especies
###(ab <- table(unlist(mamiferos)))
###barplot(ab, las=1, xlab = "Clase de abundancia", ylab = "Frecuencia", col = gray(5:0/5))

# Cargamos las coordenadas geograficas de los sitios
coor <- read.csv("datos/coordenadas.csv", header = T)
View(coor)

# panel para cuatro gráficos en uno solo
par(mfrow = c(2,2)) 

plot(coor, 
     asp = 1, 
     cex.axis = 0.8,
     col = "red",
     cex = mamiferos$Can_lat, 
     main = "Coyote", 
     xlab = "x coordinate (km)", 
     ylab = "y coordinate (km)")

plot(coor, 
     asp = 1,
     cex.axis = 0.8, 
     col= "red",
     cex = mamiferos$Uro_cin, 
     main = "Zorra gris", 
     xlab = "x coordinate (km)", 
     ylab = "y coordinate (km)")

plot(coor, 
     asp = 1, 
     cex.axis = 0.8,
     col = "red",
     cex = mamiferos$Pum_con, 
     main = "Puma", 
     xlab = "x coordinate (km)", 
     ylab = "y coordinate (km)")

plot(coor, 
     asp = 1,
     cex.axis = 0.8, 
     col = "red",
     cex = mamiferos$Lyn_ruf, 
     main = "Lince", 
     xlab = "x coordinate (km)", 
     ylab = "y coordinate (km)")

## Comparar especies número de presencias

# Calcula el número de sitios donde cada especie está presente
mamiferos.pres <- apply(mamiferos > 0, 2, sum) 

# Ordena los resultados en orden creciente
sort(mamiferos.pres)   

# Calcula el porcentaje de frecuencias
mami.frec <- 100 * mamiferos.pres/nrow(mamiferos)  
# Redondea el resultado ordenado a 1 dígito
round(sort(mami.frec), 1)     

# Histogramas
par(mfrow = c(1,2))

hist(mamiferos.pres, 
     main = "Ocurrencias de especies", 
     right = FALSE, las = 1, 
     xlab = "Número de ocurrencias", 
     ylab = "Número de especies",
     col = "skyblue"
     )

hist(mami.frec, 
     main = "Frecuencia relativa de especies", 
     right = FALSE, 
     las = 1,
     xlab = "Frecuencia de occurrencias (%)", 
     ylab = "Número de especies",
     breaks = seq(0, 100, by = 5),
     col = "chocolate2"
)

###########################
# Vamos a estimar índices de diversidad

# Cargar las librerias 
library(vegan)
library(tidyverse)
library(BiodiversityR)

# Cálculo de la riqueza de las muestra
vegan::specnumber(colSums(mamiferos))

# Comparar sitios: riqueza de especies
sit.pres <- apply(mamiferos >0, 1, sum)

#  Ordena los resultados en orden ascendente
sort(sit.pres)   

# Gráfica la riqueza de especies vs la posición de los sitios
par(mfrow = c(1, 1))

plot(sit.pres,
     type = "h",
     las = 1, 
     lwd = 4,
     col = "skyblue",
     main = "Riqueza de especies",
     xlab = "Número de sitios", 
     ylab = "Riqueza de especies",
     frame.plot = F
)
text(sit.pres, row.names(mamiferos), cex = 1.5, col = "red")

# Usar las coordenadas geográficas para gráficar un mapa de burbujas

plot(coor, 
     asp = 1, 
     main = "Mapa de riqueza de especies", 
     pch = 21, 
     col = "white", 
     bg = "brown", 
     cex = 10 * sit.pres / max(sit.pres), 
     xlab = "coordenada X (km)", 
     ylab = "coordenada Y (km)",
     frame.plot = F
)

# Utilizando la función **specnumber** podemos gráficar la riqueza de especie por sitio o por zona
boxplot(specnumber(mamiferos)~ sitios$Zona, 
        col = "steelblue",
        frame.plot = F
)

## Curva de acumulación de especies general
curva1 <-specaccum(mamiferos, method = "exact", ylim(0, 20))
curva1
plot(curva1)

plot(curva1, 
     xlab = "Unidades muestreo", 
     ylab = "Número de especies", 
     col = "tomato",
     cex = 2,
     frame.plot = F)
points(curva1$richness, 
       pch= 19, 
       col= "darkred")


# Curvas de acomulación de especies por sitio
curva2 <- accumcomp(mamiferos, 
                    y= sitios, 
                    factor = "sitios", 
                    method = "exact", 
                    legend = F, 
                    conditioned = T, 
                    xlim = c(0, 23), 
                    rainbow = T, 
                    xlab = "sitios",
                    ylab = "riqueza de mamiferos",
                    main= "Curva de acumulacion de especies por sitio"
)
legend(5, 4, c("Sitio1","Sitio2"),
       fill = c("darkred", "darkgreen"))

# --------------
# Curvas de acomulación de especies por sitio ggplot

library(ggplot2)
curva2 <- accumcomp(mamiferos, 
                    y = sitios, 
                    factor = "sitios", 
                    method = "exact", 
                    conditioned = F, 
                    plotit = F)

curva3 <- accumcomp.long(curva2, 
                         ci = NA, 
                         label.freq = 19)

ggplot(curva3, aes(x = Sites, y = Richness, ymax =  UPR, ymin = LWR)) +  
    scale_x_continuous(expand=c(0, 1), sec.axis = dup_axis(labels = NULL, name = NULL)) +
    scale_y_continuous(sec.axis = dup_axis(labels = NULL, name = NULL)) +
    geom_line(aes(colour = Grouping), size = 2) +
    geom_point(data=subset(curva3, labelit==TRUE),
               aes(colour = Grouping, shape = Grouping), size = 5) +
    geom_ribbon(aes(colour = Grouping), alpha = 0.2, show.legend = FALSE) +
    theme_bw()

###################
# FIN SCRIPT

rm(list = ls()) 
dev.off()



