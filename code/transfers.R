# clean up transfers data
xfr <-
  transfers %>% mutate(xfr_yr = str_extract(report_year, '\\d*(?=/)'),
                       .keep = 'unused') %>%
  mutate(
    class = str_to_title(
      str_replace_all(primary_anzsic_class_name, "[^[:alnum:]]", " ")
    ),
    xfr_tgt = str_to_title(str_replace_all(pivot_facility_name, "[^[:alnum:]]", " ")),
    state =  str_to_upper(str_replace_all(state, "[^[:alnum:]]", " ")),
    suburb = str_to_title(str_replace_all(suburb, "[^[:alnum:]]", " ")),
    xfr_wt = transfer_amount_kg,
    xfr_lat = latitude,
    xfr_lon = longitude
  ) %>%
  select(xfr_yr,
         xfr_tgt,
         xfr_lat,
         xfr_lon,
         suburb,
         state,
         class,
         substance_name,
         xfr_wt)

# state wise substance amount each year
xfr_state_substance_amt_series <-
  xfr %>% group_by(xfr_yr, state) %>% summarise(cum_sub = length(unique(substance_name)), cum_wt = sum(xfr_wt))

# plot transfers
df <- xfr_state_substance_amt_series

fig <- df %>%

  plot_ly(
    x = ~ cum_wt,

    y = ~ cum_sub,

    size = ~ cum_sub,

    color = ~ state,

    frame = ~ xfr_yr,

    text = ~ state,

    hoverinfo = "text",

    type = 'scatter',

    mode = 'markers'

  )

fig <- fig %>% layout(xaxis = list(type = "log"), title = "Substance transfer over years")
fig <- fig %>%

  animation_opts(1000, easing = "elastic", redraw = FALSE)


fig <- fig %>%

  animation_slider(currentvalue = list(prefix = "YEAR ", font = list(color =
                                                                       "red")))
