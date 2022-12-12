# get only state and class
facs <- facilities %>%
  select(state,
         suburb,
         primary_anzsic_class_name,
         main_activities) %>%
  mutate(
    main_activities = str_to_title(str_replace_all(main_activities, "[^[:alnum:]]", " ")),
    state =  str_to_upper(str_replace_all(state, "[^[:alnum:]]", " ")),
    suburb = str_to_title(str_replace_all(suburb, "[^[:alnum:]]", " "))
  ) %>%
  group_by(state,
           suburb,
           primary_anzsic_class_name) %>%
  summarise(count = n())

# insight variables
# all state count
state_count <-
  facs %>% group_by(state) %>% summarise(count = sum(count))

# max facility state
state_max <-
  state_count[state_count$count == max(state_count$count), ]

# min facility state
state_min <-
  state_count[state_count$count == min(state_count$count), ]

# max facility suburb
suburb_max <-
  facs %>% group_by(state, suburb) %>% summarise(count = sum(count))
suburb_max <- suburb_max[suburb_max$count == max(suburb_max$count), ]

# max facility class
class_max <-
  facs %>% group_by(primary_anzsic_class_name) %>% summarise(count = sum(count))
class_max <- class_max[class_max$count == max(class_max$count), ]

# max facility activity
act_max <-
  facilities %>% group_by(main_activities) %>% summarise(count = sum(n()))
act_max <- act_max[act_max$count == max(act_max$count), ]

# display options
options(
  reactable.theme = reactableTheme(
    color = "hsl(233, 9%, 87%)",
    backgroundColor = "hsl(233, 9%, 19%)",
    borderColor = "hsl(233, 9%, 22%)",
    stripedColor = "hsl(233, 12%, 22%)",
    highlightColor = "hsl(233, 12%, 24%)",
    inputStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
    selectStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
    pageButtonHoverStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
    pageButtonActiveStyle = list(backgroundColor = "hsl(233, 9%, 28%)")
  )
)


# display facilities
disp_facs <- reactable(
  facs,
  groupBy = c("state"),
  columns = list(
    state = colDef(style = list(fontWeight = "bold")),
    primary_anzsic_class_name = colDef(name = "activity class"),
    count = colDef(
      aggregate = "sum",
      name = "count",
      style = list(fontWeight = "bold")
    )
  ),
  minRows = 9,
  bordered = TRUE,
  paginateSubRows = TRUE,
  pagination = TRUE,
  defaultPageSize = 9,
  filterable = TRUE,
  searchable = TRUE,
  style = list(fontSize = '12px'),
  width = 'auto',
  height = 'auto',
  resizable = TRUE,
  wrap = TRUE
)

## Creating a map of facilities
facs_map <- leaflet() %>%
  addTiles() %>%
  addScaleBar() %>%
  setView(
    lat = mean(facilities$latitude),
    lng = mean(facilities$longitude),
    zoom = 4
  ) %>% addMarkers(
    lng = facilities$longitude,
    lat = facilities$latitude,
    label = facilities$facility_name,
    clusterOptions = markerClusterOptions()
  )
