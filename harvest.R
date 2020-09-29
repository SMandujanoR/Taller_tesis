# Este script sirve para leer páginas web e incluso extrear algunas secciones de la misma para esto, previamente se requiere que en Google Chrome se instale la aplicación
# "selectorgadget"

library(rvest)
library(tidyverse)

# lee la página
url <- "http://booksandjournals.brillonline.com/content/journals/10.1163/157075610x523251"
page <- read_html(url)

# para extraer el resumen
abstract <- html_nodes(page, ".description")
(resumen <- html_text(abstract))

# -----------------------------
# otra página
url <- "http://onlinelibrary.wiley.com/doi/10.1111/j.2041-210X.2011.00094.x/full"
page <- read_html(url)

# para extraer el resumen
abstract <- html_nodes(page, "#abstract")
(resumen <- html_text(abstract))

# para extraer datos de una tabla del artículo
tabla <- html_nodes(page, ".table__data")
(tabla <- html_text(tabla))
(tabla <- as.data.frame(tabla))
(tabla <- as.tibble(tabla)) # alternativamente se puede emplear esto
View(tabla)

# -------------------------------
# FIN SCRIPT

 