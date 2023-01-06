#' pep_regecol
#'
#' @description
#'
#' `r lifecycle::badge("maturing")`
#'
#' List all endemic species within an ecological region.
#'
#' @description
#' List of ecological region ids and full name, based on Zamora, C. 1996.
#'
#' \itemize{
#'  \item AA   = Altoandina
#'  \item BHA  = Bosques Húmedos Amazónicos
#'  \item BHMP = Bosques Muy Húmedos Premontanos
#'  \item BMHM = Bosques Muy Húmedos Montanos
#'  \item BMHP = Bosques Muy Húmedos Premontanos
#'  \item BPM  = Bosques Pluviales Montanos
#'  \item BS   = Bosques Secos
#'  \item DCT  = Desierto Cálido Tropical
#'  \item DST  = Desierto Semicálido Tropical
#'  \item MA   = Mesoandina
#'  \item MDE  = Matorral Desértico
#'  \item NDE  = Matorral Desértico
#'  \item PAR  = Páramo
#'  \item PD   = Puna Desértica
#'  \item PSH  = Puna Húmeda y Seca
#' }
#'
#' @param region Atomic element or vector with ecological region names,
#' shrot or long name.
#' @param specie Atomic element or vector with species names.
#' @references
#' León, B., J. Roque, C. Ulloa Ulloa, N. C. A. Pitman,
#' P. M. Jørgensen & A. Cano Echevarría. 2006 (2007).
#' El Libro Rojo de las Plantas Endémicas del Perú. Revista Peruana
#' Biol. 13(núm. 2 especial): 1s–971s
#'
#' ZAMORA, C. 1996. Las regiones ecológicas del Perú.
#'   En: Rodríguez, L.O. (ed.), Diversidad Biológica del Perú: Zonas
#'   Prioritarias para su Conservación, pp. 137-141. FANPE,
#'   GTZ-INRENA. Lima, Perú.
#'
#' @return A tibble
#' @export
#'
#' @examples
#' # By Region ID
#' pep_regecol("BHA")
#' pep_regecol(c("MA", "BS"))
#'
#' # By species name
#' pep_regecol(specie = "Aphelandra weberbaueri")
#'
#' especie <-  c("Aphelandra weberbaueri", "Odontophyllum cuscoensis")
#' pep_regecol(specie = especie)
#'

pep_regecol <- function(region = NULL, specie ) {
  if(is.null(region) != TRUE){
    if(length(unique(grepl("[A-Z]{2,}", region))) > 1){
      stop("Check ecological region ID")
    }
    else if(unique(grepl("[A-Z]{2,}", region)) == TRUE){
      out <- ppendemic::regiones_ecologicas |>
        dplyr::filter( region_id %in% region) |>
        dplyr::select(region_id, region_eco, accepted_name)
    }
    else if( length(unique(grepl("[A-Za-z]{2,}", region))) > 1){
      out <- ppendemic::regiones_ecologicas |>
        dplyr::filter( region_eco %in% region) |>
        dplyr::select(region_id, region_eco, accepted_name)
    }


    meta <- out |>
      dplyr::group_by(region_id) |>
      dplyr::summarise(n_sp = dplyr::n_distinct(accepted_name)) # |>
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
  else{
    out <-  ppendemic::regiones_ecologicas |>
      dplyr::filter( accepted_name %in% specie) |>
      dplyr::select(region_id, region_eco, accepted_name)
    return(out)
  }

}
