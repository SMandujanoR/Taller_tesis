####################################
# Curso: R para Tesis
# Ejemplos de 10 prácticas para gráficos con R Base y ggplot2
# Profesor: SMandujanoR
# Última modificación: Septiembre 2, 2025
#####################################
  
## Sugerencias:

# 1. R Base es ideal para gráficos rápidos y simples
# 2. ggplot2 ofrece más control y personalización
# 3. Siempre incluye títulos, ejes y leyendas claras
# 4. Elige colores entre las diferentes paletas que existen para R
# 5. Exporta tus gráficos en alta resolución para publicaciones

#####################################  
### Práctica 1: Gráfico de barras - Abundancia de especies

# Datos de abundancia de aves en diferentes hábitats
especies <- c("Gorrión", "Mirlo", "Petirrojo", "Herrerillo", "Carbonero")
bosque <- c(25, 18, 12, 15, 10)
jardin <- c(35, 8, 20, 5, 12)
parque <- c(15, 22, 8, 18, 7)

# Gráfico de barras agrupadas
barplot(rbind(bosque, jardin, parque), 
        beside = TRUE,
        names.arg = especies,
        col = c("forestgreen", "lightgreen", "darkgreen"),
        main = "Abundancia de aves por hábitat",
        xlab = "Especies",
        ylab = "Número de individuos",
        ylim = c(0, 40))
legend("topright", 
       legend = c("Bosque", "Jardín", "Parque"),
       fill = c("forestgreen", "lightgreen", "darkgreen"))
grid()


#####################################
### Práctica 2: Gráfico de dispersión - Relación tamaño-peso

# Datos de relación entre longitud y peso en peces
set.seed(123)
(longitud <- runif(50, 10, 30))
(peso <- 0.8 * longitud^2 + rnorm(50, 0, 15))

# Gráfico de dispersión con línea de tendencia
plot(longitud, peso,
     pch = 16,
     col = "blue",
     cex = 1.2,
     main = "Relación longitud-peso en peces",
     xlab = "Longitud (cm)",
     ylab = "Peso (g)")

# Añadir línea de regresión
abline(lm(peso ~ longitud), col = "red", lwd = 2)

# Añadir ecuación de regresión
modelo <- lm(peso ~ longitud)
ecuacion <- paste("y =", round(coef(modelo)[1], 1), "+", round(coef(modelo)[2], 1), "x")
text(15, max(peso)*0.9, ecuacion, col = "red")

# Añadir coeficiente de correlación
correlacion <- cor(longitud, peso)
text(15, max(peso)*0.8, paste("r =", round(correlacion, 3)), col = "black")


#####################################
### Práctica 3: Histograma - Distribución de tamaños

# Datos de diámetro de troncos de árboles
set.seed(456)
diametros <- rnorm(200, mean = 35, sd = 8)

# Histograma con curva normal
hist(diametros,
     breaks = 20,
     col = "lightblue",
     border = "white",
     main = "Distribución de diámetros de troncos",
     xlab = "Diámetro (cm)",
     ylab = "Frecuencia",
     probability = TRUE,
     las = 1)

# Añadir curva normal
curve(dnorm(x, mean = mean(diametros), sd = sd(diametros)),
      add = TRUE,
      col = "red",
      lwd = 2)

# Añadir líneas de media y mediana
abline(v = mean(diametros), col = "blue", lwd = 2, lty = 2)
abline(v = median(diametros), col = "green", lwd = 2, lty = 2)

legend("topright",
       legend = c("Curva normal", "Media", "Mediana"),
       col = c("red", "blue", "green"),
       lwd = 2,
       lty = c(1, 2, 2))


#####################################
### Práctica 4: Boxplot - Comparación de tratamientos

# Datos de crecimiento de plantas bajo diferentes tratamientos
set.seed(789)
control <- rnorm(30, 15, 2)
fertilizante <- rnorm(30, 22, 3)
agua_extra <- rnorm(30, 18, 2.5)
luz_extra <- rnorm(30, 20, 2.8)

# Boxplot comparativo
boxplot(list(Control = control, 
             Fertilizante = fertilizante,
             "Agua extra" = agua_extra,
             "Luz extra" = luz_extra),
        col = c("lightblue", "lightgreen", "lightyellow", "lightpink"),
        main = "Crecimiento de plantas por tratamiento",
        ylab = "Altura (cm)",
        xlab = "Tratamiento",
        notch = TRUE)

# Añadir puntos de datos
stripchart(list(control, fertilizante, agua_extra, luz_extra),
           vertical = TRUE,
           method = "jitter",
           add = TRUE,
           pch = 16,
           col = rgb(0, 0, 0, 0.3))

# Añadir grid
grid()


#####################################
### Práctica 5: Gráfico de líneas - Seguimiento temporal

# Datos de población de linces a lo largo del tiempo
años <- 2010:2020
poblacion <- c(120, 115, 125, 130, 145, 160, 175, 190, 210, 225, 240)

# Gráfico de líneas con puntos
plot(años, poblacion,
     type = "p",
     pch = 17,
     cex = 1.5,
     col = "skyblue2",
     lwd = 2,
     main = "Evolución de la población de linces (2010-2020)",
     cex.main  = 0.9,
     xlab = "Año",
     ylab = "Número de individuos",
     frame.plot = F,
     ylim = c(100, 250))

# Añadir línea de tendencia
tendencia <- lm(poblacion ~ años)
abline(tendencia, col = "red", lty = 2, lwd = 2)

# Añadir área sombreada para intervalo de confianza
pred <- predict(tendencia, interval = "confidence")
polygon(c(años, rev(años)), c(pred[,2], rev(pred[,3])),
        col = rgb(1, 0, 0, 0.2), border = NA)

legend("topleft",
       legend = c("Datos observados", "Tendencia"),
       col = c("brown", "red"),
       lwd = 2,
       pch = c(16, NA))


#####################################
#####################################
## Gráficos con ggplot2

### Práctica 6: Gráfico de barras ggplot2 - Biodiversidad

library(ggplot2)
library(dplyr)

# Datos de riqueza de especies por hábitat
datos_biodiversidad <- data.frame(
  Habitat = rep(c("Bosque", "Pradera", "Humedal", "Desierto"), each = 3),
  Tipo = rep(c("Aves", "Mamíferos", "Reptiles"), 4),
  Riqueza = c(25, 15, 8, 18, 12, 5, 22, 8, 3, 10, 6, 2)
)

# Gráfico de barras apiladas
ggplot(datos_biodiversidad, aes(x = Habitat, y = Riqueza, fill = Tipo)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_manual(values = c("Aves" = "#1f77b4", "Mamíferos" = "#ff7f0e", "Reptiles" = "#2ca02c")) +
  labs(title = "Riqueza de especies por hábitat y tipo",
       x = "Hábitat",
       y = "Número de especies",
       fill = "Grupo taxonómico") +
  theme_minimal() +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5))


#####################################
### Práctica 7: Gráfico de dispersión ggplot2 - Genética

# Datos de expresión génica vs metilación
set.seed(123)
datos_geneticos <- data.frame(
  Muestra = paste0("M", 1:100),
  Expresion_Genica = rnorm(100, 10, 2),
  Metilacion = rnorm(100, 50, 10),
  Tipo_Cancer = sample(c("Tipo_A", "Tipo_B", "Tipo_C"), 100, replace = TRUE),
  Estadio = sample(1:4, 100, replace = TRUE, prob = c(0.3, 0.3, 0.2, 0.2))
)
View(datos_geneticos)
# Gráfico de dispersión con múltiples estéticas
ggplot(datos_geneticos, aes(x = Expresion_Genica, y = Metilacion, color = Tipo_Cancer, size = Estadio)) +
  geom_point(alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE, aes(group = Tipo_Cancer)) +
  scale_color_brewer(palette = "Set1") +
  labs(title = "Relación entre expresión génica y metilación del DNA",
       x = "Expresión génica (log2)",
       y = "Nivel de metilación (%)",
       color = "Tipo de cáncer",
       size = "Estadio") +
  theme_bw() +
  facet_wrap(~ Tipo_Cancer) +
  theme(plot.title = element_text(hjust = 0.5))


#####################################
### Práctica 8: Boxplot ggplot2 - Comparación experimental

# Datos de experimento de toxicidad
datos_toxicidad <- data.frame(
  Tratamiento = rep(c("Control", "Baja", "Media", "Alta"), each = 20),
  Concentracion = rep(c(0, 10, 50, 100), each = 20),
  Supervivencia = c(rnorm(20, 95, 5), rnorm(20, 85, 8), rnorm(20, 60, 12), rnorm(20, 30, 15)),
  Especie = rep(c("Daphnia", "Artemia"), 40)
)

# Boxplot con puntos y violín
ggplot(datos_toxicidad, aes(x = Tratamiento, y = Supervivencia, fill = Tratamiento)) +
  geom_violin(alpha = 0.6, trim = FALSE) +
  geom_boxplot(width = 0.2, alpha = 0.8, outlier.shape = NA) +
  geom_jitter(width = 0.1, alpha = 0.5, size = 1.5) +
  scale_fill_brewer(palette = "RdYlBu") +
  labs(title = "Supervivencia bajo diferentes concentraciones tóxicas",
       x = "Tratamiento",
       y = "Porcentaje de supervivencia") +
  facet_wrap(~ Especie) +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5))


#####################################
### Práctica 9: Gráfico de líneas ggplot2 - Cambio climático

# Datos de temperatura y CO2 a lo largo del tiempo
datos_clima <- data.frame(
  Año = rep(2000:2020, 2),
  Variable = rep(c("Temperatura", "CO2"), each = 21),
  Valor = c(seq(14.0, 15.5, length.out = 21), 
            seq(370, 420, length.out = 21)),
  Unidad = rep(c("°C", "ppm"), each = 21)
)

# Gráfico de líneas con dos escalas
ggplot(datos_clima, aes(x = Año, y = Valor, color = Variable)) +
  geom_line(size = 1.5) +
  geom_point(size = 2) +
  scale_color_manual(values = c("Temperatura" = "red", "CO2" = "blue")) +
  labs(title = "Tendencia de temperatura y CO2 atmosférico (2000-2020)",
       x = "Año",
       y = "Valor",
       color = "Variable") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = "bottom") +
  facet_wrap(~ Variable, scales = "free_y", ncol = 1)


#####################################
### Práctica 10: Heatmap ggplot2 - Expresión génica

# Datos de expresión génica (heatmap)
set.seed(456)
genes <- paste0("GEN", 1:20)
muestras <- paste0("M", 1:10)

# Crear matriz de expresión
matriz_expresion <- matrix(rnorm(200, mean = 10, sd = 2), nrow = 20, ncol = 10)
rownames(matriz_expresion) <- genes
colnames(matriz_expresion) <- muestras

# Convertir a formato largo para ggplot2
library(reshape2)
datos_heatmap <- melt(matriz_expresion)
colnames(datos_heatmap) <- c("Gen", "Muestra", "Expresion")

# Añadir información de grupos
datos_heatmap$Grupo <- ifelse(grepl("M[1-5]", datos_heatmap$Muestra), "Control", "Tratamiento")
datos_heatmap$Tipo_Gen <- sample(c("Metabolismo", "Señalización", "Estructural"), nrow(datos_heatmap), replace = TRUE)

# Heatmap con ggplot2
ggplot(datos_heatmap, aes(x = Muestra, y = Gen, fill = Expresion)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = mean(datos_heatmap$Expresion)) +
  labs(title = "Perfil de expresión génica",
       x = "Muestras",
       y = "Genes",
       fill = "Expresión\n(log2)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5)) +
  facet_grid(. ~ Grupo, scales = "free_x", space = "free_x")

#####################################
# FIN SCRIPT
rm(list = ls())
dev.off()

