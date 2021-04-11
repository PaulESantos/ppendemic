#' pep_by_reg
#'
#' @description
#'
#' `r lifecycle::badge("maturing")`
#'
#' List all endemic species within an region.
#'
#' @param ... Atomic element or vector with species names.
#'
#' @return A tibble with two variables: species name and regions where species found
#' @export
#'
#' @importFrom dplyr filter group_nest mutate select summarise_all
#' @importFrom tidyr unnest
#' @importFrom purrr map
#' @examples
#' # Basic usage
#' ### One name
#' pep_by_reg("Aphelandra latibracteata")
#' ### Set of names
#' species <- c("Sanchezia filamentosa", "Aphelandra latibracteata")
#' pep_by_reg(species)
pep_by_reg <- function(...) {
  ppendemic::registro_departamental %>%
    dplyr::filter(registro_dep %in%  c(...))
}
