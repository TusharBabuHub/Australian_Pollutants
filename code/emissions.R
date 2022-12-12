# emission clean up
em <- emissions %>%
  mutate(
    em_yr = as.numeric(str_extract(report_year, '\\d*(?=/)')),
    em_fac = str_to_title(str_replace_all(facility_name, "[^[:alnum:]]", " ")),
    lat = latitude,
    lon = longitude,
    .keep = 'unused'
  ) %>%
  group_by(em_yr, em_fac, state, lat, lon) %>%
  summarise(
    air = sum(air_total_emission_kg, na.rm = TRUE),
    water = sum(water_emission_kg, na.rm = TRUE),
    land = sum(land_emission_kg, na.rm = TRUE),
    total = sum(
      land_emission_kg,
      water_emission_kg,
      air_total_emission_kg,
      na.rm = TRUE
    )
  ) %>%
  unique() %>%
  select(em_yr, em_fac, air, water, land, total, state, lat, lon)


# get 3D Australian map
col <-
  colorRampPalette(c("cyan", "red"))(10)[log(floor(10 * (em$total) / 100) + 1)]
glb <-
  globejs(
    lat = em$lat,
    long = em$lon,
    value = log(em$total),
    color = col,
    atmosphere = FALSE
  )

# highest emission year
tot_em <- em %>% group_by(em_yr) %>% summarise(total = sum(total))

# highest emission facility
tot_fac <- em %>% group_by(em_fac) %>% summarise(total = sum(total))

# Wrap data frame in SharedData
sd <- SharedData$new(em)

# Create a filter input
filter_slider(
  "year",
  "Year",
  sd,
  column =  ~ em_yr,
  step = 1,
  width = 250
)

# create colour palette
pals <- colorFactor(palette = "RdYlBu", domain = sd$state)
paln <- colorNumeric(palette = "Okabe-Ito", domain = sd$total)


# Use SharedData like a dataframe with Crosstalk-enabled widgets
em_lf <- leaflet(sd) %>%
  addTiles() %>%
  addScaleBar() %>%
  setView(lat = mean(em$lat),
          lng = mean(em$lon),
          zoom = 4)  %>% addCircles(
            color =  ~ pals(state),
            radius = ~ log(total),
            fillOpacity = .6
          ) %>% addMarkers(label = facilities$facility_name,
                           clusterOptions = markerClusterOptions())