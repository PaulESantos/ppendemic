#' Check if species are endemic in the ppendemic database
#'
#' This function checks if a list of species names are endemic in the ppendemic database.
#' Endemic species are those that are native and restricted to a specific geographic area,
#' in this case, Peru. The function allows fuzzy matching for species names with a maximum
#' distance threshold to handle potential typos or variations in species names.
#'
#' @param splist A character vector containing the list of species names to be checked for
#'              endemism in the ppendemic database.
#' @param max_distance A numeric value (default is 0.1) specifying the maximum distance
#'                     for fuzzy matching. It should be a non-negative value.
#'
#' @return A character vector indicating if each species is endemic, not endemic, or
#'         if it is an endemic species found using fuzzy matching.
#'
#' @export
#'
#' @examples
#'
#' is_ppendemic(c("Aa aurantiaca", "Aa aurantiaaia", "Werneria nubigena"))
#'
is_ppendemic <- function(splist, max_distance = 0.1) {
  # Defensive function here, check for user input errors
  if (is.factor(splist)) {
    splist <- as.character(splist)
  }

  # Standardize species names
  splist_std <- standardize_names(splist)
  splist_std
  # Remove any NA values from splist_std
  splist_std <- splist_std[!is.na(splist_std)]

  # Create an output data container
  output_vector <- character(length(splist_std))

  # Loop code to find the matching string
  for (i in seq_along(splist_std)) {
    # Standardise max distance value
    if (max_distance < 1 & max_distance > 0) {
      max_distance_fixed <- ceiling(nchar(splist_std[i]) * max_distance)
    } else {
      max_distance_fixed <- max_distance
    }
    max_distance_fixed
    # Fuzzy and exact match
    matches <- agrep(splist_std[i],
                     ppendemic::ppendemic_tab$accepted_name, # base data column
                     max.distance = max_distance_fixed,
                     value = TRUE)
    if(length(matches) == 0){
      output <- "Not endemic"
    }
    else if(length(matches) != 0){

      dis_value <- as.numeric(utils::adist(splist_std[i], matches))
      matches1 <- matches[dis_value <= max_distance_fixed]
      distvalue <- as.numeric(utils::adist(splist_std[i], matches1))

      # Build an output result from match data
      if(length(matches1) == 0){
        output <- "Not endemic"
      }
      else if (length(matches1) != 0 & distvalue == 0) {
        #val <- grep(matches1, ppendemic::ppendemic_tab$accepted_name, value = TRUE)
        #output <- paste0(val, " is endemic")
        output <- "Endemic"
      }
      else if (length(matches1) != 0 & distvalue != 0){
        #val <- grep(matches1, ppendemic::ppendemic_tab$accepted_name, value = TRUE)
        #output <- paste0(val, " is endemic - fuzzy matching")
        output <- "Endemic - fuzzy matching"
      }
    }
    output_vector[i] <- output
  }

  # output_vector
  return(output_vector)
}
