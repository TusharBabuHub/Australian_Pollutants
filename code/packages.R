# List of packages for session
required_packs = c(
  'revealjs',
  'tidyverse',
  'gganimate',
  'plotly',
  'crosstalk',
  'DT',
  'htmltools',
  'reactable',
  'dm',
  'DiagrammeR',
  'DiagrammeRsvg',
  'leaflet',
  'threejs'
)

# Install CRAN packages (if not already installed)
inst <- required_packs %in% installed.packages()
if (length(required_packs[!inst]) > 0)
  install.packages(required_packs[!inst],
                   repos = "http://cran.us.r-project.org")

# Load packages into session
lapply(required_packs, library, character.only = TRUE)