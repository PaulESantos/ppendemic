#' pep_regdep_map
#'
#' @param spp_name species name
#'
#' @return
#' @export pep_regdep_map
#'
#' @examples
#' pep_regdep_map("Grosvenoria coelocaulis")
pep_regdep_map <- function(spp_name){
  peru <- peru_tibble%>%
    sf::st_as_sf()

  departa <- reg_depa %>%
    filter(accepted_name %in% c(spp_name)) %>%
    select(registro_dep) %>% flatten_chr()

  dep_data <- peru %>%
    mutate(fillcolor = if_else(dep_id %in% departa,
                               "#ff4000",
                               "transparent"))
  dep_data %>%
    ggplot() +
    geom_sf(fill = dep_data$fillcolor) +
    theme_bw() +
    labs(y = "Latitud",
         x = "Longitud",
         colour = " ",
         fill = " ",
         title = spp_name,
         subtitle = "Registro departamental",
         caption = "ppendemic: El libro rojo de las plantas\n endémicas del  Perú") +
    theme(strip.background = element_rect(fill = "transparent"),
          axis.title = element_text(face = "bold", size = 14),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          strip.text = element_text(face = "bold"),
          plot.title = element_text(hjust = .5),
          plot.subtitle = element_text(hjust = .5, size = 8),
          plot.caption = element_text(hjust = .5, colour = "#1a1aff",
                                      size = 5))

}
