##########################################
# Modelado de Fauna-Hábitat en R
# Creación de mapas en R
# Elaborado por: SMandujanoR
# Última modificación: Junio 24, 2024
# Amer
###########################################

library(terra)
library(maps)
library(prettymapr)
library(RColorBrewer)
library(ggplot2)
library(tidyterra)

##########################
# Leer datos:

# Tipos de vegetación de Rzedowski en México
VegRzed <- vect("shapes/VegMex/vpr4mgw.shp")

mios <- c("palegreen3", "deepskyblue2", "lightcyan2", "darkolivegreen1", "palegreen4", "darkorange2", "bisque2", "tan1", "maroon1", "slateblue1")

# mapa distribución potencial venado cola blanca:
venado <- vect("shapes/DistVenado/10percentilov.shp")
plot(venado, col = alpha("skyblue", 0.7), border = F) 

# datos de presencia de venados en México
puntos_presencia <- read.table("datos/registros_VCB.txt", header = T)

#########################
# EJEMPLO

plot(VegRzed, fill = T)
plot(venado, add = T, col = alpha("skyblue", 0.7), border = F) 
points(puntos_presencia$Longitud, puntos_presencia$Latitud, pch = 16, col = "black", cex = 1)

##############################
# EJEMPLO: Guardar imagen

jpeg(filename= "Mapa.jpg", width= 8000, height= 7000, units= "px", res=600)

# capa de México
map("world", xlim = c(-118.4, -86.7), ylim = c(14.5, 32.7), col= "snow2", fill = T)
map.axes()
addscalebar(htin = 0.05, padin = c(0.05, 0.05), pos = "bottomleft")
addnortharrow("bottomleft")

# capa distribución potencial
plot(venado, add = T, col = alpha("skyblue", 0.7), border = F) 

# capa registros
points(puntos_presencia$Longitud, puntos_presencia$Latitud, pch = 16, col = alpha("darkred", 0.6), cex = 0.7)

# Agregar países
legend("top", legend = "USA", cex = 2, bty = "n")
legend("bottomright", legend = "Central America", cex = 2, bty = "n")
legend("center", legend = "Mexico", cex = 2, bty = "n")

legend("topright", legend = c("Distribución potencial","Registros presencia"), pch = c(15,16), cex = 1.5, col = c(alpha("skyblue", 0.6), alpha("darkred", 0.6)), bg = "white", bty = "n")

dev.off()

#################################
# EJEMPLO: RBTC en México

RBTC <- vect("shapes/RBTC/delimitacion_rbtc.shp")
RBTC2 <- vect("shapes/RBTC/RBTC.shp")

# capa de país
map("world", "Mexico", xlim = c(-118.4, -86.7), ylim = c(14.5, 32.7), col= "snow2", fill = T)
plot(RBTC, add = T, col = alpha("black", 1), border = F) 
map.axes()
addscalebar(htin = 0.05, padin = c(0.05, 0.05), pos = "bottomright")
addnortharrow("topright")

#################################
# EJEMPLO: RBTC + Distribución venado

plot(RBTC2)
plot(venado, add = T, col = alpha("skyblue", 0.8), border = F) 
points(puntos_presencia$Longitud, puntos_presencia$Latitud, pch = 16, col = alpha("darkred", 0.8), cex = 2)
plot(RBTC, add = T, lwd = 5)

#####################################
# EJEMPLO: Cortar vegetación de México el sitio de estudio

RBTC2

plot(VegRzed, "CLAVES", col = mios)
plot(RBTC, add = T, col = alpha("black", 1), border = F)

plot(VegRzed, "TIPOS", col = mios, fill = T, xlim = c(-97.80, -96.70), ylim = c(17.50, 18.90))
plot(RBTC, lwd = 5, add = T)

#####################################
# EJEMPLO: para cortar

(RBTC_inter <- terra::crop(VegRzed, RBTC))

plot(RBTC_inter, "TIPOS") # OJO con los colores...

plot(RBTC_inter, "TIPOS", col = mios)

# para calcular el área de cada tipo de vegetación en la RBTC

(datos <- terra::expanse(RBTC_inter))

(hectareas <- round(datos/10000, 0))

sum(hectareas) # superficie total RBTC

sup <- data.frame(Tipo_vegetación = RBTC_inter$TIPOS, hectáreas = hectareas)

(supRBTC <- sup %>% 
  group_by(Tipo_vegetación = RBTC_inter$TIPOS) %>%        
  summarise(Superficie = sum(hectáreas)))


###################################
# FIN SCRIPT
rm(list = ls())
dev.off()
