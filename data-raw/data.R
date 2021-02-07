#' load data
#'
load("data-raw/especiespp.rda")
load("data-raw/reg_depa.rda")
load("data-raw/peru_tibble.rda")
#' make simple features object-peru map
#'
peru <- peru_tibble %>%
  sf::st_as_sf()

## code to prepare `data` dataset goes here

usethis::use_data(data, overwrite = TRUE)
