#' pep_regdep_map
#'
#' @description
#'
#' `r lifecycle::badge("experimental")`
#'
#' This function builds a map indicating where the species has been recorded.
#'
#' @param spp_name species name
#' @name pep_regdep_map
#'
#' @return a map showing all regions where the species is present. This map is a ggplot object that could be edited.
#' @export
#' @importFrom sf st_as_sf
#' @importFrom ggplot2 ggplot geom_sf theme_bw labs theme element_rect element_text element_blank
#' @importFrom dplyr mutate as_tibble %>%
#' @importFrom rlang .data
#' @examples
#' # Basic usage
#' pep_regdep_map("Grosvenoria coelocaulis")
pep_regdep_map <- function(spp_name){
  # read shape file
  shp <-  ppendemic::peru
  # choose regions
  dff <- ppendemic::registro_departamental
  dff <- dff[dff$accepted_name == spp_name,]
  regions <- dff$registro_dep
  # fill regions where species was funded
  peru <- shp %>%
    dplyr::as_tibble() %>%
    dplyr::mutate(fillcolor = .data$dep_id %in% regions,
                    fillcolor = ifelse(.data$fillcolor == TRUE,
                                       "#ff4000",
                                       "transparent"))
  # plot
  peru %>%
    sf::st_as_sf() %>%
    ggplot2::ggplot() +
    ggplot2::geom_sf(fill = peru$fillcolor) +
    ggplot2::theme_bw() +
    ggplot2::labs(y = "Latitud",
                  x = "Longitud",
                  colour = " ",
                  fill = " ",
                  title = spp_name,
                  subtitle = "Registro departamental") +
    ggplot2::theme(strip.background = ggplot2::element_rect(fill = "transparent"),
                   axis.title = ggplot2::element_text(face = "bold", size = 8),
                   axis.text = ggplot2::element_blank(),
                   axis.ticks = ggplot2::element_blank(),
                   strip.text = ggplot2::element_text(face = "bold"),
                   plot.title = ggplot2::element_text(hjust = .5, size = 12),
                   plot.subtitle = ggplot2::element_text(hjust = .5, size = 8),
                   plot.caption = ggplot2::element_text(hjust = .5, colour = "#1a1aff",
                                               size = 5))

}
