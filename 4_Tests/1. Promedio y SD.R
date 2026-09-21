################################
# Introducción a R y RStudio para datos biológicos
# Estadística básica
# Salvador Mandujano R
# Última modificación: Marzo 8, 2025
##################################

# Problema: calcular el promedio y desviación estándar del número de venados contados en 10 transectos de 1000 m cada uno ubicados en el área de estudio.

# número de transectos 
nt <- 10

# conteos de venados en cada transecto
Venados_transecto <- c(3,4,5,2,6,3,3,4,7,2) 

# -------
# 1. Manera "larga" de resolver

# cálculo del promedio
total <- sum(Venados_transecto)
(promedio <- total/nt)

# cálculo de la desviación estándar (SD)
subtotal <- 0  

for (i in 1:nt) {
  subtotal[i] <- ((Venados_transecto[i] - promedio)^2)
} 

(SD <- sqrt(sum(subtotal)/(nt-1)))

# para visualizar los resultados
promedio 
SD

# -------
# 2. Manera "corta" de resolver

# promedio
(promedio <- mean(Venados_transecto)) 

# si queremos redondear
(promedio <- round(mean(Venados_transecto),0)) 

# SD
(SD <- sd(Venados_transecto)) 

# -----------------
# FIN DE SCRIPT

rm(list = ls()) # elimina datos
dev.off() # elimina gráficos
