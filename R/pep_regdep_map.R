#' pep_regdep_map
#'
#' @param spp_name species name
#' @name pep_regdep_map
#'
#' @return ggplot object
#' @export
#'
#' @examples
#'
#' pep_regdep_map("Grosvenoria coelocaulis")
pep_regdep_map <- function(spp_name){
  #peru <- peru %>%
   # sf::st_as_sf()

  departa <- reg_depa %>%
    poorman::filter(accepted_name == spp_name)

  dep_data <- peru %>%
    poorman::mutate(fillcolor = poorman::if_else(dep_id %in% departa$registro_dep,
                               "#ff4000",
                               "transparent"))
  dep_data %>%
    ggplot2::ggplot() +
    ggplot2::geom_sf(fill = dep_data$fillcolor) +
    ggplot2::theme_bw() +
    ggplot2::labs(y = "Latitud",
         x = "Longitud",
         colour = " ",
         fill = " ",
         title = spp_name,
         subtitle = "Registro departamental",
         caption = "ppendemic: El libro rojo de las plantas\n endémicas del  Perú") +
    ggplot2::theme(strip.background = element_rect(fill = "transparent"),
          axis.title = element_text(face = "bold", size = 14),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          strip.text = element_text(face = "bold"),
          plot.title = element_text(hjust = .5),
          plot.subtitle = element_text(hjust = .5, size = 8),
          plot.caption = element_text(hjust = .5, colour = "#1a1aff",
                                      size = 5))

}
