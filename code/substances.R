# Combine category columns
subs <-
  substances %>% mutate(
    across(starts_with('cat'),
           ~ if_else(.,
                     str_remove(cur_column(

                     ),
                     'cat'),
                     NULL),
           .names = 'new{col}'),
    .keep = 'unused',
    .before = voc
  ) %>% unite(categories,
              starts_with('new'),
              na.rm = TRUE,
              sep = '-')

# Combine emission medium columns
subs <- subs %>% mutate(across(
  starts_with('emissions_to_'),
  ~ if_else(.,
            str_remove(cur_column(),
                       'emissions_to_'), NULL),
  .names = 'new{col}'
),
.keep = 'unused') %>% unite(emission_medium,
                            starts_with('new'),
                            na.rm = TRUE,
                            sep = '-')
# Set reporting year as start year
subs <-
  subs %>% mutate(
    year_first_reported = str_extract(first_reporting_year,
                                      '\\d*(?=/)'),
    .keep = 'unused'
  ) %>% select(substance_name,
               categories,
               year_first_reported,
               voc,
               emission_medium,
               fact_sheet_url,
               c1_substance_use_threshold_kg,
               c2_fuel_use_threshold_kg,
               c2a_hour_fuel_use_threshold_kg,
               c3_emissions_threshold_kg)

# Set column names
colnames(subs) <-
  c('name',
    'category',
    'first reported',
    'voc',
    'medium',
    'factsheet',
    '1',
    '2',
    '2a',
    '3')

# Create datatable for display
#disp_subs <-
#  datatable(
#    subs,
#    plugins = 'ellipsis',
#    options = list(
#      autoWidth = TRUE,
#      paging = TRUE,
#      pageLength = 5,
#      scrollY = 300,
#      scrollCollapse = TRUE,
#      columnDefs = list(list(type = 'ellipsis', targets = 5))
#    ),
#    fillContainer = TRUE
#  )

options(reactable.theme = reactableTheme(
  color = "hsl(233, 9%, 87%)",
  backgroundColor = "hsl(233, 9%, 19%)",
  borderColor = "hsl(233, 9%, 22%)",
  stripedColor = "hsl(233, 12%, 22%)",
  highlightColor = "hsl(233, 12%, 24%)",
  inputStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
  selectStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
  pageButtonHoverStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
  pageButtonActiveStyle = list(backgroundColor = "hsl(233, 9%, 28%)")
))


disp_subs <- reactable(
  data = subs[!names(subs)=='factsheet'],
  columns = list(name = colDef(name = "Substance_Name", sticky = 'left'),
                 category = colDef(name = "Category", sticky = 'left')),
  columnGroups = list(colGroup("Threshold per category(kg)", columns = c('1',
                                                         '2',
                                                         '2a',
                                                         '3'))),
  pagination = TRUE,
  defaultPageSize = 5,
  filterable = TRUE,
  searchable = TRUE,
  striped = FALSE,
  highlight = FALSE,
  details = function(index) {
    url <- subs$factsheet[index]
    tags$a(href = url,
           target = "_blank",
           paste("Factsheet for", subs$name[index]))},
  style = list(fontSize='12px'),
  width = 'auto',
  height = 'auto',
  resizable = TRUE,
  wrap = TRUE
)

