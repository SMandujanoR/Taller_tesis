##########################################
# Modelado de Fauna-Hábitat en R
# Creación de mapas en R
# Elaborado por: SMandujanoR
# Última modificación: Junio 24, 2024
###########################################

# Cargar paquetes

library(ggplot2)
library(maps)
library(prettymapr)
library(RColorBrewer)

##############################
# EJEMPLO 1: con paquete ggplot2

# Mundial

mundial <- map_data("world")
View(mundial)
unique(mundial$region)

ggplot(mundial, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="white", colour="black")

ggplot(mundial, aes(x=long, y=lat, group=group)) +
  geom_path() + coord_map("mercator")

# ----------
# Mexico (145)

mexico <- map_data("world", region = "Mexico")

ggplot(mexico, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="white", colour="black")

ggplot(mexico, aes(x=long, y=lat, group=group)) +
  geom_path(fill="white", colour="black") + 
  coord_map("mercator")

# ----------
# Paraguay (189)

Paraguay <- map_data("world", region = "Paraguay")

ggplot(Paraguay, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="white", colour="black")

ggplot(Paraguay, aes(x=long, y=lat, group=group)) +
  geom_path(fill="white", colour="black") + 
  coord_map("mercator")


###############################
# EJEMPLO 2: con el paquete maps

# mundial
map()
map.axes()
map(wrap = c(0,360), fill = TRUE, col = 3)
map.axes()

# Canada
map("world", "Canada", col= "gray90", fill = T)

map("world", "Canada", xlim = c(-140,-110), ylim = c(48,64), col= "gray90", fill = T)

# Paraguay
map("world", "Paraguay", col= "cornflowerblue", fill = T)
title("Paraguay")
map.axes()

# Cortar a México
map("world", xlim = c(-118.4, -86.7), ylim = c(14.5, 32.7), col= "white", fill = T)
map.axes()
addscalebar(htin = 0.05, padin = c(0.05, 0.05), pos = "bottomleft")
addnortharrow("bottomleft")

# ----------------------
# FIN SCRIPT
rm(list = ls())
dev.off()
