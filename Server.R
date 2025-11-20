#S1 Render leaflet map ----
#Leaflet map output 
output$map <- renderLeaflet({
  leaflet() %>%
    setView(lng = -4.206878, lat = 50.916601, zoom = 11.3) %>%
    addProviderTiles(providers$OpenStreetMap, group = "Colour") 
})

# Add all dynamic markers in one observe so they don't overwrite each other
observe({
  leafletProxy("map") %>%
    clearMarkers() %>%
    
    # add pop ups for large wood
    addCircleMarkers(
      data = clusters,
      fillColor = ~pal_clusters(CLUSTER_ID),
      color = "black",
      weight = 1,
      radius = 5,
      stroke = TRUE,
      fillOpacity = 0.7,
      popup = ~paste(
        "<b>LW_Type:</b>", LW_Type,
        "<br><b>Cluster ID:</b>", CLUSTER_ID
      ),
      group = "Large Wood"
    ) %>%
    
    # add popups for bridge points 
    addCircleMarkers(
      data = bridges_snapped,
      color = "black",
      fillColor = "purple",
      weight = 1,
      radius = 9,
      stroke = TRUE,
      fillOpacity = 0.7,
      popup = ~paste(
        "<b>BRIDGE.NAM:</b>", BRIDGE_,
        "<br><b>OWNER:</b>", OWNER,
        "<br><b>LW_upstream:</b>", LW_pstr
      ),
      group = "Bridges"
    ) %>%
    
    # add popups for large wood catchers 
    addCircleMarkers(
      data = lw_catchers,
      color = "black",
      fillColor = "yellow",
      weight = 1,
      radius = 7,
      stroke = TRUE,
      fillOpacity = 0.7,
      popup = ~paste(
        "<b>Catcher.Nu:</b>", Catcher.Nu
      ),
      group = "Large Wood Catchers"
    ) %>%
    
    # add popups for nearest distance lines
    addPolylines(
      data = nearest_distance,
      color = "black",
      weight = 2,
      opacity = 0.8,
      group = "Nearest Distance"
    ) %>%
    
    # heatmap raster layer
    addRasterImage (heatmap, colors = pal_heatmap, opacity = 0.7, group = "Heatmap")%>%
    # aspect raster layer
    addRasterImage (aspect, colors = pal_aspect, opacity = 0.7, group = "Aspect")%>%
    # slope raster layer
    addRasterImage (slope, colors = pal_slope, opacity = 0.7, group = "Slope")%>%
    addImageQuery(
      heatmap,
      layerId = "Heatmap",
      prefix = "Value: ",
      digits = 2,
      position = "topright",
      type = "mousemove",  # Show values on mouse movement
      options = queryOptions(position = "topright"),  # Remove the TRUE text
      group = "Heatmap"
    ) %>%
     addLayersControl(
       baseGroups = c("Colour"),
       overlayGroups = c("Bridges", "Large Wood","Heatmap", "Aspect", "Slope", "Large Wood Catchers",  "Nearest Distance"),
       options = layersControlOptions(collapsed = FALSE)
      )
    })