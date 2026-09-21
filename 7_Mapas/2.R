# Código para descargar y trabajar con Áreas Naturales Protegidas de Costa Rica

## Opción 1: Descargar desde SINAC (Sistema Nacional de Áreas de Conservación)

# Cargar paquetes necesarios
library(sf)
library(ggplot2)
library(leaflet)
library(dplyr)

# Crear directorio para datos
dir.create("datos_costa_rica", showWarnings = FALSE)

# URL del shapefile de áreas protegidas de Costa Rica 
url_shapefile <- "https://github.com/OpenGeoHub/agriculture-suitability/raw/master/data/protected_areas/protected_areas.shp"

## Opción 2: Crear datos de ejemplo para áreas protegidas de Costa Rica

# Coordenadas aproximadas de Costa Rica
costa_rica_bbox <- st_bbox(c(xmin = -86, xmax = -82, ymin = 8, ymax = 11.5), crs = 4326)

# Crear algunas áreas protegidas simuladas basadas en las reales
areas_protegidas_cr <- st_sf(
  nombre = c("Parque Nacional Manuel Antonio", 
             "Reserva Biológica Monteverde",
             "Parque Nacional Corcovado",
             "Parque Nacional Tortuguero",
             "Area de Conservación Guanacaste"),
  categoria = c("Parque Nacional", "Reserva Biológica", "Parque Nacional", "Parque Nacional", "Area de Conservación"),
  area_ha = c(1600, 10500, 42500, 31200, 147000),
  geometry = st_sfc(
    # Polígonos simplificados para ejemplo
    st_polygon(list(rbind(c(-84.15, 9.38), c(-84.12, 9.38), c(-84.12, 9.41), c(-84.15, 9.41), c(-84.15, 9.38)))),
    st_polygon(list(rbind(c(-84.80, 10.30), c(-84.75, 10.30), c(-84.75, 10.35), c(-84.80, 10.35), c(-84.80, 10.30)))),
    st_polygon(list(rbind(c(-83.60, 8.50), c(-83.55, 8.50), c(-83.55, 8.55), c(-83.60, 8.55), c(-83.60, 8.50)))),
    st_polygon(list(rbind(c(-83.50, 10.45), c(-83.45, 10.45), c(-83.45, 10.50), c(-83.50, 10.50), c(-83.50, 10.45)))),
    st_polygon(list(rbind(c(-85.70, 10.85), c(-85.65, 10.85), c(-85.65, 10.90), c(-85.70, 10.90), c(-85.70, 10.85))))
  )
)

# Establecer el sistema de coordenadas
st_crs(areas_protegidas_cr) <- 4326

# Guardar como shapefile de ejemplo
st_write(areas_protegidas_cr, "datos_costa_rica/areas_protegidas_cr.shp", delete_layer = TRUE)

plot(areas_protegidas_cr)

######################################
## Opción 3: Código para leer shapefile real ya descargado

# Leer el shapefile
areas_protegidas <- st_read("datos_costa_rica/areas_protegidas_cr.shp", quiet = TRUE)
  
# Información básica
  cat("=== INFORMACIÓN DEL SHAPEFFILE ===\n")
  cat("Número de áreas protegidas:", nrow(areas_protegidas), "\n")
  cat("Sistema de coordenadas:", st_crs(areas_protegidas)$input, "\n")
  cat("Extensión:", paste(round(st_bbox(areas_protegidas), 2), collapse = ", "), "\n\n")
  
# Mostrar estructura de datos
  cat("Estructura de datos:\n")
  print(str(areas_protegidas, max.level = 1))
  
## Visualización de las áreas protegidas con ggplot2

visualizar_areas_protegidas <- function(areas_protegidas) {
  
  # Mapa básico
  mapa_basico <- ggplot() +
    geom_sf(data = areas_protegidas, aes(fill = categoria), alpha = 0.7, color = "black", size = 0.3) +
    scale_fill_viridis_d() +
    labs(title = "Áreas Naturales Protegidas de Costa Rica",
         subtitle = "Sistema Nacional de Áreas de Conservación (SINAC)",
         fill = "Categoría",
         caption = "Fuente: SINAC") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"), plot.subtitle = element_text(hjust = 0.5))
  
  print(mapa_basico)
  
  # Guardar mapa
  ggsave("datos_costa_rica/mapa_areas_protegidas.png", plot = mapa_basico, width = 12, height = 10, dpi = 300)
  
  return(mapa_basico)
}

# Visualizar áreas de ejemplo
mapa <- visualizar_areas_protegidas(areas_protegidas_cr)


######################################
## Mapa interactivo con leaflet

mapa_interactivo_cr <- leaflet(areas_protegidas_cr) %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~colorFactor("viridis", categoria)(categoria),
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    popup = ~paste("<b>", nombre, "</b><br>",
                   "Categoría: ", categoria, "<br>",
                   "Área: ", format(area_ha, big.mark = ","), " ha")
  ) %>%
  addLegend(
    position = "bottomright",
    pal = colorFactor("viridis", areas_protegidas_cr$categoria),
    values = ~categoria,
    title = "Categoría de Protección"
  ) %>%
  addScaleBar() %>%
  setView(lng = -84.0, lat = 9.8, zoom = 7)

# Mostrar mapa interactivo
mapa_interactivo_cr

# Guardar como HTML
library(htmlwidgets)

saveWidget(mapa_interactivo_cr, "datos_costa_rica/mapa_interactivo_cr.html")

## Análisis básico de las áreas protegidas

analizar_areas_protegidas <- function(areas_protegidas) {
  
  # Calcular área real si no existe la columna
  if (!"area_ha" %in% names(areas_protegidas)) {
    areas_protegidas$area_ha <- as.numeric(st_area(areas_protegidas)) / 10000
  }
  
  # Resumen por categoría
  resumen_categoria <- areas_protegidas %>%
    st_drop_geometry() %>%
    group_by(categoria) %>%
    summarise(
      n_areas = n(),
      area_total_ha = sum(area_ha, na.rm = TRUE),
      area_promedio_ha = mean(area_ha, na.rm = TRUE),
      area_maxima_ha = max(area_ha, na.rm = TRUE)
    ) %>%
    arrange(desc(area_total_ha))
  
  cat("=== RESUMEN POR CATEGORÍA ===\n")
  print(resumen_categoria)
  
  # Área total protegida
  area_total <- sum(areas_protegidas$area_ha, na.rm = TRUE)
  cat("\nÁrea total protegida:", format(area_total, big.mark = ","), "ha\n")
  
  # Gráfico de áreas por categoría
  grafico_barras <- ggplot(resumen_categoria, aes(x = reorder(categoria, area_total_ha), y = area_total_ha)) +
    geom_bar(stat = "identity", fill = "steelblue", alpha = 0.7) +
    coord_flip() +
    labs(title = "Área Total por Categoría de Protección",
         x = "Categoría",
         y = "Área (ha)") +
    theme_minimal() +
    scale_y_continuous(labels = scales::comma)
  
  print(grafico_barras)
  ggsave("datos_costa_rica/grafico_areas_categoria.png", plot = grafico_barras, 
         width = 10, height = 6, dpi = 300)
  
  return(resumen_categoria)
}

# Ejecutar análisis
resumen <- analizar_areas_protegidas(areas_protegidas_cr)

## Instrucciones para obtener datos reales:
https://www.sinac.go.cr/ES/atap/Paginas/default.aspx
