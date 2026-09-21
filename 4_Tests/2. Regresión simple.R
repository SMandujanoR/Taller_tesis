################################
# Introducción a R y RStudio para datos biológicos
# Estadística básica
# Salvador Mandujano R
# Última modificación: Marzo 8, 2025
##################################

# IMPORTANTE: R nos sirve mucho siempre y cuando tengamos muy claro qué es lo que queremos resolver...!

##################################
# REGRESIÓN LINEAL SIMPLE
# y = a + b*x 
# donde:
# x = variable independiente
# y = variable dependiente
# parámetros a estimar: "a" (ordenada al origen) y "b" (pendiente)
# ----------------
# Otras maneras de entender un modelo es:
# y = determínistica + estocástica
# y = media + variación
# y = media + error
# donde el error = Normal o guassiano
##################################

# Ejemplo hipotético de la relación entre la profundidad del agua (en centímetros) y el número de individuos de una ranaX. En este caso hipotético conteo del número de ranas en 20 unidades de muestreo (charcos). 

# ¿Hay relación entre el número de ranas y la profundidad de las charcas?

#  Modelo lineal:
# No_ranas = a + b * Profundidad_charco + e
# e ~ Norm(0, sigma)

# -----------------------------
# datos del muestreo
(Profundidad_charco <- c(15, 39, 24, 19, 29, 49, 59, 36,64, 49, 35, 38, 18, 47, 31, 47, 51, 48, 35, 52))

(No_ranas <- c(3, 16, 6, 11, 5, 16, 16, 13, 16, 19, 11, 9, 9, 17, 13, 17, 19, 15, 9, 17))

# podemos visulalizar en forma de "tabla"
(datos <- cbind(charco = rep(1:20), Profundidad_charco, No_ranas))
View(datos)

# -----------------------------
# Siempre es recomendable observar los datos de manera gráfica

# Esta instrucción es para abrir un panel de 1 renglón y 1 columna para un solo gráfico... 
par(mfrow= c(1,1))
###par(mfrow= c(2,3))

plot(Profundidad_charco, No_ranas)

plot(Profundidad_charco, No_ranas, pch = 16)

plot(Profundidad_charco, No_ranas, pch = 16, cex = 2)

plot(Profundidad_charco, No_ranas, pch = 16, cex = 2.5, col = "skyblue", las = 1)

plot(Profundidad_charco, No_ranas, pch = 16, cex = 2, col = "skyblue", las = 1, xlab = "Profundidad agua (cm)", ylab = "Número de ranas")

plot(Profundidad_charco, No_ranas, pch = 16, cex = 2, col = "skyblue", las = 1, xlab = "Profundidad agua (cm)", ylab = "Número de ranas", frame.plot = F)

plot(Profundidad_charco, No_ranas, pch = 16, cex = 2, col = "tan1", las = 1, xlab = "Profundidad agua (cm)", ylab = "Número de ranas", frame.plot = F, main = "Mi primer gráfico en R....!")

# es común verlo así
plot(Profundidad_charco, No_ranas, 
     pch = 16, 
     cex = 2, 
     col = "skyblue", 
     frame.plot = F, 
     las = 1, 
     xlab = "Profundidad agua (cm)", 
     ylab = "Número de ranas",
     main = "Mi primer gráfico en R....!")

# IMPORTANTE: a esta altura del taller los participantes habrán visto que no hay un SOLO CAMINO para resolver algún problema específico... R es un Lego y podemos emplearlo para construir códigos o scripts para resolver el mismo problema, pero de diferentes formas... WOW...!!!

###################################
# IMPORTANTE: si te atoras en todo momento puedes acudir al HELP...

?plot

# En muchos casos, sobre todo cuando salen errores y no tenemos claro cómo solucionar, podemos copiar ese error y "googlearlo"... y es muy frecuente encontrar que alguien en este planeta lo solucionó...!

# un ejemplo
plot(pch = 16, cex = 2, col = "skyblue", las = 1, xlab = "Profundidad agua (cm)", ylab = "Número de ranas", frame.plot = F, main = "Mi primer gráfico en R....!")

# observe en la consola el mensaje de error... si no podemos solucionar, podemos copiar y acudir a la internet "Error in plot.default: argument "x" is missing, with no default"
###################################

# Regresemos al nuestro ejemplo.
#
# empleando la función de modelo lineal simple y graficando

modelo <- lm(No_ranas ~ Profundidad_charco)
summary(modelo)
plot(modelo)

plot(Profundidad_charco, No_ranas, pch = 16, cex = 4, col = "skyblue", las = 1, xlab = "Profundidad agua (cm)", ylab = "Número de ranas", frame.plot = F, main = "")

abline(modelo, col= "red", lwd= 3)
text(50,5, "y = 1.83 + 0.28x", cex = 2)
text(50,4, "r2 = 0.66", cex = 2)
text(Profundidad_charco, No_ranas, datos[,1])

###################################
# IMPORTANTE: guardar gráfico
# en R hay diferentes formar de guardar un gráfico
# uno forma muy recomendable es:

jpeg(filename = "Figura 3.jpg", width = 6000, height = 6000, units = "px", res =1200)

plot(Profundidad_charco, No_ranas, pch = 16, cex = 2, col = "skyblue", las = 1, xlab = "Profundidad agua (cm)", ylab = "Número de ranas", frame.plot = F, main = "")
abline(lm(No_ranas ~ Profundidad_charco), col= "red", lwd= 2)
text(50,5, "y = 1.83 + 0.28x", cex = 1)
text(50,4, "r2 = 0.66", cex = 1)
dev.off()
###################################

# IMPORTANTE: en diferentes procesos, las funciones pueden generar mucha información y debemos aprender a cómo extraer esa información sin necesidad de "copiarla a lápiz"...!

modelo
str(modelo)
# por ejemplo el intercepto se pueden extraer los valores de los coeficientes:
modelo$coefficients[1]

# la pendiente:
modelo$coefficients[2]

# intervalos de confianza de los parámetros
confint(modelo) 

########################################
# La clase para este taller termina aquí
# PERO como un bono extra en lo que sigue les dejo otra serie de análisis ilustrativos de cómo se pueden realizar análisis estadísticos en R empleando diferentes funciones

########################################
# vamos a limpiar nuestra consola:
rm(list = ls()) # elimina datos
dev.off() # elimina gráficos

# Ejemplo para estimar y graficar los intervalos de confianza y los intervalos de predicción

# datos nuevos de un muestreo de ranas en 50 charcas
set.seed(34); n <- 50; sigma <- 2; b0 <- 2; b1 <- 0.3 

# lo anterior también pude haberlo escrito como:
set.seed(34)
n <- 50
sigma <- 2
b0 <- 2
b1 <- 0.3 

# nuestro modelo lineal
x <- runif(n, 10, 30)
yhat <- b0 + b1*x
y <- rnorm(n, yhat, sd = sigma)

#------------------------------------------
par(mfrow = c(1,1))     
plot(x, y, pch = 16, las = 1, cex = 2, bty = "l", col = "skyblue", xlab = "Profundidad agua (cm)", ylab = "Número de ranas")
abline(lm(y ~ x), lwd = 2, col = "red")

(mod <-  lm(y~x))

# Intervalos de confianza 95%

# cargamos esta librería y si no la tenemos la instalamos desde CRAN
library(arm)

nsim <- 500
bsim <- sim(mod, n.sim = nsim)
apply(coef(bsim), 2, quantile, prob=c(0.025, 0.975)) 
quantile(bsim@sigma, prob=c(0.025, 0.975))
quantile(coef(bsim)[,2], probs=c(0.025, 0.975))
sum(coef(bsim)[,2]>1)/nsim
sum(coef(bsim)[,2]>0.5)/nsim

par(mfrow = c(1,1), mar=c(5,4,3,3))     
plot(x, y, pch = 16, las = 1, col = "skyblue", bty = "l", xlab = "Profundidad agua (cm)", ylab = "Número de ranas")
for(i in 1:nsim) abline(coef(bsim)[i,1], coef(bsim)[i,2], col = rgb(1, 0, 0, 0.05))

newdat <- data.frame(x = seq(10, 30, by = 0.1))
newmodmat <- model.matrix(~x, data = newdat)
fitmat <- matrix(ncol = nsim, nrow=nrow(newdat))
for(i in 1:nsim) fitmat[,i] <- newmodmat%*%coef(bsim)[i,]

plot(x, y, pch = 16, las = 1, , col = "skyblue", bty = "l", xlab = "Profundidad agua (cm)", ylab = "Número de ranas")
abline(mod, lwd=2, col = "red")
lines(newdat$x, apply(fitmat, 1, quantile, prob=0.025), lty=3, col = "red")
lines(newdat$x, apply(fitmat, 1, quantile, prob=0.975), lty=3, col = "red")

# -----------------------
# FIN SCRIPT
rm(list = ls()) # elimina datos
dev.off() # elimina gráficos
