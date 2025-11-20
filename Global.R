#G1 Load large wood, river, and bridge data ----
lw_points <- st_read("Large_Wood.shp")
river <- st_read("RiverTorridge.shp")
bridges <- st_read("River Torridge Bridges.shp")
lw_catchers <- st_read("Large_Wood_Catchers.shp")
nearest_distance <- st_read("nearest_distance.shp")
bridges_snapped <- st_read("bridges_snapped.shp")
bridges <- bridges[!st_is_empty(bridges$geometry), ]

#Convert vectors to CRS 4326 
lw_points <- st_transform(lw_points, crs = 4326)
river <- st_transform(river, crs = 4326)
bridges <- st_transform(bridges, crs = 4326)
bridges_snapped <- st_transform(bridges_snapped, crs = 4326)
lw_catchers <- st_transform(lw_catchers, crs = 4326)
nearest_distance <- st_transform(nearest_distance, crs = 4326)

#Part B 
#2.1. Clusters and bridges 
clusters <- st_read("TorridgeClusters.shp")
clusters <- st_transform(clusters, crs = 4326)

#Dynamically generate colours based on number of unique clusters
num_clusters <- length(unique(clusters$CLUSTER_ID))
pal_clusters <- colorFactor(palette = colorRampPalette(brewer.pal(12, "Paired"))(num_clusters),domain = clusters$CLUSTER_ID)

#Task 4 bridges 
bridges <- st_read("River Torridge Bridges.shp")
bridges <- st_transform(bridges, crs = 4326)


#2.3 Add heatmap
heatmap <- rast("heatmap_buffer1.tif")
heatmap <- project(heatmap, crs(river))

pal_heatmap <- colorNumeric(palette = "inferno", domain = na.omit(values(heatmap)), na.color = "transparent")

#2.4 Add raster of aspect 
aspect <- rast("Aspect Torridge.tif")
aspect <- project(aspect, crs(river))

pal_aspect <- colorNumeric(palette = "inferno", domain = na.omit(values(aspect)), na.color = "transparent")
aspect <- aggregate(aspect, fact=2)

#2.4 Add raster of Slope 
slope <- rast("Slope Torridge.tif")
slope <- project(slope, crs(river))

pal_slope<- colorNumeric(palette = "inferno", domain = na.omit(values(slope)), na.color = "transparent")
slope <- aggregate(slope, fact=2)

heatmap <- raster(heatmap)
aspect <- raster(aspect)
slope <- raster(slope)


