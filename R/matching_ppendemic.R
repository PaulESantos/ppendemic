#' Match Species Names to Endemic Plant List of Peru
#'
#' @description
#' This function matches given species names against the internal database of endemic plant species in Peru.
#'
#' @param splist a vector containing the species list.
#'
#' @details
#' The function first attempts to directly match species names with exact
#' matches in the database (genus and specific epithet, or genus, specific
#' epithet, and infraspecies). If no exact match is found, the function
#' performs a fuzzy match using the `fuzzyjoin` package with an optimal string alignment distance of one, as implemented in `stringdist`.
#'
#' The maximum edit distance is intentionally set to one.
#'
#' The function [matching_ppendemic()] returns a `tibble` with new columns `Matched.Genus`, `Matched.Species`, and `Matched.Infraspecies`, containing the matched names or `NA` if no match was found.
#'
#' Additionally, a logical column is added for each function called, allowing users to see which functions were applied to each name during the matching process. If a process column shows `NA`, the corresponding function was not called for that name because it was already matched by a preceding function.
#'
#' @return
#' Returns a `tibble` with the matched names in
#' `Matched.Genus`, `Matched.Species` for binomial names,
#' and `Matched.Infraspecies` for valid infraspecies names.
#'
#' @export

matching_ppendemic <- function(splist){
  target_df <- ppendemic::ppendemic_tab11 |>
    dplyr::mutate_all(~toupper(.))
  df <- .splist_classify(splist) |>
    .transform_split_classify()

  ### Add two Columns Matched.Genus & Matched.Species and fill with NA's
  if(!all(c('Matched.Genus', 'Matched.Species',
            'Matched.Infraspecies') %in% colnames(df))){
    df <- df |>
      tibble::add_column(Matched.Genus = as.character(NA),
                         Matched.Species = as.character(NA),
                         Matched.Infraspecies = as.character(NA))
  }

  # ---------------------------------------------------------------
   # Node 1: Direct Match
  Node_1_processed <- df |>
    direct_match(target_df)

  Node_1_TRUE <- Node_1_processed |>
    dplyr::filter(direct_match == TRUE)

  Node_1_FALSE <- Node_1_processed |>
    dplyr::filter(direct_match == FALSE)

  assertthat::assert_that(nrow(df) == (nrow(Node_1_TRUE) + nrow(Node_1_FALSE)))


  # ---------------------------------------------------------------
  # Node 2: Genus Match
  Node_2_processed <- Node_1_FALSE |>
    genus_match( target_df)

  Node_2_TRUE <- Node_2_processed |>
    dplyr::filter(genus_match == TRUE)

  Node_2_FALSE <- Node_2_processed |>
    dplyr::filter(genus_match == FALSE)


  assertthat::assert_that(nrow(Node_2_processed) == (nrow(Node_2_TRUE) + nrow(Node_2_FALSE)))


  # ---------------------------------------------------------------
  # Node 3: Fuzzy Match Genus
  Node_3_processed <- Node_2_FALSE |>
    fuzzy_match_genus(target_df)


  Node_3_TRUE <- Node_3_processed |>
    dplyr::filter(fuzzy_match_genus == TRUE)

  Node_3_FALSE <- Node_3_processed |>
    dplyr::filter(fuzzy_match_genus == FALSE)

  assertthat::assert_that(nrow(Node_3_processed) == (nrow(Node_3_TRUE) + nrow(Node_3_FALSE)))

  # ---------------------------------------------------------------
    # Node 4: Direct (Exact) Match Species within Genus
  Node_4_input <- Node_3_TRUE |>
    dplyr::bind_rows(Node_2_TRUE)

  Node_4_processed <- Node_4_input |>
    direct_match_species_within_genus(target_df)

  Node_4_TRUE <- Node_4_processed |>
    dplyr::filter(direct_match_species_within_genus == TRUE)

  Node_4_FALSE <- Node_4_processed |>
    dplyr::filter(direct_match_species_within_genus == FALSE)

  assertthat::assert_that(nrow(Node_4_processed) == (nrow(Node_4_TRUE) + nrow(Node_4_FALSE)))

  # ---------------------------------------------------------------
  # Node 5a: Suffix Match Species within Genus
  Node_5a_processed <- Node_4_FALSE |>
    suffix_match_species_within_genus( target_df)

  Node_5a_TRUE <- Node_5a_processed |>
    dplyr::filter(suffix_match_species_within_genus == TRUE)

  Node_5a_FALSE <- Node_5a_processed |>
    dplyr::filter(suffix_match_species_within_genus == FALSE)

  assertthat::assert_that(nrow(Node_4_FALSE) == (nrow(Node_5a_TRUE) + nrow(Node_5a_FALSE)))

  # Node 5b: Fuzzy Match Species within Genus

  Node_5b_input <- Node_5a_FALSE
  Node_5b_processed <- Node_5b_input |>
    fuzzy_match_species_within_genus( target_df)

  Node_5b_TRUE <- Node_5b_processed |>
    dplyr::filter(fuzzy_match_species_within_genus == TRUE)

  Node_5b_FALSE <- Node_5b_processed |>
    dplyr::filter(fuzzy_match_species_within_genus == FALSE)

  assertthat::assert_that(nrow(Node_5b_input) == (nrow(Node_5b_TRUE) + nrow(Node_5b_FALSE)))

  # Output
  # Output A: matched
  matched <- dplyr::bind_rows(Node_1_TRUE, Node_4_TRUE,
                              Node_5a_TRUE, Node_5b_TRUE) |>
    dplyr::arrange(Orig.Genus, Orig.Species, Orig.Infraspecies)

  # Output B: unmatched
  unmatched <- dplyr::bind_rows(Node_3_FALSE, Node_5b_FALSE) |>
    dplyr::arrange(Orig.Genus, Orig.Species, Orig.Infraspecies)

  # Concatenate Output A and Output B
  res <- dplyr::bind_rows(matched,
                          unmatched,
                          .id='matched') |>
    dplyr::mutate(matched = (matched == 1)) |>  ## convert to Boolean
    dplyr::relocate(c('Orig.Genus', 'Orig.Species','Orig.Infraspecies',
                      'Matched.Genus', 'Matched.Species',
                      'Matched.Infraspecies',
                      'matched', 'direct_match',
                      'genus_match', 'fuzzy_match_genus',
                      'direct_match_species_within_genus',
                      'suffix_match_species_within_genus',
                      'fuzzy_match_species_within_genus')) ## Genus & Species column at the beginning of tibble

  # ---------------------------------------------------------------
  ### Check for infra species fuzzy matching
  ## Add sorter value
  res <- res |>
    dplyr::mutate(Sorter = dplyr::row_number()) |>
    dplyr::relocate(Sorter)

  infra_input <- res |>
    dplyr::filter(!is.na(Orig.Infraspecies),
                  is.na(Matched.Infraspecies))

  infra_sorter <- as.vector(infra_input$Sorter)

  infra_matched <- infra_input |>
    fuzzy_match_infraspecies_within_species(target_df)

  output <- dplyr::bind_rows(res |>
                               dplyr::filter(!Sorter %in% infra_sorter),
                             infra_matched) |>
    dplyr::arrange(Sorter) |>
    dplyr::mutate(Matched.name = dplyr::case_when(
      is.na(Matched.Species) ~ Matched.Genus,
      is.na(Matched.Infraspecies) ~ paste(stringr::str_to_sentence(Matched.Genus),
                                          stringr::str_to_lower(Matched.Species),
                                          sep = " "),
      !is.na(Matched.Infraspecies) ~ paste(stringr::str_to_sentence(Matched.Genus),
                                           stringr::str_to_lower(Matched.Species),
                                           stringr::str_to_lower(Infra.Rank),
                                           stringr::str_to_lower(Matched.Infraspecies),
                                           sep = " "))) |>
    dplyr::arrange(sorter) |>
    dplyr::mutate_all(~str_to_simple_cap(.))#stringr::str_to_sentence(.))

  rm(res)
  assertthat::assert_that(nrow(df) == nrow(output))
  return(output)
}

