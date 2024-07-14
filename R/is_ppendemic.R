#' Check if species are endemic in the ppendemic database
#'
#' @description
#' This function checks if a list of species names are endemic in the ppendemic database.
#' The function allows fuzzy matching for species names with a maximum distance threshold to handle potential typos or variations in species names.
#'
#' @param splist A character vector containing the list of species names to be checked for endemic in the ppendemic database.
#'
#' @return A character vector indicating if each species is endemic or not endemic.
#'
#' @export
#'
#' @examples
#' \donttest{
#' is_ppendemic(c("Aa aurantiaca", "Aa aurantiaaia", "Werneria nubigena"))
#' }
is_ppendemic <- function(splist) {

  match_df <- matching_ppendemic(splist)
  # Inicializar el vector results con la longitud adecuada
  output_vector <- as.vector(match_df$Endemic.Tag)
  return(output_vector)
}
