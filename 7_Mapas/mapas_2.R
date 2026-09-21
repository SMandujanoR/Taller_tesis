##########################################
# Modelado de Fauna-Hábitat en R
# Creación de mapas en R
# Elaborado por: SMandujanoR
# Última modificación: Junio 24, 2024
###########################################

# Cargar paquetes:

library(terra)
library(maps)
library(prettymapr)
library(RColorBrewer)
library(ggplot2)
library(tidyterra)

##########################
# Tipos de vegetación de Rzedowski en México

VegRzed <- vect("shapes/VegMex/vpr4mgw.shp")
VegRzed
names(VegRzed)
VegRzed$TIPOS
VegRzed$CLAVES
unique(VegRzed$CLAVES)

plot(VegRzed)

#########################
# EJEMPLO 

par(mfrow = c(2,1), mar = c(2,2,2,2))

plot(VegRzed, "TIPOS", col = terrain.colors(10), cex = 0.5)
plot(VegRzed, "CLAVES", col = terrain.colors(10))

#########################
# EJEMPLO 

###plot(VegRzed, col = rainbow(25))

#########################
# EJEMPLO 

mios <- c("seagreen1", "deepskyblue2", "lightcyan2", "darkolivegreen1", "palegreen4", "darkorange2", "bisque2", "tan1", "maroon1", "slateblue1")

par(mfrow = c(1,1), mar = c(2,2,2,2)) 
plot(VegRzed, "CLAVES", col = mios)

##########################
# EJEMPLO

ggplot(VegRzed) +
  geom_spatvector()

#########################
# EJEMPLO 

ggplot(VegRzed) +
  geom_spatvector(aes(fill = VegRzed$TIPOS), color = NA) +
  scale_fill_viridis_d()

#########################
# EJEMPLO 

ggplot(VegRzed) +
  geom_spatvector(aes(fill = VegRzed$CLAVES), color = NA) +
  scale_fill_manual(values = mios)

############################
# EJEMPLO

# para extraer y graficar un tipo particular
BTC <- subset(VegRzed, VegRzed$CLAVES == "Btc")
BTC

map("world", xlim = c(-118, -89), ylim = c(15, 33), col= "white", fill = T)
plot(BTC, add = T, col = "pink")
map.axes()
addscalebar(htin = 0.05, padin = c(0.05, 0.05), pos = "bottomleft")
addnortharrow("topright")

##########################
# FIN SCRIPT
rm(list = ls())
dev.off()
