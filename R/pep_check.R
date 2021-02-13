#' pep_check
#' @description
#' `r lifecycle::badge("experimental")`
#' The function automates the process to check if a plant species is or not endemic to Perú.
#'
#' @param x an atomic character string or a vector with the species names that will be verified if it endemic species
#'
#' @return a vector with information for each species names tested: a) "endemic" if the species is endemic of Perú; b)  "not endemic" if the species is not endemic of Perú; c)"not binary name" if only the genera were submitted; d) "taxon state undefined" if the submitted species name has a taxonomic status undetermined.
#' @export
#' @importFrom rlang .data
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
  # clean and check taxonomic status all posible variants
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
