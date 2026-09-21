####################################
# Curso: R para Tesis
# Ejemplos de 10 prácticas para el manejo de data.frames
# Profesor: SMandujanoR
# Última modificación: Septiembre 2, 2025
#####################################

## Práctica 1: Creación y manipulación básica de data.frames
  
# Crear un data.frame desde vectores
especie <- c("Quercus_robur", "Pinus_sylvestris", "Fagus_sylvatica", "Quercus_ilex")
class(especie)

altura <- c(15.2, 22.5, 18.7, 12.3)

diametro <- c(25.8, 32.1, 28.9, 20.4)

edad <- c(20, 35, 25, 15)

# Crear el data.frame
arboles_df <- data.frame(
  Especie = especie,
  Altura_m = altura,
  Diametro_cm = diametro,
  Edad_anos = edad
)
class(arboles_df)
View(arboles_df)

# Explorar el data.frame
cat("Estructura del data.frame:\n")
str(arboles_df)

cat("\nPrimeras filas:\n")
head(arboles_df)

cat("\nResumen estadístico:\n")
summary(arboles_df)

# Acceder a columnas
cat("\nAlturas de todos los árboles:\n")
arboles_df$Altura_m

cat("\nDatos del segundo árbol:\n")
arboles_df[2, ]


######################################
## Práctica 2: Filtrado y selección de datos

# Crear data.frame con datos de muestreo
muestreo <- data.frame(
  Sitio = rep(c("Bosque", "Rivera", "Pradera"), each = 4),
  Especie = c("A", "B", "C", "D", "A", "C", "E", "F", "B", "D", "E", "G"),
  Abundancia = c(15, 8, 12, 6, 20, 18, 7, 5, 10, 9, 8, 4),
  Temperatura = c(18, 18, 19, 20, 22, 22, 23, 23, 25, 25, 26, 26)
)

cat("Data.frame completo:\n")
muestreo

# Filtrar datos
cat("\nEspecies con abundancia mayor a 10:\n")
alto_abundancia <- muestreo[muestreo$Abundancia > 10, ]
alto_abundancia

cat("\nDatos solo del Bosque:\n")
bosque_data <- muestreo[muestreo$Sitio == "Bosque", ]
bosque_data

# Seleccionar columnas específicas
cat("\nSolo especie y abundancia:\n")
especies_abundancia <- muestreo[, c("Especie", "Abundancia")]
especies_abundancia


######################################
## Práctica 3: Agregación y resumen de datos

# Datos de producción agrícola por tratamiento
cultivos <- data.frame(
  Tratamiento = rep(c("Orgánico", "Convencional"), each = 6),
  Cultivo = rep(c("Maíz", "Trigo", "Soja"), 4),
  Rendimiento = c(8.5, 6.2, 7.8, 9.1, 5.9, 7.5, 10.2, 8.7, 9.5, 11.3, 7.8, 9.2),
  Parcela = rep(1:3, 4)
)

cultivos

# Calcular promedios por tratamiento
cat("\nRendimiento promedio por tratamiento:\n")
promedio_tratamiento <- aggregate(Rendimiento ~ Tratamiento, data = cultivos, FUN = mean)
print(promedio_tratamiento)

# Calcular promedios por cultivo y tratamiento
cat("\nRendimiento por cultivo y tratamiento:\n")
promedio_cultivo_tratamiento <- aggregate(Rendimiento ~ Cultivo + Tratamiento, data = cultivos, FUN = mean)
print(promedio_cultivo_tratamiento)

# Usando tapply para resúmenes
cat("\nRendimiento máximo por tratamiento:\n")
maximo_tratamiento <- tapply(cultivos$Rendimiento, cultivos$Tratamiento, max)
print(maximo_tratamiento)


######################################
## Práctica 4: Transformación y creación de nuevas variables

# Datos de crecimiento de plantas
plantas <- data.frame(
  Planta = paste0("P", 1:8),
  Tratamiento = rep(c("A", "B"), each = 4),
  Altura_inicial = c(10, 12, 11, 13, 9, 11, 10, 12),
  Altura_final = c(25, 28, 26, 30, 20, 22, 21, 24)
)

cat("Datos originales:\n")
print(plantas)

# Crear nueva variable: crecimiento absoluto
plantas$Crecimiento <- plantas$Altura_final - plantas$Altura_inicial

# Crear nueva variable: crecimiento porcentual
plantas$Crecimiento_porcentual <- (plantas$Crecimiento / plantas$Altura_inicial) * 100

cat("\nDatos con nuevas variables:\n")
print(plantas)

# Transformar variable categórica a factor
plantas$Tratamiento <- as.factor(plantas$Tratamiento)

cat("\nEstructura después de transformaciones:\n")
str(plantas)

# Resumen por tratamiento
cat("\nCrecimiento promedio por tratamiento:\n")
aggregate(Crecimiento ~ Tratamiento, data = plantas, FUN = mean)


######################################
## Práctica 5: Combinación y unión de data.frames

# Crear dos data.frames relacionados
(datos_geneticos <- data.frame(
  Muestra = paste0("M", 1:6),
  Genotipo = c("AA", "AB", "BB", "AA", "AB", "BB"),
  Expresion_genica = c(15.2, 12.8, 10.5, 16.1, 13.5, 11.2)
))

(datos_fenotipicos <- data.frame(
  Muestra = paste0("M", 1:6),
  Fenotipo = c("Alto", "Medio", "Bajo", "Alto", "Medio", "Bajo"),
  Peso = c(25.8, 22.1, 18.5, 26.3, 23.2, 19.1)
))

cat("Datos genéticos:\n")
print(datos_geneticos)

cat("\nDatos fenotípicos:\n")
print(datos_fenotipicos)

# Unir los data.frames por la columna Muestra
datos_completos <- merge(datos_geneticos, datos_fenotipicos, by = "Muestra")

cat("\nDatos combinados:\n")
print(datos_completos)

# Agregar nuevas filas (nuevas muestras)
nuevas_muestras <- data.frame(
  Muestra = c("M7", "M8"),
  Genotipo = c("AA", "BB"),
  Expresion_genica = c(14.8, 10.9)
)

datos_geneticos_completo <- rbind(datos_geneticos, nuevas_muestras)
cat("\nDatos genéticos actualizados:\n")
print(datos_geneticos_completo)


######################################
## Práctica 6: Manipulación con dplyr (instalar si es necesario)

# Instalar y cargar dplyr si es necesario
if (!require(dplyr)) {
  install.packages("dplyr")
  library(dplyr)
}

# Datos de biodiversidad
biodiversidad <- data.frame(
  Parque = rep(c("Norte", "Sur", "Este", "Oeste"), each = 5),
  Especie = c("A", "B", "C", "D", "E", "A", "F", "G", "H", "I", "B", "C", "J", "K", "L", "A", "M", "N", "O", "P"),
  Abundancia = sample(5:50, 20, replace = TRUE),
  Area_ha = rep(c(100, 150, 200, 120), each = 5)
)

cat("Datos originales:\n")
print(biodiversidad)

# Operaciones con dplyr
resultados <- biodiversidad %>%
  filter(Abundancia > 20) %>% # Filtrar abundancias > 20
  group_by(Parque) %>% # Agrupar por parque
  summarise(
    Total_Especies = n(), # Contar especies
    Abundancia_Promedio = mean(Abundancia), # Promedio abundancia
    Abundancia_Maxima = max(Abundancia) # Máxima abundancia
  ) %>%
  arrange(desc(Total_Especies)) # Ordenar por total de especies

cat("\nResultados con dplyr:\n")
print(resultados)


######################################
## Práctica 7: Limpieza y tratamiento de datos faltantes

# Crear data.frame con datos faltantes (NA)
microorganismos <- data.frame(
  Muestra = paste0("Micro", 1:10),
  Bacteria = c(150, NA, 230, 180, 210, NA, 190, 220, 240, 170),
  Hongo = c(45, 38, NA, 52, 48, 41, NA, 56, 49, 43),
  pH = c(6.8, 7.2, 6.5, NA, 7.0, 6.9, 7.1, NA, 6.7, 7.3)
)

cat("Datos con valores faltantes:\n")
print(microorganismos)

# Identificar valores faltantes
cat("\nValores faltantes por columna:\n")
print(colSums(is.na(microorganismos)))

# Opción 1: Eliminar filas con NA
sin_na <- na.omit(microorganismos)
cat("\nDatos después de eliminar NA:\n")
print(sin_na)

# Opción 2: Reemplazar NA con la media
microorganismos_limpio <- microorganismos
microorganismos_limpio$Bacteria[is.na(microorganismos_limpio$Bacteria)] <- 
  mean(microorganismos_limpio$Bacteria, na.rm = TRUE)

microorganismos_limpio$Hongo[is.na(microorganismos_limpio$Hongo)] <- 
  mean(microorganismos_limpio$Hongo, na.rm = TRUE)

microorganismos_limpio$pH[is.na(microorganismos_limpio$pH)] <- 
  mean(microorganismos_limpio$pH, na.rm = TRUE)

cat("\nDatos con NA reemplazados por la media:\n")
print(microorganismos_limpio)


######################################
## Práctica 8: Reestructuración de datos con pivot

# Datos en formato ancho (wide)
datos_ancho <- data.frame(
  Especie = c("Panthera leo", "Canis lupus", "Ursus arctos"),
  Peso_2020 = c(190, 45, 280),
  Peso_2021 = c(195, 47, 285),
  Peso_2022 = c(198, 48, 290),
  Longitud_2020 = c(2.5, 1.2, 2.2),
  Longitud_2021 = c(2.6, 1.3, 2.3),
  Longitud_2022 = c(2.7, 1.4, 2.4)
)

cat("Datos en formato ancho:\n")
print(datos_ancho)

# Convertir a formato largo (long)
library(tidyr) # Instalar si es necesario: install.packages("tidyr")

datos_largo <- datos_ancho %>%
  pivot_longer(
    cols = -Especie,
    names_to = c("Variable", "Año"),
    names_sep = "_",
    values_to = "Valor"
  )

cat("\nDatos en formato largo:\n")
print(datos_largo)

# Convertir de vuelta a formato ancho
datos_ancho_nuevo <- datos_largo %>%
  pivot_wider(
    names_from = c("Variable", "Año"),
    values_from = "Valor"
  )

cat("\nDatos convertidos de vuelta a formato ancho:\n")
print(datos_ancho_nuevo)


######################################
## Práctica 9: Operaciones por grupos con split-apply-combine

# Datos de experimento con múltiples tratamientos y réplicas
experimento <- data.frame(
  Tratamiento = rep(c("Control", "Fertilizante", "Agua"), each = 9),
  Dosis = rep(rep(c("Baja", "Media", "Alta"), each = 3), 3),
  Replica = rep(1:3, 9),
  Biomasa = c(12.5, 13.1, 12.8, 15.2, 16.1, 15.8, 18.5, 19.2, 18.9, 14.8, 15.2, 14.9, 18.3, 19.1, 18.7, 22.6, 23.4, 23.1, 11.2, 11.8, 11.5, 13.5, 14.2, 13.9, 16.8, 17.5, 17.2)
)

cat("Datos del experimento:\n")
print(experimento)

# Dividir por tratamiento
grupos <- split(experimento, experimento$Tratamiento)

cat("\nDatos divididos por tratamiento:\n")
print(grupos)

# Aplicar función a cada grupo: calcular media de biomasa
medias_grupos <- lapply(grupos, function(x) mean(x$Biomasa))

cat("\nMedia de biomasa por tratamiento:\n")
print(medias_grupos)

# Combinar resultados
resultados_combinados <- data.frame(
  Tratamiento = names(medias_grupos),
  Biomasa_Media = unlist(medias_grupos)
)

cat("\nResultados combinados:\n")
print(resultados_combinados)

# Usando by para operaciones por grupo
cat("\nResumen estadístico por tratamiento:\n")
resumen_tratamiento <- by(experimento$Biomasa, experimento$Tratamiento, summary)
print(resumen_tratamiento)


######################################
## Práctica 10: Exportación e importación de data.frames

# Crear data.frame de ejemplo
aves <- data.frame(
  Especie = c("Parus major", "Fringilla coelebs", "Erithacus rubecula", "Turdus merula"),
  Longitud_alas = c(7.8, 8.5, 6.9, 12.3),
  Peso = c(18.5, 22.1, 16.8, 102.5),
  Habitat = c("Bosque", "Bosque", "Jardín", "Jardín"),
  Abundancia = c(15, 12, 8, 6)
)

cat("Data.frame de aves:\n")
print(aves)

# Exportar a CSV
write.csv(aves, "datos_aves.csv", row.names = FALSE)


# Exportar a Excel (requiere openxlsx)
if (!require(openxlsx)) {
  install.packages("openxlsx")
  library(openxlsx)
}
write.xlsx(aves, "datos_aves.xlsx")
cat("Datos exportados a 'datos_aves.xlsx'\n")

# Importar datos desde CSV
aves_importado <- read.csv("datos_aves.csv")
cat("\nDatos importados desde CSV:\n")
print(aves_importado)

# Exportar solo un subconjunto
aves_bosque <- aves[aves$Habitat == "Bosque", ]
write.csv(aves_bosque, "aves_bosque.csv", row.names = FALSE)

# Leer datos desde URL
cat("\nLeyendo datos de ejemplo desde URL...\n")
# datos_url <- read.csv("https://ejemplo.com/datos.csv") # Ejemplo

# Verificar que los archivos se crearon
cat("\nArchivos creados en el directorio de trabajo:\n")
print(list.files(pattern = "\\.csv$|\\.xlsx$"))

# Limpieza: eliminar archivos creados
###file.remove("datos_aves.csv", "datos_aves.xlsx", "aves_bosque.csv")

#####################################
## Sugerencias:

# 1. Siempre verifica la estructura con `str()` y `summary()`
# 2. Usa nombres descriptivos para las columnas
# 3. Maneja los NA apropiadamente según tu análisis
# 4. Guarda tus datos frecuentemente durante la manipulación
# 5. Documenta tus transformaciones con comentarios

#####################################
# FIN SCRIPT
rm(list = ls())
dev.off()

