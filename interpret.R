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
library(ggplot2)
library(chron)

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

# keep in mind that looks pretty darn similar to the population density of the uk
browseURL("http://www.theguardian.com/news/datablog/interactive/2011/jun/30/uk-population-mapped")

# let's look at how the time of day and day of week factors into the accidents
accidents$dat <- times(paste0(accidents[,12], ":00"))
accidents$dat <- hours(accidents$dat)
theme_set(theme_gray(base_size = 16))
m <- ggplot(accidents, aes(x=dat, fill=as.factor(Day_of_Week)))
m <- m + geom_density(alpha=.2, adjust = 2.5)
m <- m + theme(legend.title=element_blank(), plot.title = element_text(size=20, face="bold", vjust=1))
m <- m + labs(x="Hour of Day", y="Proportion of Crashes", title="Time Distribution of Fatal Crashes")
m <- m + scale_x_continuous(limits=c(0,24), breaks=seq(0,24,2), 
                            label=c("12am","2am","4am","6am","8am","10am","12pm",
                                    "2pm","4pm","6pm","8pm","10pm","12am"))
m <- m + scale_fill_discrete(name="a",
                             breaks=c(1:7),
                             labels=c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"))
m
