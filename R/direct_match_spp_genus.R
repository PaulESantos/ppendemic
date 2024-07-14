#' Direct Match Species within Genus
#'
#' @description
#' This function performs a direct match of specific epithets within an already matched genus from the list of endemic species in the ppendemic database.
#'
#' @param df A tibble containing the species data to be matched.
#' @param target_df A tibble representing the ppendemic database containing the reference list of endemic species.
#'
#' @return
#' A tibble with an additional logical column indicating whether the specific epithet was successfully matched within the matched genus (`TRUE`) or not (`FALSE`).
#'
#' @keywords internal
direct_match_species_within_genus_helper <- function(df, target_df){
  # subset database
  genus <- df |>
    dplyr::distinct(Matched.Genus) |>
    unlist()

  database_subset <- memoised_get_trees_of_genus(genus, target_df)


  # match specific epithet within genus
  matched <- df |>
    dplyr::semi_join(database_subset,
                     by = c('Orig.Species' = 'Species')) |>
    dplyr::mutate(Matched.Species = Orig.Species)

  unmatched <- df |>
    dplyr::anti_join(database_subset,
                     by = c('Orig.Species' = 'Species'))

  assertthat::assert_that(nrow(df) == (nrow(matched) + nrow(unmatched)))

  # combine matched and unmatched and add Boolean indicator: TRUE = matched, FALSE = unmatched
  combined <-  dplyr::bind_rows(matched, unmatched,
                                .id = 'direct_match_species_within_genus') |>
    dplyr::mutate(direct_match_species_within_genus = (direct_match_species_within_genus == 1)) |>  ## convert to Boolean
    dplyr::relocate(c('Orig.Genus',
                      'Orig.Species',
                      'Orig.Infraspecies')) ## Genus & Species column at the beginning of tibble

  return(combined)
}


direct_match_species_within_genus <- function(df, target_df = NULL){

  assertthat::assert_that(all(c('Orig.Genus', 'Orig.Species',
                                'Orig.Infraspecies',
                                'Matched.Genus') %in% colnames(df)))

  ## solve issue of empty input tibble, and needed to ensure compatilbility with sequential_matching: because there the columns already exists for the second backbone
  if(nrow(df) == 0){
    if(!all(c('direct_match_species_within_genus') %in% colnames(df))){
      return(tibble::add_column(df,
                                direct_match_species_within_genus = NA))
    }
    else{
      return(df)
    }
  }

    res <- df |>
    dplyr::group_by(Matched.Genus) |>
    dplyr::group_split() |>
    map_dfr_progress(direct_match_species_within_genus_helper,
                     target_df)

  return(res)
}

