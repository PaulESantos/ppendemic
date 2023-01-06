#'Helper function.
#' @keywords internal
regions_id <- function(){
  ppendemic::regiones_ecologicas |>
    dplyr::distinct(region_id, region_eco) |>
    dplyr::filter(!is.na(region_id)) |>
    dplyr::arrange(region_id)
}
