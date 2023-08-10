#' Retrieve data for a list of species from the ppendemic_tab dataset.
#'
#' This function takes a list of species names, searches for their data in the
#' ppendemic_tab dataset, and returns a data frame containing the relevant
#' information for each species.
#'
#' @param splist A character vector containing the names of the species to search for.
#' @param max_distance The maximum allowed distance for fuzzy matching of species names.
#'   Defaults to 0.1.
#' @return A data frame containing the retrieved information for each species.
#' @examples
#'
#' get_ppendemic_data(splist = c("Aa aurantiaca", "Aa aurantiaaia", "werneria nubigena"))
#'
#' @export
get_ppendemic_data <- function(splist, max_distance = 0.1) {
#splist <- c("werneria nubigena")
  # Defensive function here, check for user input errors
  if (is.factor(splist)) {
    splist <- as.character(splist)
  }
  # Fix species name
  splist_std <- standardize_names(splist)

  # create an output data container
  output_matrix <- matrix(nrow = length(splist_std), ncol = 9)
  colnames(output_matrix) <- c("name_submitted",
                               "accepted_name",
                               "accepted_family",
                               "accepted_name_author",
                               "publication_author",
                               "place_of_publication",
                               "volume_and_page",
                               "first_published",
                               "dist"
                              )
  # loop code to find the matching string

  for (i in seq_along(splist_std)) {
    # Standardise max distance value
    if (max_distance < 1 & max_distance > 0) {
      max_distance_fixed <- ceiling(nchar(splist_std[i]) * max_distance)
    } else {
      max_distance_fixed <- max_distance
    }
    # fuzzy and exact match
    matches <- agrep(splist_std[i],
                     ppendemic::ppendemic_tab$accepted_name, # base data column
                     max.distance = max_distance_fixed,
                     value = TRUE)
    matches
    # check non matching result
    if (length(matches) == 0) {
      matches1 <- "nill"
      dis_value_1 <- ""
    } else { # match result

      dis_value <- as.numeric(utils::adist(splist_std[i], matches))
      matches1 <- matches[dis_value <= max_distance_fixed]
      dis_val_1 <- dis_value[dis_value <= max_distance_fixed]
    }
    #matches1
    # build an output result from mtsta data
    if (matches1 == "nill") {
      row_data <- rep("nill", 7)
    } else {
      row_data <- as.matrix(ppendemic::ppendemic_tab[ppendemic::ppendemic_tab$accepted_name == matches1,])

    }


    if(is.null(nrow(row_data))){
      dis_value_1 <- "nill"
    } else{
      dis_value_1 <- utils::adist(splist_std[i], row_data[,1])
    }

    output_matrix[i, ] <-
      c(splist_std[i], row_data, dis_value_1)
  }
#output_matrix
  return(as.data.frame(output_matrix))
}

