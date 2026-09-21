####################################
# Curso: R para Tesis
# Ejemplos de 10 prácticas generales para conocer R 
# Profesor: SMandujanoR
# Última modificación: Septiembre 2, 2025
#####################################

## Sugerencias:

# 1. Ejecuta cada práctica línea por línea para entender qué hace cada comando
# 2. Modifica los valores y observa cómo cambian los resultados
# 3. Experimenta con diferentes parámetros** en las funciones gráficas
# 4. Consulta la ayuda de R usando `?nombre_funcion` para entender mejor cada función
# 5. Practica regularmente para familiarizarte con la sintaxis de R
# 6. Compila todos los ejercicios en formatos HTML, Word y PDF 


#################################
## Práctica 1: Análisis básico de datos de crecimiento de plantas
  
# Datos de altura de plantas (cm) en diferentes tratamientos
tratamiento_A <- c(15.2, 16.8, 14.5, 17.3, 15.9)
tratamiento_B <- c(12.8, 13.5, 14.1, 12.9, 13.7)
class(tratamiento_A)

# Calcular estadísticas descriptivas
mean(tratamiento_A)
sd(tratamiento_A)
min(tratamiento_A)
max(tratamiento_A)

mean(tratamiento_B)
sd(tratamiento_B)

# Otra forma de ver los mismos resultados
cat("TRATAMIENTO A:\n")
cat("Media:", mean(tratamiento_A), "cm\n")
cat("Desviación estándar:", sd(tratamiento_A), "cm\n")
cat("Mínimo:", min(tratamiento_A), "cm\n")
cat("Máximo:", max(tratamiento_A), "cm\n\n")

# Prueba t para comparar los tratamientos
resultado_t <- t.test(tratamiento_A, tratamiento_B)
cat("\nPrueba t:\n")
resultado_t


#################################
## Práctica 2: Gráfico de dispersión. Relación entre variables biológicas

# Datos de relación entre tamaño y peso en una especie
tamaño <- c(10, 12, 15, 18, 20, 22, 25, 28, 30, 32)
peso <- c(50, 58, 75, 92, 110, 125, 150, 175, 190, 210)

# Crear gráfico de dispersión
plot(tamaño, peso, 
     main = "Relación entre tamaño y peso",
     xlab = "Tamaño (cm)", 
     ylab = "Peso (g)",
     pch = 16, 
     col = "blue",
     cex = 1.5)

# Añadir línea de tendencia
abline(lm(peso ~ tamaño), col = "red", lwd = 2)

# Calcular correlación
correlacion <- cor(tamaño, peso)
cat("Coeficiente de correlación:", round(correlacion, 3))


#################################
## Práctica 3: Análisis de frecuencia de especies en un muestreo

# Datos de conteo de especies en un transecto
especies <- c("Quercus", "Pinus", "Quercus", "Pinus", "Quercus", "Pinus", "Quercus", "Pinus", "Quercus", "Pinus")
conteo <- c(15, 8, 12, 10, 18, 9, 14, 11, 16, 7)

# Crear tabla de frecuencias
tabla_frecuencias <- table(especies)
cat("Frecuencia de especies:\n")
tabla_frecuencias

# Gráfico de barras
barplot(tabla_frecuencias, 
        main = "Frecuencia de especies",
        xlab = "Especies",
        ylab = "Frecuencia",
        col = c("lightgreen", "lightblue"),
        ylim = c(0, max(tabla_frecuencias) + 5))

# Porcentajes
porcentajes <- prop.table(tabla_frecuencias) * 100
cat("\nPorcentajes:\n")
print(round(porcentajes, 1))


#################################
## Práctica 4: Simulación de crecimiento poblacional

# Simulación de crecimiento exponencial
poblacion_inicial <- 100
tasa_crecimiento <- 0.2
tiempo <- 1:20

# Calcular población a lo largo del tiempo
(poblacion <- poblacion_inicial * exp(tasa_crecimiento * tiempo))

# Graficar crecimiento
plot(tiempo, poblacion, 
     type = "l", 
     lwd = 2,
     col = "darkgreen",
     main = "Crecimiento poblacional exponencial",
     xlab = "Tiempo (días)",
     ylab = "Tamaño poblacional")

points(tiempo, poblacion, pch = 16, col = "red")

# Añadir grid
grid()

cat("Población final:", round(poblacion[20]), "individuos\n")


#################################
## Práctica 5: Análisis de datos meteorológicos

# Datos de temperatura mensual promedio
meses <- c("Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic")
temperatura <- c(12, 14, 18, 22, 26, 30, 32, 31, 27, 22, 16, 13)
precipitacion <- c(40, 35, 30, 25, 15, 5, 2, 3, 10, 25, 35, 45)

# Gráfico de líneas para temperatura
plot(1:12, temperatura, 
     type = "o", 
     col = "red", 
     lwd = 2,
     xlab = "Mes", 
     ylab = "Temperatura (°C)",
     main = "Datos meteorológicos anuales",
     xaxt = "n")
axis(1, at = 1:12, labels = meses)

# Añadir precipitación en segundo eje
par(new = TRUE)
plot(1:12, precipitacion, 
     type = "o", 
     col = "blue", 
     lwd = 2,
     xaxt = "n", 
     yaxt = "n",
     xlab = "", 
     ylab = "")
axis(4)
mtext("Precipitación (mm)", side = 4, line = 3)

# Leyenda
legend("topleft", 
       legend = c("Temperatura", "Precipitación"),
       col = c("red", "blue"),
       lwd = 2)


#################################
## Práctica 6: Análisis de datos de ADN - Frecuencia de bases

# Secuencia de ADN ejemplo
secuencia_adn <- c("A", "T", "C", "G", "A", "T", "G", "C", "A", "A", "T", "T", "C", "G", "G", "C", "A", "T", "G", "C")

# Calcular frecuencia de bases
frecuencia_bases <- table(secuencia_adn)
cat("Frecuencia de bases nitrogenadas:\n")
print(frecuencia_bases)

# Gráfico de torta
pie(frecuencia_bases, 
    main = "Composición de bases en secuencia de ADN",
    col = c("red", "blue", "green", "yellow"),
    labels = paste0(names(frecuencia_bases), " (", frecuencia_bases, ")"))


#################################
## Práctica 7: Análisis de datos de experimento con dos factores

# Datos de producción bajo diferentes condiciones
tratamiento <- rep(c("Control", "Fertilizante"), each = 6)
luz <- rep(rep(c("Alta", "Baja"), each = 3), 2)
produccion <- c(15, 16, 14, 8, 9, 7,  # Control
                25, 26, 24, 18, 19, 17) # Fertilizante

# Crear data frame
datos <- data.frame(tratamiento, luz, produccion)
View(datos)

# Estadísticas por grupo
cat("Estadísticas descriptivas:\n")
aggregate(produccion ~ tratamiento + luz, data = datos, FUN = mean)

# Boxplot comparativo
boxplot(produccion ~ tratamiento * luz, 
        data = datos,
        col = c("lightblue", "lightgreen"),
        main = "Producción por tratamiento y condición de luz",
        xlab = "Grupo",
        ylab = "Producción (g)")


#################################
## Práctica 8: Simulación de herencia genética

# Simulación de cruzamiento dihíbrido (9:3:3:1)
set.seed(123) # Para resultados reproducibles

# Generar 160 descendientes según proporción mendeliana
fenotipos <- sample(c("Doble dominante", "Dominante1", "Dominante2", "Recesivo"),
                    size = 160, 
                    replace = TRUE,
                    prob = c(9/16, 3/16, 3/16, 1/16))

# Tabla de frecuencias observadas
observado <- table(fenotipos)
cat("Frecuencias observadas:\n")
print(observado)

# Frecuencias esperadas (teóricas)
esperado <- c(90, 30, 30, 10) # 160 * proporciones
names(esperado) <- names(observado)

cat("\nFrecuencias esperadas:\n")
print(esperado)

# Prueba chi-cuadrado
chi_cuadrado <- chisq.test(observado, p = c(9/16, 3/16, 3/16, 1/16))
cat("\nPrueba de chi-cuadrado:\n")
print(chi_cuadrado)


#################################
## Práctica 9: Análisis de datos de biodiversidad

# Datos de riqueza específica en diferentes hábitats
habitats <- c("Bosque", "Pradera", "Humedal", "Bosque", "Pradera", "Humedal")
riqueza <- c(25, 18, 22, 28, 15, 24)

# Crear data frame
datos_biodiversidad <- data.frame(habitat = habitats, riqueza = riqueza)

# Análisis de varianza (ANOVA)
anova_resultado <- aov(riqueza ~ habitat, data = datos_biodiversidad)
cat("ANOVA - Comparación de riqueza entre hábitats:\n")
summary(anova_resultado)

# Gráfico de cajas
boxplot(riqueza ~ habitat, 
        data = datos_biodiversidad,
        col = c("lightgreen", "lightyellow", "lightblue"),
        main = "Riqueza específica por hábitat",
        xlab = "Hábitat",
        ylab = "Número de especies")

# Test de Tukey para comparaciones múltiples
if (summary(anova_resultado)[[1]][1,5] < 0.05) {
  cat("\nComparaciones post-hoc (Tukey HSD):\n")
  print(TukeyHSD(anova_resultado))
}

# OJO
str(summary(anova_resultado))

#################################
## Práctica 10: Análisis de datos de marcaje-recaptura

# Datos de estimación poblacional con Lincoln-Petersen
N <- 1000  # Población total marcada
n <- 150   # Total recapturado
m <- 25    # Marcados recapturados

# Estimación de población total (fórmula de Lincoln-Petersen)
P_estimada <- (N * n) / m
cat("Estimación de población total:", round(P_estimada), "individuos\n")

# Intervalo de confianza (aproximado)
error_estandar <- sqrt((N^2 * n * (n - m)) / (m^3))
limite_inferior <- P_estimada - 1.96 * error_estandar
limite_superior <- P_estimada + 1.96 * error_estandar

cat("Intervalo de confianza 95%: [", round(limite_inferior), "-", 
    round(limite_superior), "]\n")

# Gráfico de la estimación
estimaciones <- c(P_estimada, limite_inferior, limite_superior)
nombres <- c("Estimación", "Límite inferior", "Límite superior")

barplot(estimaciones, 
        names.arg = nombres,
        col = c("blue", "lightblue", "lightblue"),
        main = "Estimación poblacional - Método de marcaje-recaptura",
        ylab = "Número de individuos",
        ylim = c(0, max(estimaciones) * 1.1))

#####################################
# FIN SCRIPT
rm(list = ls())
dev.off()

