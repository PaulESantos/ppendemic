#' pep_regecol
#'
#' @description
#'
#' `r lifecycle::badge("maturing")`
#'
#' List all endemic species within an ecological region.
#'
#' @param region Atomic element or vector with ecological region names,
#' shrot or long name.
#'
#' @return A tibble
#' @export
#'
#' @importFrom dplyr filter group_nest mutate select summarise_all
#' @importFrom tidyr unnest
#' @importFrom purrr map

pep_regecol <- function(region) {
  if(unique(grepl("[A-Z]{2,}", region)) == TRUE){
    out <- ppendemic::regiones_ecologicas %>%
      dplyr::filter( region_id %in% region) %>%
      dplyr::select(region_id, region_eco, accepted_name)
  }
  else if( length(unique(grepl("[A-Z]", regiones))) > 1){
    out <- ppendemic::regiones_ecologicas %>%
      dplyr::filter( region_eco %in% region) %>%
      dplyr::select(region_id, region_eco, accepted_name)
  }
  else{
    message(crayon::red(paste(
      "The ecological region name is misspelled. Check!!"
    )))
  }

  meta <- out %>%
    dplyr::group_by(region_id) %>%
    dplyr::summarise(n_sp = dplyr::n_distinct(accepted_name)) # %>%
  if (length(meta$region_id) == 1) {
    message(crayon::green(paste(
      "Region:", meta$region_id, "with",
      meta$n_sp,
      "species"
    )))
  } else {
    message(crayon::green(paste(
      "Regions:",
      paste(meta$region_id, collapse = " - "),
      "with",
      sum(meta$n_sp),
      "species"
    )))
  }

  out
}
