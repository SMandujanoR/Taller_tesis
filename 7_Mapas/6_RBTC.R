# Mapas de Riqueza de Aves en Reserva de Biosfera Tehuacán-Cuicatlán

## 1. Configuración inicial y datos de ejemplo

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
library(ggspatial)
library(ggmap)
library(osmar)
library(prettymapr)
library(dplyr)
library(viridis)

# Crear directorios
dir.create("mapas_tehuacan", showWarnings = FALSE)
dir.create("datos", showWarnings = FALSE)

# Crear datos de ejemplo para la Reserva Tehuacán-Cuicatlán. Coordenadas aproximadas de la reserva (bbox)
bbox_tehuacan <- c(xmin = -97.5, xmax = -96.8, ymin = 17.8, ymax = 18.5)

# Crear polígono de la reserva (simplificado)
tehuacan_polygon <- st_as_sfc(st_bbox(c(bbox_tehuacan[1], bbox_tehuacan[3], 
                                        bbox_tehuacan[2], bbox_tehuacan[4]), crs = 4326))

# Crear datos de localidades con riqueza de aves
set.seed(123)
localidades <- data.frame(
  localidad = c("Tehuacán", "Zapotitlán", "Coxcatlán", "San Juan Raya", 
                "Calipan", "El Riego", "Tilapa", "San Luis Atolotitlán"),
  longitud = c(-97.39, -97.48, -97.15, -97.48, -97.27, -97.32, -97.12, -97.22),
  latitud = c(18.46, 18.33, 18.27, 18.42, 18.31, 18.22, 18.18, 18.35),
  riqueza_aves = c(150, 180, 220, 190, 170, 200, 160, 175),
  esfuerzo_muestreo = c(20, 25, 30, 22, 18, 28, 15, 21)
)

# Convertir a objeto sf
localidades_sf <- st_as_sf(localidades, coords = c("longitud", "latitud"), crs = 4326)

# Guardar datos
st_write(localidades_sf, "datos/localidades_aves.shp", delete_layer = TRUE)
st_write(tehuacan_polygon, "datos/reserva_tehuacan.shp", delete_layer = TRUE)


## 2. Mapa básico con ggplot2 y sf

# Mapa básico con ggplot2
mapa_basico <- ggplot() +
  geom_sf(data = tehuacan_polygon, fill = "lightgreen", alpha = 0.3, color = "darkgreen", size = 1) +
  geom_sf(data = localidades_sf, aes(size = riqueza_aves, color = riqueza_aves), alpha = 0.8) +
  scale_size_continuous(range = c(3, 10), name = "Riqueza de aves") +
  scale_color_viridis(name = "Riqueza de aves", option = "plasma") +
  geom_sf_text(data = localidades_sf, aes(label = localidad), size = 3, nudge_y = 0.02) +
  labs(title = "Riqueza de Aves en Reserva de Biosfera Tehuacán-Cuicatlán",
       subtitle = "Localidades de muestreo",
       caption = "Fuente: Datos de ejemplo") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5)) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tr", which_north = "true")

print(mapa_basico)
ggsave("mapas_tehuacan/mapa_basico_aves.png", plot = mapa_basico, width = 12, height = 10, dpi = 300)

## 3. Mapa con raster/terra - Interpolación de riqueza

# Crear raster base para interpolación
raster_base <- rast(ext(tehuacan_polygon), resolution = 0.01, crs = "EPSG:4326")

# Convertir puntos a SpatVector para terra
puntos_terra <- vect(localidades_sf)

# Interpolación IDW (Inverse Distance Weighting)
riqueza_raster <- interpolate(raster_base, pontos_terra, field = "riqueza_aves", method = "idw")

# Cortar a la extensión de la reserva
riqueza_recortada <- mask(riqueza_raster, vect(tehuacan_polygon))

# Mapa con terra
png("mapas_tehuacan/mapa_raster_riqueza.png", width = 1000, height = 800)
plot(riqueza_recortada, main = "Riqueza de Aves - Interpolación IDW")
plot(vect(tehuacan_polygon), add = TRUE, border = "red", lwd = 2)
plot(puntos_terra, add = TRUE, col = "black", pch = 16, cex = 1.5)
text(puntos_terra, labels = localidades_sf$riqueza_aves, pos = 3, cex = 0.8)
dev.off()

# Guardar raster
writeRaster(riqueza_recortada, "mapas_tehuacan/riqueza_aves_interpolada.tif", overwrite = TRUE)
```

## 4. Mapa interactivo con leaflet

```r
# Paleta de colores para riqueza
pal <- colorNumeric("viridis", domain = localidades_sf$riqueza_aves)

# Mapa interactivo
mapa_interactivo <- leaflet(localidades_sf) %>%
  addTiles() %>%
  addProviderTiles(providers$OpenTopoMap, group = "Topográfico") %>%
  addProviderTiles(providers$Esri.WorldImagery, group = "Satélite") %>%
  addPolygons(data = tehuacan_polygon, 
              fillColor = "green", 
              fillOpacity = 0.2, 
              color = "darkgreen", 
              weight = 2,
              group = "Reserva") %>%
  addCircleMarkers(
    radius = ~riqueza_aves/20,
    color = ~pal(riqueza_aves),
    stroke = FALSE,
    fillOpacity = 0.8,
    popup = ~paste("<b>", localidad, "</b><br>",
                   "Riqueza de aves: ", riqueza_aves, "<br>",
                   "Esfuerzo muestreo: ", esfuerzo_muestreo, "horas")
  ) %>%
  addLegend(
    position = "bottomright",
    pal = pal,
    values = ~riqueza_aves,
    title = "Riqueza de Aves"
  ) %>%
  addLayersControl(
    baseGroups = c("OpenStreetMap", "Topográfico", "Satélite"),
    overlayGroups = c("Reserva"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  addScaleBar(position = "bottomleft")

# Guardar mapa interactivo
htmlwidgets::saveWidget(mapa_interactivo, "mapas_tehuacan/mapa_interactivo_aves.html")
```

## 5. Mapa con tmap (Thematic Map)

```r
# Mapa temático con tmap
mapa_tematico <- tm_shape(tehuacan_polygon) +
  tm_polygons(col = "lightgreen", alpha = 0.3, border.col = "darkgreen", lwd = 2) +
  tm_shape(localidades_sf) +
  tm_symbols(col = "riqueza_aves", size = "riqueza_aves", scale = 1.5,
             palette = "viridis", title.col = "Riqueza de Aves", 
             title.size = "Riqueza de Aves") +
  tm_text("localidad", size = 0.8, ymod = 0.5) +
  tm_layout(main.title = "Reserva de Biosfera Tehuacán-Cuicatlán\nRiqueza de Aves por Localidad",
            legend.position = c("right", "bottom"),
            bg.color = "white") +
  tm_scale_bar() +
  tm_compass() +
  tm_grid()

# Guardar mapa
tmap_save(mapa_tematico, "mapas_tehuacan/mapa_tematico_aves.png", width = 12, height = 10, dpi = 300)
```

## 6. Mapa en Google Maps con ggmap

```r
# Obtener mapa base de Google Maps
mapa_base <- get_map(location = c(lon = mean(bbox_tehuacan[1:2]), 
                                  lat = mean(bbox_tehuacan[3:4])), 
                     zoom = 10, maptype = "terrain", source = "google")

# Convertir a dataframe para ggplot
localidades_df <- as.data.frame(localidades_sf)
localidades_df$longitud <- st_coordinates(localidades_sf)[,1]
localidades_df$latitud <- st_coordinates(localidades_sf)[,2]

# Mapa con Google Maps
mapa_google <- ggmap(mapa_base) +
  geom_point(data = localidades_df, 
             aes(x = longitud, y = latitud, size = riqueza_aves, color = riqueza_aves),
             alpha = 0.8) +
  scale_size_continuous(range = c(4, 12), name = "Riqueza de aves") +
  scale_color_viridis(name = "Riqueza de aves", option = "inferno") +
  geom_text(data = localidades_df, 
            aes(x = longitud, y = latitud, label = paste(localidad, "\n", riqueza_aves)),
            size = 3, color = "white", fontface = "bold", nudge_y = 0.005) +
  labs(title = "Riqueza de Aves - Google Maps",
       subtitle = "Reserva de Biosfera Tehuacán-Cuicatlán") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

ggsave("mapas_tehuacan/mapa_google_aves.png", plot = mapa_google, width = 12, height = 10, dpi = 300)
```

## 7. Mapa de calor con kernel density

```r
# Crear mapa de densidad de riqueza
coordenadas <- st_coordinates(localidades_sf)
densidad <- kde2d(coordenadas[,1], coordenadas[,2], n = 100)

# Convertir a raster
raster_densidad <- raster(densidad)
crs(raster_densidad) <- CRS("+init=epsg:4326")

# Mapa de calor
mapa_calor <- ggplot() +
  geom_raster(data = as.data.frame(raster_densidad, xy = TRUE), 
              aes(x = x, y = y, fill = layer), alpha = 0.6) +
  scale_fill_viridis(name = "Densidad", option = "magma") +
  geom_sf(data = tehuacan_polygon, fill = NA, color = "darkgreen", size = 1) +
  geom_sf(data = localidades_sf, aes(size = riqueza_aves), color = "red", alpha = 0.8) +
  scale_size_continuous(range = c(2, 8), name = "Riqueza de aves") +
  labs(title = "Densidad de Riqueza de Aves",
       subtitle = "Kernel Density Estimation") +
  theme_minimal()

ggsave("mapas_tehuacan/mapa_calor_aves.png", plot = mapa_calor, width = 12, height = 10, dpi = 300)
```

## 8. Mapa de coropletas con interpolación

```r
# Crear grid para coropletas
grid <- st_make_grid(tehuacan_polygon, cellsize = 0.05, what = "polygons") %>%
  st_sf() %>%
  st_intersection(tehuacan_polygon)

# Calcular riqueza promedio por celda
grid$riqueza_promedio <- NA
for(i in 1:nrow(grid)) {
  puntos_celda <- st_intersection(localidades_sf, grid[i,])
  if(nrow(puntos_celda) > 0) {
    grid$riqueza_promedio[i] <- mean(puntos_celda$riqueza_aves)
  }
}

# Mapa de coropletas
mapa_coropletas <- ggplot() +
  geom_sf(data = grid, aes(fill = riqueza_promedio), color = NA) +
  geom_sf(data = tehuacan_polygon, fill = NA, color = "black", size = 1) +
  geom_sf(data = localidades_sf, color = "red", size = 2) +
  scale_fill_viridis(name = "Riqueza promedio", option = "viridis", na.value = "gray90") +
  labs(title = "Riqueza Promedio de Aves por Celda",
       subtitle = "Mapa de Coropletas") +
  theme_minimal()

ggsave("mapas_tehuacan/mapa_coropletas_aves.png", plot = mapa_coropletas, width = 12, height = 10, dpi = 300)
```

## 9. Mapa para publicación científica

```r
# Mapa profesional para publicación
mapa_cientifico <- ggplot() +
  geom_sf(data = tehuacan_polygon, fill = "lightblue", alpha = 0.2, color = "blue", size = 0.5) +
  geom_sf(data = localidades_sf, aes(fill = riqueza_aves, size = riqueza_aves), 
          shape = 21, color = "black", stroke = 0.5) +
  scale_fill_viridis(name = "Riqueza de aves", option = "cividis") +
  scale_size_continuous(range = c(3, 10), guide = "none") +
  geom_sf_text(data = localidades_sf, aes(label = localidad), 
               size = 2.5, nudge_y = 0.015, check_overlap = TRUE) +
  labs(title = "Distribución de Riqueza de Aves",
       subtitle = "Reserva de Biosfera Tehuacán-Cuicatlán, México",
       caption = "Elaborado con R y paquetes espaciales") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        plot.subtitle = element_text(hjust = 0.5, size = 12),
        legend.position = "right") +
  annotation_scale(location = "bl", width_hint = 0.3) +
  annotation_north_arrow(location = "tr", which_north = "true", 
                         style = north_arrow_fancy_orienteering)

ggsave("mapas_tehuacan/mapa_cientifico_aves.tiff", plot = mapa_cientifico, 
       width = 8, height = 10, dpi = 600, compression = "lzw")
```

## 10. Script para exportar múltiples formatos

```r
# Función para exportar en múltiples formatos
exportar_mapa <- function(mapa, nombre_base) {
  # PNG alta resolución
  ggsave(paste0("mapas_tehuacan/", nombre_base, ".png"), plot = mapa, 
         width = 12, height = 10, dpi = 300)
  
  # PDF vectorial
  ggsave(paste0("mapas_tehuacan/", nombre_base, ".pdf"), plot = mapa, 
         width = 12, height = 10, device = cairo_pdf)
  
  # TIFF para publicación
  ggsave(paste0("mapas_tehuacan/", nombre_base, ".tiff"), plot = mapa, 
         width = 12, height = 10, dpi = 600, compression = "lzw")
  
  cat("Mapa", nombre_base, "exportado en múltiples formatos\n")
}

# Exportar mapas principales
exportar_mapa(mapa_basico, "mapa_basico_aves")
exportar_mapa(mapa_cientifico, "mapa_cientifico_aves")

# Crear archivo de metadatos
metadatos <- data.frame(
  Fecha = Sys.Date(),
  Localidades = nrow(localidades_sf),
  Riqueza_min = min(localidades_sf$riqueza_aves),
  Riqueza_max = max(localidades_sf$riqueza_aves),
  Riqueza_promedio = mean(localidades_sf$riqueza_aves),
  Paquetes_utilizados = "sf, terra, ggplot2, leaflet, tmap, raster"
)

write.csv(metadatos, "mapas_tehuacan/metadatos_mapas.csv", row.names = FALSE)
```

Este código completo te permite crear diversos tipos de mapas para visualizar la riqueza de aves en la Reserva de Biosfera Tehuacán-Cuicatlán, utilizando diferentes paquetes y técnicas de visualización espacial.