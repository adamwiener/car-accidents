# these pages were super useful; thanks very much!
# http://www.r-bloggers.com/maps-in-r-plotting-data-points-on-a-map/
# http://www.everydayanalytics.ca/2014/09/5-ways-to-do-2d-histograms-in-r.html

# load some libraries that I'll be using
library(rworldmap)
library(rworldxtra)
library(maptools)
library(raster)
library(hexbin)
library(RColorBrewer)

# import dataset, this might take a while
accidents <- read.csv("Accidents0514.csv")
# casualties <- read.csv("Casualties0514.csv") # not in use
# vehicles <- read.csv("Vehicles0514.csv") # not in use

# plot some on the map
newmap <- getMap(resolution = "high")
plot(newmap,
     xlim = c(-10,4),
     ylim = c(50,59.5))
cas <- head(accidents, 10000)
points(cas$Longitude, cas$Latitude, col = cas$Number_of_Casualties, pch = 19)

# Create hexbin object and plot
rf <- colorRampPalette(rev(brewer.pal(11,'Spectral')))
hexbinplot(Latitude~Longitude, data=accidents, colramp=rf, trans=log, inv=exp, xbins=75)

