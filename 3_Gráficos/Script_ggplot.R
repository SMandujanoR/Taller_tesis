################################
# Introducción R y RStudio datos biológicos
# Gráficos en ggplot2
# Salvador Mandujano R
# Última modificación: Marzo 8, 2025
##################################

# Cargar paquetes:

library(ggplot2)
library(ggExtra)
library(tidyverse)

# ---------
# El paquete ggplot2 trae ya un conjunto de datos que uno puede emplear para diferentes propósitos ilustrativos

data("mtcars")
View(mtcars)

ggplot(mtcars, aes(x = wt, y= mpg))

ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_point()

ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_point() + 
  theme_minimal()

# ---------
View("ChickWeight")

ggplot(ChickWeight, aes(x = Time, y = weight)) +
  geom_point(aes(color = Diet, shape = Diet, alpha = 0.5, size = weight)) + 
  theme_classic() 

# ---------
data(iris)
head(iris)

ggplot(iris, aes(Species, y = Petal.Length)) + 
  geom_boxplot(aes(color = Species))

ggplot(iris, aes(Species, y = Petal.Length)) +
  geom_boxplot(aes(fill = Species))

ggplot(iris, aes(Species, y = Petal.Length)) + 
  geom_point(aes(color = Species))

ggplot(iris, aes(Species, y = Petal.Length)) + 
  geom_jitter(aes(color = Species, shape = Species))

ggplot(iris, aes(Species, y = Petal.Length)) + 
  geom_violin(aes(color = "Species"))

ggplot(iris, aes(Species, y = Petal.Length)) + 
  geom_violin() + 
  geom_jitter(aes(color = Species))

ggplot(iris, aes(Species, y = Petal.Length))  +
  geom_jitter(aes(color = Species)) + 
  geom_violin()

# ---------
data("ChickWeight")
View(ChickWeight)

ggplot(ChickWeight, aes(x = Time, y = weight)) + 
  geom_smooth() + 
  geom_point()

ggplot(ChickWeight, aes(x = Time, y = weight)) +
  geom_smooth(aes(fill = Diet)) +
  geom_point(aes(color = Diet))  +
  facet_wrap(~Diet)

ggplot(ChickWeight, aes(x = Time, y = weight)) +
  geom_point(aes(color = Diet)) +
  geom_line(aes(color = Diet, group = Chick))  +
  facet_wrap(~Diet)

ggplot(ChickWeight, aes(x = Time, y = weight)) + 
  geom_point(aes(color = Diet)) +
  geom_line(aes(color = Diet, group = Chick)) +
  facet_wrap(~Diet)

# ---------
# FIN SCRIPT
rm(list = ls()) 
dev.off()
