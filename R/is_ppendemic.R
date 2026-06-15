#' Check if species are endemic in the ppendemic database
#'
#' @description
#' This function checks if a list of species names are endemic in the ppendemic database.
#' The function allows fuzzy matching for species names with a maximum distance threshold to handle potential typos or variations in species names.
#'
#' @param splist A non-empty character vector containing taxon names to check
#'   against the ppendemic database. Missing and empty values are not accepted.
#'   Indeterminate `sp.` and `spp.` names are treated as genus-level records.
#' @param max_dist Maximum edit distance used in fuzzy matching steps.
#'   Defaults to 2.
#' @param save_ambiguous Logical flag. If `TRUE`, ambiguous fuzzy genus matches
#'   are exported to disk.
#' @param ambiguous_path File path used when `save_ambiguous = TRUE`. Defaults
#'   to `"ambiguous_genera.csv"`.
#'
#' @return A character vector indicating if each species is endemic or not endemic.
#'
#' @export
#'
#' @examples
#' \donttest{
#' is_ppendemic(c("Aa aurantiaca", "Aa aurantiaaia", "Werneria nubigena"))
#' }
is_ppendemic <- function(splist,
                         max_dist = 2,
                         save_ambiguous = FALSE,
                         ambiguous_path = "ambiguous_genera.csv") {

  match_df <- matching_ppendemic(splist,
                                 max_dist = max_dist,
                                 save_ambiguous = save_ambiguous,
                                 ambiguous_path = ambiguous_path)
  # Inicializar el vector results con la longitud adecuada
  output_vector <- as.vector(match_df$Endemic.Tag)
  return(output_vector)
}

