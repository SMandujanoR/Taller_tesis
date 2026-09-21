################################
# Introducción a R y RStudio para datos biológicos
# Ejemplo de análisis de multivariado de agrupamiento de datos vegetación en Tantoyuca, Ver.
# Basado en Angel y Mandujano (2017)
# Publicado en Therya (PDF anexo)
# Elaborado por: Salvador Mandujano R
# Última modificación: Marzo 13, 2025
##################################

# Es una tesis donde se estimó la densidad de venado cola blanca en cuatro localidades de Tantoyuca en el estado de Veracruz. Se empló el método de conteo de pellets en 40 transectos de 500 x 2 m (10 por localidad). Además, se muestreó la vegetación con la finalidad de conocer si existía una relación entre la densidad de venados y la estructura de la vegetación.
#
# En este ejercicio nos concentraremos en el segundo objetivo de la tesis, es decir en el análisis de la vegetación. 

# Específicamente vamos a resolver los siguientes puntos: 
# 1) Crear un mapa de la ubicación de los transectos en cada localidad.
#
# 2) Crear un mapa de abundancias de las principales especies arbóreas en cada transecto de las localidades.
#
# 3) Elaborar un dendograma de similitud de los transectos en función de su composición florística, empleando una aproximación con análisis multivariados.
#
# 4) Comparar estadísticamente la estructura de la vegetación entre cada uno de los clusters obtenidos en el dendograma
#
# 5) Comparar estadísticamente la densidad de venados entre las cuatro localidades, los tipos de vegetación y entre los clusters del dendograma
#
# IMPORTANTE: En este script solo se presenta el proceso de análisis hiper simplificado, omitiendo muchos detalles de los análisis y pruebas previas a la definición del dendograma final, y otros análisis.

###################################
# Paquetes
library(ade4)
library(vegan)
library(gclus)
library(cluster)
library(RColorBrewer)
library(labdsv)

# Lectura de datos

# matriz de especies
spe <- read.csv("spe.csv", row.names=1)
View(spe)

# matriz de variables ambientales y ecológicas
datos_env <- read.csv("env.csv", row.names=1)
View(datos_env)

# matriz de UTMs de los transectos
spa <- read.csv("spa.csv", row.names=1)
View(spa)

###################################
# 1) Crear un mapa de la ubicación de los transectos en cada localidad. 
###################################

plot(spa, type="n", main="Localizacion de transectos",
     xlab="UTM", ylab="UTM")
text(spa, row.names(spa), cex=1, col="red")
text(574179,2355958,"Chiquero", cex= 1.5, col= "black")
text(591215,2358530,"Pensador", cex= 1.5, col= "black")
text(584191,2366367,"Porvenir", cex= 1.5, col= "black")
text(571869,2371458,"Monte Gde", cex= 1.5, col= "black")
text(580531,2354500,"Corralillo", cex= 1.5, col= "black")

###################################
# 2) Crear un mapa de abundancias de las principales especies arbóreas en cada transecto de las localidades.
###################################

par(mfrow=c(1,1), mar= c(5,5,5,5))

plot(spa, cex=(spe$Gua_ulm*2), xlab="UTM", ylab="UTM", pch= 21, bg= "orange", col= "white", frame = F, cex.axis=0.7, las= 1)

points(spa, cex=(spe$Ced_odo * 1.5), col= "white", bg="lightgreen", pch= 21)

points(spa, cex=(spe$Aca_pen * 5), pch= 21, bg="yellow", col= "gray")

legend(586000,2375500, paste(c("Guazuma ulmifolia\n", "Cedrela odorata\n", "Acacia pennatula\n")), 
pch=21, pt.bg=c("orange","lightgreen","yellow"), bty="n", col= "black", cex=1.5)

text(574179,2355958,"Chiquero", cex= 0.8, col= "black")
text(591215,2358530,"Pensador", cex= 0.8, col= "black")
text(584191,2366367,"Porvenir", cex= 0.8, col= "black")
text(572869,2371000,"Monte Grande", cex= 0.8, col= "black")
text(580531,2354500,"Coralillo", cex= 0.8, col= "black")

###################################
# 3) Elaborar un dendograma de similitud de los transectos en función de su composición florística
###################################

spe.norm <- decostand(spe, "normalize")
spe.ch <- vegdist(spe.norm, "euc")

# Computo de los UPGMA
spe.ch.UPGMA <- hclust(spe.ch, method="average")
plot(spe.ch.UPGMA)

# Computo de varianza mínima de Ward's
spe.ch.ward <- hclust(spe.ch, method="ward")
plot(spe.ch.ward)
 
# Número de grupos
k <- 3
spebc.UPGMA.g <- cutree(spe.ch.UPGMA, k)
spebc.ward.g <- cutree(spe.ch.ward, k)

cutg <- cutree(spe.ch.ward, k=k)
sil <- silhouette(cutg, spe.ch)
rownames(sil) <- row.names(spe)
par(mfrow=c(1,1))
plot(sil, main="Silhouette plot", 
	cex.names=0.8, col=2:(k+1), nmax=100)

# Resultados finales: cluster y mapas 
spe.chwo <- reorder.hclust(spe.ch.ward, spe.ch)

par(mfrow=c(1,1))
plot(spe.chwo, hang=-1, xlab="3 groups", sub="", 
	ylab="Distancia", main="", 
	labels=cutree(spe.chwo, k=k))
rect.hclust(spe.chwo, k=k)

# Plot del dendrograma final

"hcoplot" <- function(tree, diss, k, title="")
{
        require(gclus)
        gr <- cutree(tree, k=k)
        tor <- reorder.hclust(tree, diss)
        plot(tor, hang=-1, xlab="Transects", ylab= "Distance", sub="", main=title)
        so <- gr[tor$order]
        gro <- numeric(k)
        for (i in 1:k)
        {
            gro[i] <- so[1]
            if (i<k) so <- so[so!=gro[i]]
        }

      rect.hclust(tor, k=k, border=gro+1, cluster=gr)
      legend("topright", paste("Cluster",1:k), pch=22, col=2:(k+1), bty="n")
} # termina función

hcoplot(spe.ch.ward, spe.ch, k=4)

# En forma de mapa 
plot(spa, asp=1, type="n", main="", las= 1,
	xlab="UTM", ylab="UTM", cex.axis= 0.7, frame= F)

grw <- spebc.ward.g
k <- length(levels(factor(grw)))
for (i in 1:k)
{
	points(spa[grw==i,1], spa[grw==i,2], pch=i+20, cex=3, col="grey", bg=i+1)
}
text(spa, row.names(spa), cex=0.8, col="white", font=1)
legend("topright", paste("Cluster", 1:k), pch=(1:k)+20, col=2:(k+1), 
	pt.bg=2:(k+1), pt.cex=2, bty="n")

# Dendograma y abundancia de especies
dend <- as.dendrogram(spe.chwo)
ord <- vegemite(spe, spe.chwo)
heatmap(t(spe[rev(ord$species)]), Rowv=NA, Colv=dend,
	col=c("white", brewer.pal(10,"Blues")), scale="none", margin=c(2,2), 
	ylab="", xlab="")

#############################################
# 4) Comparar estadísticamente la estructura de la vegetación entre cada uno de los clusters obtenidos en el dendograma
###################################

# Calculo de índices de diversidad

# Riqueza de especies
N0 <- rowSums(spe >0)        
# Shannon 
H <- diversity(spe)         
# Serie Hill
N1 <- exp(H)
# Simpson
N2 <- diversity(spe, "inv") 
# Pielou
E1 <- N1/N0                  
# equitatividad Shannon
J <- H/log(N0)         
# equitatividad Simpson
E2 <- N2/N0            

diversidad <- round(data.frame(N0, H, N1, N2, E1, E2, J),2)
View(diversidad)

# datos
attach(datos_env)
names(datos_env)

# Pruebas de normalidad
shapiro.test(resid(lm(Arb_den ~ as.factor(Cluster))))
shapiro.test(resid(lm(Arb_alt ~ as.factor(Cluster))))
shapiro.test(resid(lm(Arb_ab ~ as.factor(Cluster))))

# --------------------------------------------
# Analisis a nivel de clusters

# ANOVAs
par(mfrow=c(1,1))

model <- aov(Arb_den ~ Cluster)
summary(model)
plot(TukeyHSD(model), cex.axis=0.7, las=1)

model <- aov(Arb_alt ~ Cluster)
summary(model)
plot(TukeyHSD(model), cex.axis=0.7, las=1)

model <- aov(Arb_ab ~ Cluster)
summary(model)
plot(TukeyHSD(model), cex.axis=0.7, las=1)

# Kruskal-Wallis
kruskal.test(Alt ~ as.factor(Cluster))

# Graficas
par(mfrow=c(2,3))
boxplot(Arb_den ~ Cluster, main="Densidad (***)", las=1, frame= F,
        ylab="ind/m2", xlab= "Cluster", col=2:5, varwidth=TRUE)
boxplot(Arb_alt ~ Cluster, main="altura (***)", las=1, frame= F,
        ylab="m", xlab= "Cluster", col=2:5, varwidth=TRUE)
boxplot(Arb_ab ~ Cluster, main="Area basal (***)", las=1,frame= F, 
        ylab="m2", xlab= "Cluster", col=2:5, varwidth=TRUE)
boxplot(N0 ~ Cluster, main="N0 (ns)", las=1, frame= F,
        ylab="numero", xlab= "Cluster", col=2:5, varwidth=TRUE)
boxplot(N1 ~ Cluster, main="Diversidad (ns)", las=1, frame= F,
        ylab="indice", xlab= "Cluster", col=2:5, varwidth=TRUE)
boxplot(E1 ~ Cluster, main="Equitatividad (ns)", las=1, frame= F,
        ylab="indice", xlab= "Cluster", col=2:5, varwidth=TRUE)

##################################################
# 5) Comparar estadísticamente la densidad de venados entre las cuatro localidades, los tipos de vegetación y entre los clusters del dendograma
###################################

names(datos_env)

anova(lm(Densidad ~ Sitio))
anova(lm(Densidad ~ Tipo_vegetacion))
anova(lm(Densidad ~ Cluster))

par(mfrow=c(1,3))
boxplot(Densidad ~ Sitio, main="Sitios (**)", 
        las=1, frame= F, cex.axis= 0.6,
        ylab="venados/km2", xlab= "", col=2:5, varwidth=TRUE)
boxplot(Densidad ~ Tipo_vegetacion, main="Tipo vegtacion (*)", 
        las=1, frame= F, cex.axis= 0.5,
        ylab="venados/km2", xlab= "", col=2:5, varwidth=TRUE)
boxplot(Densidad ~ Cluster, main="Cluster (*)", 
        las=1, frame= F, cex.axis= 0.8,
        ylab="venados/km2", xlab= "", col=2:5, varwidth=TRUE)

###############################
# FIN DEL SCRIPT
rm(list=ls()) 
dev.off()



