#' pep_check
#'
#' Esta función permite evaluar si la especie es o no endémica del Perú.
#' @param x Vector conteniendo el listado de especies.
#' @name pep_check
#' @return vector
#' @export
#'
#' @examples
#' # Basic usage
#' spp <-  c("Clethra cuneata", "Miconia setulosa", "Hedyosmum"
#'           "Weinmannia fagaroides", "Symplocos quitensis" , "Miconia alpina",
#'           "Persea sp2", "Myrsine", "Symplocos var",
#'           "Polylepis pauta var pauta", "Senna versicolor var. heterosperma")
#' pep_check(spp)
#'
#'
pep_check <- function(x){
  x <- trimws(x)
  # clean taxonomic status
  x[which(grepl("sp [0-9]|[a-z] [a-z] var | sp[0-9]| spp| sp|[a-z] var", x))] <- "taxon state undefined"
  # not binari name position
  x[base::setdiff(seq(1:length(x)),
                  which(grepl("[a-z] [a-z]", tolower(x))))] <- "not binary name"
  x[x%in%especiespp] <- "endemic"
  x[x == FALSE] <- "not endemic"
  return(x)
}
