####################################
# Curso: R para Tesis
# Ejemplos de 10 prácticas de análisis estadísticos con datos biológicos
# Profesor: SMandujanoR
# Última modificación: Septiembre 2, 2025
#####################################

## Configuración inicial
   
# Instalar y cargar paquetes necesarios
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(tidyverse, car, multcomp, MASS, lmtest, ggpubr, gtsummary, performance, emmeans, broom, sjPlot, rstatix)

library(ggplot2)

# Configurar tema para gráficos
theme_set(theme_minimal() + theme(plot.title = element_text(hjust = 0.5)))
      

######################################
## 1. ANOVA de una vía (Paramétrica) - Crecimiento de plantas
   
library(tidyverse)
library(gtsummary)
library(gt)

# Datos
set.seed(123)
datos_plantas <- data.frame(
  Tratamiento = rep(c("Control", "Fertilizante", "Agua_extra"), each = 20),
  Crecimiento = c(rnorm(20, 15, 2), rnorm(20, 22, 3), rnorm(20, 18, 2.5))
)
View(datos_plantas)

# ANOVA y prueba post-hoc
anova_plantas <- aov(Crecimiento ~ Tratamiento, data = datos_plantas)
summary(anova_plantas)

(tukey_plantas <- TukeyHSD(anova_plantas))

# Gráfico complementario
ggplot(datos_plantas, aes(x = Tratamiento, y = Crecimiento, fill = Tratamiento)) +
  geom_boxplot(alpha = 0.7) +
  geom_jitter(width = 0.2, alpha = 0.5) +
  labs(title = "Crecimiento de plantas por tratamiento",
       subtitle = paste("ANOVA: p =", round(summary(anova_plantas)[[1]]$`Pr(>F)`[1], 4))) +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal()

# Convertir a lm para gtsummary
lm_plantas <- lm(Crecimiento ~ Tratamiento, data = datos_plantas)

# Crear tabla
tbl_anova <- tbl_regression(lm_plantas) %>%
  as_gt() %>%
  tab_header(title = "ANOVA - Crecimiento de plantas", subtitle = "Comparación entre tratamientos")

print(tbl_anova)


######################################      
## 2. Kruskal-Wallis (No paramétrica) - Diversidad de especies
   
set.seed(456)
datos_diversidad <- data.frame(
  Habitat = rep(c("Bosque", "Pradera", "Humedal"), each = 15),
  Diversidad = c(rgamma(15, 5, 1), rgamma(15, 8, 1.5), rgamma(15, 12, 2))
)

# Kruskal-Wallis
kw_test <- kruskal.test(Diversidad ~ Habitat, data = datos_diversidad)

# Prueba post-hoc Dunn
dunn_test <- datos_diversidad %>%
  rstatix::dunn_test(Diversidad ~ Habitat, p.adjust.method = "bonferroni")

# Gráfico
ggplot(datos_diversidad, aes(x = Habitat, y = Diversidad, fill = Habitat)) +
  geom_violin(alpha = 0.6) +
  geom_boxplot(width = 0.2, alpha = 0.8) +
  labs(title = "Diversidad de especies por hábitat",
       subtitle = paste("Kruskal-Wallis: χ² =", round(kw_test$statistic, 2), ", p =", round(kw_test$p.value, 4))) +
  scale_fill_brewer(palette = "Set3")

# Tabla de resultados
print(dunn_test)
      

######################################
## 3. GLM Gaussiano - Relación tamaño-peso
   
set.seed(789)
datos_peces <- data.frame(
  Longitud = runif(100, 10, 50),
  Peso = 0.8 * (runif(100, 10, 50)^2) + rnorm(100, 0, 50)
)

# GLM Gaussiano
glm_gaussiano <- glm(Peso ~ Longitud, data = datos_peces, family = gaussian())

# Resumen
summary(glm_gaussiano)

# Gráfico
ggplot(datos_peces, aes(x = Longitud, y = Peso)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "glm", method.args = list(family = gaussian()), color = "red", se = TRUE) +
  labs(title = "Relación longitud-peso en peces",
       subtitle = paste("GLM Gaussiano: R² =", round(1 - (glm_gaussiano$deviance/glm_gaussiano$null.deviance), 3))) +
  annotate("text", x = 15, y = max(datos_peces$Peso)*0.9, label = paste("Peso =", round(coef(glm_gaussiano)[1], 1), "+", round(coef(glm_gaussiano)[2], 1), "* Longitud"))

# Tabla de resultados
tbl_glm_gauss <- tbl_regression(glm_gaussiano) %>%
  as_gt() %>%
  gt::tab_header(title = "GLM Gaussiano - Relación tamaño-peso")
print(tbl_glm_gauss)
      

######################################
## 4. GLM Poisson - Conteo de colonias bacterianas
   
set.seed(101)
datos_bacterias <- data.frame(
  Concentracion = rep(1:5, each = 10),
  Tiempo = rep(c(24, 48), 25),
  Colonias = rpois(50, lambda = exp(2 + 0.3 * rep(1:5, each = 10) + 0.2 * rep(c(0,1), 25)))
)
View(datos_bacterias)
# GLM Poisson
glm_poisson <- glm(Colonias ~ Concentracion + Tiempo, data = datos_bacterias, family = poisson())

# Resumen
summary_poisson <- summary(glm_poisson)

# Gráfico
ggplot(datos_bacterias, aes(x = Concentracion, y = Colonias, color = factor(Tiempo))) +
  geom_point(position = position_jitter(width = 0.2), alpha = 0.7) +
  geom_smooth(method = "glm", method.args = list(family = poisson()), se = FALSE) +
  labs(title = "Conteo de colonias bacterianas",
       subtitle = "GLM Poisson",
       color = "Tiempo (h)") +
  scale_color_brewer(palette = "Set1")

# Tabla de resultados
tbl_glm_poisson <- tbl_regression(glm_poisson, exponentiate = TRUE) %>%
  as_gt() %>%
  gt::tab_header(title = "GLM Poisson - Conteo de colonias")
print(tbl_glm_poisson)
      

######################################
## 5. GLM Binomial - Supervivencia de semillas

set.seed(202)
n <- 50  # observaciones por grupo

# Crear datos de manera más clara
datos_semillas <- data.frame(
  Tratamiento = rep(c("Control", "Hormona"), each = n),
  Temperatura = runif(2*n, 15, 35),  # Temperaturas aleatorias entre 15-35
  Germinacion = NA
)

# Calcular probabilidades de germinación
prob_control <- plogis(-5 + 0.2 * datos_semillas$Temperatura[1:n])
prob_hormona <- plogis(-5 + 0.2 * datos_semillas$Temperatura[(n+1):(2*n)] + 2)

# Generar datos binomiales
datos_semillas$Germinacion[1:n] <- rbinom(n, 1, prob_control)
datos_semillas$Germinacion[(n+1):(2*n)] <- rbinom(n, 1, prob_hormona)

# Verificar
table(datos_semillas$Tratamiento, datos_semillas$Germinacion)

# GLM Binomial
glm_binomial <- glm(Germinacion ~ Tratamiento + Temperatura, data = datos_semillas, family = binomial())

# Resultados
summary(glm_binomial)
exp(coef(glm_binomial))  # Odds ratios

# Gráfico
ggplot(datos_semillas, aes(x = Temperatura, y = Germinacion, color = Tratamiento)) +
  geom_point(position = position_jitter(height = 0.05), alpha = 0.6) +
  geom_smooth(method = "glm", method.args = list(family = binomial), se = TRUE) +
  labs(title = "Probabilidad de germinación de semillas", subtitle = "GLM Binomial") +
  scale_color_brewer(palette = "Set2")


######################################
## 6. Prueba t pareada (Paramétrica) - Antes/después tratamiento
   
set.seed(303)
datos_pareados <- data.frame(
  Paciente = paste0("P", 1:20),
  Antes = rnorm(20, 120, 15),
  Despues = rnorm(20, 110, 12)
) %>%
  pivot_longer(cols = c(Antes, Despues), names_to = "Tiempo", values_to = "Presion")

# Prueba t pareada
t_test_pareado <- t.test(value ~ Tiempo, data = datos_pareados, paired = TRUE)

# Gráfico
ggplot(datos_pareados, aes(x = Tiempo, y = Presion)) +
  geom_boxplot(fill = "lightblue", alpha = 0.7) +
  geom_line(aes(group = Paciente), alpha = 0.5, color = "gray") +
  geom_point(aes(group = Paciente), alpha = 0.7) +
  labs(title = "Presión arterial antes y después del tratamiento", subtitle = paste("Prueba t pareada: t =", round(t_test_pareado$statistic, 2), ", p =", round(t_test_pareado$p.value, 4)))

# Tabla de resultados
tbl_ttest <- datos_pareados %>%
  group_by(Tiempo) %>%
  summarise(Media = mean(Presion),
            SD = sd(Presion),
            n = n()) %>%
  gt() %>%
  gt::tab_header(title = "Estadísticas descriptivas - Prueba t pareada")
print(tbl_ttest)
      

######################################
## 7. Wilcoxon signed-rank (No paramétrica) - Scores de calidad de vida
   
set.seed(404)
datos_calidad <- data.frame(
  Paciente = paste0("P", 1:25),
  Pre = sample(1:10, 25, replace = TRUE),
  Post = sample(6:10, 25, replace = TRUE)  # Mejora sistemática
) %>%
  pivot_longer(cols = c(Pre, Post), names_to = "Evaluacion", values_to = "Score")

# Wilcoxon signed-rank
wilcox_test <- wilcox.test(value ~ Evaluacion, data = datos_calidad, paired = TRUE)

# Gráfico
ggplot(datos_calidad, aes(x = Evaluacion, y = Score)) +
  geom_boxplot(fill = "lightgreen", alpha = 0.7) +
  geom_line(aes(group = Paciente), alpha = 0.5, color = "gray") +
  geom_point(aes(group = Paciente), alpha = 0.7) +
  labs(title = "Scores de calidad de vida pre y post intervención", subtitle = paste("Wilcoxon signed-rank: V =", round(wilcox_test$statistic, 2), ", p =", round(wilcox_test$p.value, 4)))

# Tabla de resultados
print(wilcox_test)
      

######################################
## 8. ANCOVA - Ajuste por covariable
   
set.seed(505)
datos_ancova <- data.frame(
  Grupo = rep(c("Control", "Tratamiento"), each = 30),
  Edad = rnorm(60, 45, 10),
  Resultado = c(rnorm(30, 50, 8) + 0.5 * rnorm(30, 45, 10), rnorm(30, 65, 8) + 0.5 * rnorm(30, 45, 10))
)

# ANCOVA
ancova_model <- lm(Resultado ~ Grupo + Edad, data = datos_ancova)

# Gráfico
ggplot(datos_ancova, aes(x = Edad, y = Resultado, color = Grupo)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "ANCOVA - Resultado ajustado por edad", subtitle = paste("R² ajustado =", round(summary(ancova_model)$adj.r.squared, 3))) +
  scale_color_brewer(palette = "Set1")

# Tabla de resultados
tbl_ancova <- tbl_regression(ancova_model) %>%
  as_gt() %>%
  gt::tab_header(title = "ANCOVA - Ajuste por edad")
print(tbl_ancova)
      

######################################
## 9. GLM Gamma - Tiempo de supervivencia
   
set.seed(606)
datos_supervivencia <- data.frame(
  Dosis = rep(c("Baja", "Media", "Alta"), each = 20),
  Tiempo = c(rgamma(20, 5, 0.5), rgamma(20, 8, 0.6), rgamma(20, 12, 0.7))
)

# GLM Gamma
glm_gamma <- glm(Tiempo ~ Dosis, data = datos_supervivencia, family = Gamma(link = "log"))

# Gráfico
ggplot(datos_supervivencia, aes(x = Dosis, y = Tiempo, fill = Dosis)) +
  geom_violin(alpha = 0.6) +
  geom_boxplot(width = 0.2, alpha = 0.8) +
  labs(title = "Tiempo de supervivencia por dosis de tratamiento", subtitle = "GLM Gamma con link logarítmico") +
  scale_fill_brewer(palette = "Set3")

# Tabla de resultados
tbl_glm_gamma <- tbl_regression(glm_gamma, exponentiate = TRUE) %>%
  as_gt() %>%
  gt::tab_header(title = "GLM Gamma - Tiempo de supervivencia")
print(tbl_glm_gamma)
      

######################################
## 10. Modelo Mixto - Diseño longitudinal
   
set.seed(707)
datos_longitudinal <- data.frame(
  Paciente = rep(paste0("P", 1:15), each = 4),
  Tiempo = rep(0:3, 15),
  Tratamiento = rep(sample(c("A", "B"), 15, replace = TRUE), each = 4),
  Respuesta = rnorm(60, 50 + 2 * rep(0:3, 15) + 5 * as.numeric(rep(sample(c("A", "B"), 15, replace = TRUE), each = 4)), 5)
)

# Modelo mixto
library(lme4)
mixed_model <- lmer(Respuesta ~ Tiempo * Tratamiento + (1 | Paciente), data = datos_longitudinal)

# Gráfico
ggplot(datos_longitudinal, aes(x = Tiempo, y = Respuesta, color = Tratamiento, group = Paciente)) +
  geom_line(alpha = 0.5) +
  geom_point(alpha = 0.7) +
  geom_smooth(aes(group = Tratamiento), method = "lm", se = TRUE, size = 1.5) +
  labs(title = "Respuesta longitudinal por tratamiento", subtitle = "Modelo mixto con efecto aleatorio de paciente") +
  scale_color_brewer(palette = "Set1") +
  facet_wrap(~ Tratamiento)

# Tabla de resultados
tbl_mixed <- tbl_regression(mixed_model, tidy_fun = broom.mixed::tidy) %>%
  as_gt() %>%
  gt::tab_header(title = "Modelo mixto - Diseño longitudinal")
print(tbl_mixed)
      

######################################
## Función para resumen completo de análisis
   
resumen_analisis <- function(modelo, tipo) {
  cat("=== RESUMEN DEL ANÁLISIS ===\n")
  cat("Tipo:", tipo, "\n")
  
  if(tipo %in% c("ANOVA", "GLM")) {
    cat("R² ajustado:", round(summary(modelo)$adj.r.squared, 3), "\n")
  }
  
  if(tipo == "GLM") {
    cat("AIC:", round(AIC(modelo), 2), "\n")
    cat("BIC:", round(BIC(modelo), 2), "\n")
  }
  
  cat("\n--- Significancia global ---\n")
  if(tipo == "ANOVA") {
    print(summary(modelo))
  } else if(tipo == "GLM") {
    print(anova(modelo, test = "Chisq"))
  }
}
      

## Ejemplo de uso
   
# Para el ANOVA de plantas
resumen_analisis(anova_plantas, "ANOVA")

# Para el GLM Poisson
resumen_analisis(glm_poisson, "GLM")
      

######################################
# FIN SCRIPT
rm(list = ls())
dev.off()