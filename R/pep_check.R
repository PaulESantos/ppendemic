#' pep_check
#'
#' Esta función permite evaluar si la especie es o no endémica del Perú.
#' @param x Vector conteniendo el listado de especies.
#'
#' @return vector
#' @export
#'
#' @examples
#' # Basic usage
#' spp <-  c("Hedyosmum", "Miconia alpina", "Persea sp2")
#' pep_check(spp)
#'
#'
pep_check <- function(x){
  "%w/o%" <- function(x, table) match(x, table, nomatch = 0) == 0
  "%per%" <- function(x, table) match(x, table, nomatch = 0) > 0
  x <- trimws(x)
  #' clean and check taxonomic status
  #' all posible variants
  variant <- c("sp [0-9]",
               "[a-z] [a-z] var. [a-z]",
               "sp[0-9]",
               " spp",
               "sp",
               "[a-z] var",
               "subsp.",
               "subsp")
  x[which(grepl(paste0(variant, collapse = "|"), x))] <- "taxon state undefined"

  # not binari name position
  x[base::setdiff(seq(1:length(x)),
                  which(grepl("[a-z] [a-z]", tolower(x))))] <- "not binary name"

  x[x %per% species_pep$accepted_name] <- "endemic"

  x[x %w/o% c("endemic",
              "not binary name",
              "taxon state undefined")] <- "not endemic"

  return(x)
}
