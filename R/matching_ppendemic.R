#' Match Species Names to Endemic Plant List of Peru
#'
#' @description
#' This function matches given species names against the internal database of endemic plant species in Peru.
#'
#' @param splist A vector containing the species list.
#'
#' @details
#' The function first attempts to directly match species names with exact
#' matches in the database (genus and specific epithet, or genus, specific
#' epithet, and infra species). If no exact match is found, the function
#' performs a fuzzy match using the fuzzyjoin package with an optimal string alignment distance of one, as implemented in stringdist.
#'
#' The maximum edit distance is intentionally set to one.
#'
#' The function matching_ppendemic returns a tibble with new columns Matched.Genus, Matched.Species, and Matched.Infraspecies, containing the matched names or NA if no match was found.
#'
#' Additionally, a logical column is added for each function called, allowing users to see which functions were applied to each name during the matching process. If a process column shows `NA`, the corresponding function was not called for that name because it was already matched by a preceding function.
#'
#' @return
#' Returns a tibble with the matched names in
#' Matched.Genus, Matched.Species for binomial names,
#' and Matched.Infraspecies for valid infra species names.
#'
#' @keywords internal
#' @export
matching_ppendemic <- function(splist){
  # Prepare the target data base
  target_df <- ppendemic::ppendemic_tab14 |>
    dplyr::mutate_all(~toupper(.))
  # Classify splist
  splist_class <- .splist_classify(splist) |>
    .transform_split_classify()
  # Check binomial
  non_binomial <- .check_binomial(splist_class, splist = splist)

  if(length(non_binomial) != 0){
    df <- splist_class[-non_binomial,]
    df$sorter <- 1:nrow(df)
  } else{
    df <- splist_class
  }


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
    dplyr::mutate(matched = (matched == 1)) ## convert to Boolean

  res
  # ---------------------------------------------------------------
  ### Check for infra species fuzzy matching
  ## Add sorter value

  infra_input <- res |>
    dplyr::filter(!is.na(Orig.Infraspecies),
                  is.na(Matched.Infraspecies))
  infra_sorter <- as.vector(infra_input$sorter)
  if(nrow(infra_input) != 0){
    infra_matched <- infra_input |>
      fuzzy_match_infraspecies_within_species(target_df)
  }



  # ---------------------------------------------------------------

  # Check non binomial names
  if(length(non_binomial) != 0){
    genus_level <- matrix(nrow = length(non_binomial),
                          ncol = length(names(res)))
    colnames(genus_level) <- names(res)
    genus_level <- as.data.frame(genus_level)
    genus_level
    genus_level$sorter <- splist_class[splist_class$Rank == 1, "sorter"]
    genus_level$Orig.Name <- splist_class[splist_class$Rank == 1, "Orig.Name"]
    genus_level$Orig.Genus <- splist_class[splist_class$Rank == 1, "Orig.Genus"]
    genus_level$Rank <- splist_class[splist_class$Rank == 1, "Rank"]
  }
  # genus_level$Endemic.Tag <- "Not endemic"

  # ---------------------------------------------------------------
  if(nrow(infra_input) == 0 & length(non_binomial) == 0){
    out <- res
    rm(res)
  } else if (nrow(infra_input) != 0 & length(non_binomial) == 0){
    out <- dplyr::bind_rows(res |>
                              dplyr::filter(!sorter %in% infra_sorter) ,
                            infra_matched)
    rm(res, infra_matched)
  }else if (nrow(infra_input) == 0 & length(non_binomial) != 0){
    out <- dplyr::bind_rows(res,
                            genus_level)
    rm(res, genus_level)
  }else if (nrow(infra_input) != 0 & length(non_binomial) != 0){
    out <- dplyr::bind_rows(res |>
                              dplyr::filter(!sorter %in% infra_sorter) ,
                            infra_matched,
                            genus_level)
    rm(res, infra_matched, genus_level)
  }

  output <- out |>
    dplyr::arrange(sorter) |>
    dplyr::mutate(Matched.Name = dplyr::case_when(
      is.na(Matched.Species) ~ stringr::str_to_sentence(Matched.Genus),
      is.na(Matched.Infraspecies) ~ paste(stringr::str_to_sentence(Matched.Genus),
                                          stringr::str_to_lower(Matched.Species),
                                          sep = " "),
      !is.na(Matched.Infraspecies) ~ paste(stringr::str_to_sentence(Matched.Genus),
                                           stringr::str_to_lower(Matched.Species),
                                           stringr::str_to_lower(Infra.Rank),
                                           stringr::str_to_lower(Matched.Infraspecies),
                                           sep = " "))) |>
    dplyr::mutate(Matched.Rank = dplyr::case_when(
      !is.na(Matched.Genus) & !is.na(Matched.Species) & is.na(Matched.Infraspecies) ~ 2,
      !is.na(Matched.Genus) & !is.na(Matched.Species) & !is.na(Matched.Infraspecies) ~ 3,
      is.na(Matched.Species) & is.na(Matched.Infraspecies) ~ 1,
      TRUE ~ NA_real_
    )) |>
    dplyr::mutate(Orig.Name = str_to_simple_cap(Orig.Name)) |>
    dplyr::mutate(Comp.Rank = (Rank == Matched.Rank)) |>
    dplyr::mutate(Endemic.Tag = dplyr::case_when(
      is.na(Matched.Genus) & is.na(Matched.Species) & is.na(Matched.Infraspecies) ~ 'Not endemic',
      Comp.Rank == TRUE ~ 'Endemic',
      Comp.Rank == FALSE ~'Not endemic')) |>
    dplyr::mutate(Matched.Name = dplyr::if_else(is.na(Matched.Name),
                                                "---",
                                                Matched.Name)) |>
    dplyr::relocate(c("sorter", "Orig.Name", "Matched.Name",
                  "Endemic.Tag", "Orig.Genus", "Orig.Species",
                  "Orig.Infraspecies", "Rank", "Infra.Rank", "Comp.Rank",
                  "Matched.Genus", "Matched.Species", "Matched.Infraspecies",
                  "Matched.Rank", "matched", "direct_match", "genus_match",
                  "fuzzy_match_genus", "direct_match_species_within_genus" ,
                  "suffix_match_species_within_genus",
                  "fuzzy_match_species_within_genus", "fuzzy_genus_dist",
                  "fuzzy_species_dist"))

  assertthat::assert_that(nrow(splist_class) == nrow(output))
  return(output)
}

