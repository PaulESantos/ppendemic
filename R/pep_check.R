#' pep_check
#'
#' Esta función permite evaluar si la especie es o no endémica del Perú.
#' @param x Vector conteniendo el listado de especies.
#'
#' @return vector
#' @export pep_check
#'
#' @examples
#'
#' spp <- c("Mauria denticulata", "Mauria flexuosa")
#' pep_check(spp)
#'
pep_check <- function(x){
  out <- x %in% especiespp
  ifelse(out == TRUE, "endemic", "not endemic")
}
