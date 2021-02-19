#' pep_regdep
#'
#' Help to find in which region the endemic species are described
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
#' pep_regdep("Aphelandra latibracteata")
#' ### Set of names
#' species <- c("Sanchezia filamentosa", "Aphelandra latibracteata")
#' pep_regdep(species)
#' pep_regdep("Sanchezia filamentosa", "Aphelandra latibracteata")
pep_regdep <- function(...){

  ppendemic::registro_departamental %>%
    dplyr::filter(accepted_name %in%  c(...)) %>%
    dplyr::group_nest(accepted_name) %>%
    dplyr::mutate(reg = purrr::map(data, ~dplyr::summarise_all(.,
                                          ~paste0(.,
                                                  collapse = "-")))) %>%
    dplyr::select(accepted_name, reg) %>%
    tidyr::unnest(c(reg))
}
