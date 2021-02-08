#' pep_regdep_map
#'
#' @param spp_name species name
#' @name pep_regdep_map
#'
#' @return ggplot object
#' @export
#'
#' @examples
#' # Basic usage
#' pep_regdep_map("Grosvenoria coelocaulis")
pep_regdep_map <- function(spp_name){

  departa <- reg_depa[reg_depa$accepted_name == spp_name,]$registro_dep

  peru <- peru_tibble %>%
    poorman::mutate(fillcolor = dep_id %in% departa,
                          fillcolor = ifelse(fillcolor == TRUE,
                                             "#ff4000",
                                             "transparent"))
  dep_data <- peru %>%
    sf::st_as_sf() %>%
    ggplot2::ggplot() +
    ggplot2::geom_sf(aes(fill = fillcolor)) +
    ggplot2::theme_bw() +
    ggplot2::labs(y = "Latitud",
         x = "Longitud",
         colour = " ",
         fill = " ",
         title = spp_name,
         subtitle = "Registro departamental") +
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
