####################################
# Curso: R para Tesis
# Ejemplos de 10 prácticas generales SIG para crear mapas con diferentes paquetes en R
# Profesor: SMandujanoR
# Última modificación: Septiembre 2, 2025
#####################################

## Sugerencias:

# 1. Siempre verifica los sistemas de coordenadas con `st_crs()`
# 2. Usa `st_transform()` para reproyectar cuando sea necesario
# 3. Maneja los NA en las extracciones de raster
# 4. Guarda metadatos junto con tus archivos espaciales
# 5. Prueba con datos reales descargados de GBIF 

################################

## 1. Instalación y carga de paquetes
   
# Paquetes 
library(raster)
library(terra)
library(sf)
library(sp)
library(maptools)
library(ggplot2)
library(leaflet)
library(tmap)
library(mapview)
###library(rgdal)

# Crear directorio para resultados
dir.create("resultados_maps", showWarnings = FALSE)


################################
## 2. Cargar y explorar shapefile básico
   
# Descargar datos de ejemplo (áreas protegidas de Costa Rica), o alternativamente, cargar tu propio shapefile

url <- "https://github.com/OpenGeoHub/agriculture-suitability/raw/master/data/protected_areas/protected_areas.shp"
destfile <- "protected_areas.shp"
download.file(url, destfile, mode = "wb")

# Cargar con sf
areas_protegidas <- st_read("protected_areas.shp")
print(paste("Número de áreas protegidas:", nrow(areas_protegidas)))

# Explorar estructura
st_geometry_type(areas_protegidas)
st_crs(areas_protegidas)
head(areas_protegidas)
   

################################
## 3. Visualización básica con ggplot2
   
# Mapa simple con ggplot2
ggplot() +
  geom_sf(data = areas_protegidas, aes(fill = nombre), alpha = 0.7) +
  scale_fill_viridis_d() +
  labs(title = "Áreas Protegidas de Costa Rica",
       fill = "Nombre del Área") +
  theme_minimal() +
  theme(legend.position = "none")

# Guardar mapa
ggsave("resultados_maps/areas_protegidas_ggplot.png", width = 10, height = 8, dpi = 300)
   

################################
## 4. Crear datos biológicos simulados (riqueza de especies)
   
# Generar puntos aleatorios de muestreo dentro de las áreas protegidas
set.seed(123)

puntos_muestreo <- st_sample(areas_protegidas, size = 100, type = "random")
puntos_muestreo <- st_sf(geometry = puntos_muestreo)

# Agregar datos biológicos simulados
puntos_muestreo$riqueza_aves <- rpois(nrow(puntos_muestreo), lambda = 20)
puntos_muestreo$riqueza_mamiferos <- rpois(nrow(puntos_muestreo), lambda = 8)
puntos_muestreo$id <- 1:nrow(puntos_muestreo)

# Guardar puntos como shapefile
st_write(puntos_muestreo, "resultados_maps/puntos_muestreo.shp", delete_layer = TRUE)
   

################################
## 5. Mapa interactivo con leaflet
   
# Convertir a coordenadas geográficas si es necesario
puntos_wgs84 <- st_transform(puntos_muestreo, crs = 4326)

# Mapa interactivo
mapa_interactivo <- leaflet(puntos_wgs84) %>%
  addTiles() %>%
  addCircleMarkers(
    radius = ~riqueza_aves/2,
    color = ~colorNumeric("viridis", riqueza_aves)(riqueza_aves),
    stroke = FALSE,
    fillOpacity = 0.8,
    popup = ~paste("Riqueza aves:", riqueza_aves, "<br>Riqueza mamíferos:", riqueza_mamiferos)
  ) %>%
  addLegend(
    position = "bottomright",
    pal = colorNumeric("viridis", puntos_wgs84$riqueza_aves),
    values = ~riqueza_aves,
    title = "Riqueza de Aves"
  )

# Guardar como HTML
library(htmlwidgets)
saveWidget(mapa_interactivo, "resultados_maps/mapa_interactivo.html")
   

################################
## 6. Análisis con raster/terra - Crear capas ambientales
   
# Crear un raster de elevación simulado
library(terra)
ext <- ext(areas_protegidas)  # Extensión de las áreas protegidas

# Raster de elevación simulado
elevacion <- rast(ext, resolution = 0.01)
values(elevacion) <- runif(ncell(elevacion), 0, 3000)

# Raster de precipitación simulado
precipitacion <- rast(ext, resolution = 0.01)
values(precipitacion) <- runif(ncell(precipitacion), 1000, 4000)

# Stack de capas ambientales
capas_ambientales <- c(elevacion, precipitacion)
names(capas_ambientales) <- c("elevacion", "precipitacion")

# Guardar raster
writeRaster(capas_ambientales, "resultados_maps/capas_ambientales.tif", overwrite = TRUE)
   

################################
## 7. Extraer valores ambientales para puntos de muestreo
   
# Extraer valores de raster para puntos de muestreo
valores_extraidos <- extract(capas_ambientales, vect(puntos_muestreo))
puntos_muestreo$elevacion <- valores_extraidos$elevacion
puntos_muestreo$precipitacion <- valores_extraidos$precipitacion

# Análisis de correlación
cor(puntos_muestreo$riqueza_aves, puntos_muestreo$elevacion, use = "complete.obs")
cor(puntos_muestreo$riqueza_aves, puntos_muestreo$precipitacion, use = "complete.obs")

# Guardar puntos con datos ambientales
st_write(puntos_muestreo, "resultados_maps/puntos_con_ambientales.shp", delete_layer = TRUE)
   

################################
## 8. Modelo de distribución de especies simple
   
# Modelo lineal simple para riqueza de aves
modelo_aves <- lm(riqueza_aves ~ elevacion + precipitacion, data = puntos_muestreo)
summary(modelo_aves)

# Predecir riqueza en todo el raster
prediccion_riqueza <- predict(capas_ambientales, modelo_aves)

# Visualizar predicción
plot(prediccion_riqueza, main = "Riqueza de Aves Predicha")
plot(st_geometry(areas_protegidas), add = TRUE, border = "red")

# Guardar predicción
writeRaster(prediccion_riqueza, "resultados_maps/prediccion_riqueza.tif", overwrite = TRUE)
   

################################
## 9. Mapa temático con tmap
   
library(tmap)

# Mapa temático de riqueza de aves
tm_shape(areas_protegidas) +
  tm_polygons(col = "gray90", border.col = "gray50") +
  tm_shape(puntos_muestreo) +
  tm_symbols(col = "riqueza_aves", size = 0.3, palette = "viridis",
             title.col = "Riqueza de Aves") +
  tm_layout(main.title = "Riqueza de Aves en Áreas Protegidas",
            legend.position = c("right", "bottom")) +
  tm_scale_bar() +
  tm_compass()

# Guardar mapa
tmap_save(tm_last(), "resultados_maps/mapa_tematico.png", width = 10, height = 8)
   

################################
## 10. Exportar a diferentes formatos y Google Maps
   
# Exportar a KML para Google Earth
st_write(puntos_muestreo, "resultados_maps/puntos_muestreo.kml", delete_layer = TRUE)

# Exportar a GeoJSON
st_write(areas_protegidas, "resultados_maps/areas_protegidas.geojson", delete_layer = TRUE)

# Exportar a CSV con coordenadas
puntos_csv <- cbind(st_coordinates(puntos_muestreo), st_drop_geometry(puntos_muestreo))
write.csv(puntos_csv, "resultados_maps/puntos_muestreo.csv", row.names = FALSE)

# Función para visualizar en Google Maps
ver_en_google_maps <- function(datos) {
  coords <- st_bbox(datos)
  url <- paste0("https://www.google.com/maps?q=",
                mean(coords[c(2,4)]), ",", mean(coords[c(1,3)]),
                "&z=8")
  browseURL(url)
}

# Ver áreas protegidas en Google Maps
ver_en_google_maps(areas_protegidas)
   

################################
## Bonus: Análisis de superposición y buffers
   
# Crear buffer alrededor de puntos de muestreo
buffers <- st_buffer(puntos_muestreo, dist = 5000)  # 5km buffer

# Calcular área total de buffers por área protegida
superposicion <- st_intersection(buffers, areas_protegidas)
superposicion$area_ha <- as.numeric(st_area(superposicion)) / 10000

# Resumen por área protegida
resumen_superposicion <- superposicion %>%
  st_drop_geometry() %>%
  group_by(nombre) %>%
  summarise(
    n_puntos = n(),
    area_total_ha = sum(area_ha),
    riqueza_promedio = mean(riqueza_aves)
  )

print(resumen_superposicion)

# Guardar resultados
write.csv(resumen_superposicion, "resultados_maps/resumen_superposicion.csv", row.names = FALSE)
   

#####################################
# FIN SCRIPT
rm(list = ls())
dev.off()
