##########################################
# Modelado de Fauna-Hábitat en R
# Creación de mapas en R
# Elaborado por: SMandujanoR
# Última modificación: Junio 24, 2024
###########################################

library(ggplot2)
library(terra)
library(tidyterra)
library(sf)

###################################
# Datos

datos <- read.csv("datos/detecciones.csv", sep = ";", header = T)
View(datos)

# -----
# lo siguiente es para crear tantos renglones como eventos hay por cámara, importante para algunos análisis de densidad kernel de los ejemplos 

dataset2 <- with(datos, datos[rep(1:nrow(datos), Events),])
View(dataset2)


#################################
# EJEMPLO: Tipos de vegetación Casa Blanca:

CBVeg <- vect("shapes/CB/veg.shp")
CBVeg
CBVeg$tipo_Suelo

# Polígono sitio de estudio:
UMA <- vect("shapes/CB/UMA.shp")

plot(CBVeg, fill = T)

# OJO: si se quiere proyectar este mismo mapa en coordenadas LongLat

map2 <- project(CBVeg, "+proj=longlat +zone=14 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")

plot(map2)

# para crear colores:
mi_paletaAri <- c("gold", "deepskyblue2", "darkolivegreen4", "darkolivegreen1", "azure3", "darkorange2")

plot(CBVeg, col = mi_paletaAri, lty = 0, main = "")
plot(UMA, add = T, lwd = 5)
points(datos$X, datos$Y, pch = 16, cex = 2, col = "black")

dev.off()

###################################
# EJEMPLO

ggplot() +
  geom_sf(data = CBVeg, color = "black", fill = NA) +
  geom_point(data = dataset2, aes(X, Y, size = Events), shape = 21, color = "darkorange") +
  ###coord_sf(datum = st_crs(map2))  +
  theme_minimal() +
  theme(legend.position = "none") 

###################################
# EJEMPLO

ggplot() +
  geom_sf(data = CBVeg, color = "skyblue") +
  geom_point(data = dataset2, aes(X, Y, size = Events), shape = 21, color = "darkorange") +
  coord_sf(datum = st_crs(map2)) +
  theme_minimal() +
  theme(legend.position = "none") 

###################################
# EJEMPLO

ggplot(dataset2, aes(x = X, y = Y)) + 
  geom_density_2d_filled(bins = 10) +
  geom_point() +
  theme_minimal() +
  coord_fixed(ratio = 1) + 
  theme(legend.position = "none")

###################################
# EJEMPLO: Mapa densidad kernel

ggplot(dataset2, aes(x = X, y = Y, size = Events)) + 
  geom_density_2d_filled(aes(colour = ..level..)) +
  geom_point() + 
  labs(x = "", y = "", title = "datos todos") +
  theme_minimal() +
  coord_fixed(ratio = 1) + 
  theme(legend.position = "none")  

###################################
# EJEMPLO: otra forma

ggplot() + 
  stat_density_2d(data = datos, aes(X, Y, alpha = ..level.., fill = ..level..), bins = 10, geom = "polygon")  +
  scale_fill_gradientn(colours = terrain.colors(99, rev = T)) +
  geom_sf(data = CBVeg, shape = 21, color = "darkgray", fill = NA) +
  geom_point(data = datos, aes(X, Y, size = Events), shape = 16, color = "black") +
  coord_sf(datum = st_crs(CBVeg)) +
  theme_bw() +
  labs(x = "UTM-X", y = "UTM-Y", title = "Casa Blanca") +
  theme(text = element_text(size = 7)) +
  theme(plot.title = element_text(color = "black", size = 12, face = "bold", hjust = 0.5)) +
  theme(strip.text = element_text(size = 10, color = "black"))


#################################################
# FIN SCRIPT
rm(list = ls()) 
dev.off()
