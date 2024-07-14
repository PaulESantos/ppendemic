#' Fuzzy Match Infraspecies within Species
#'
#' @description
#' This function performs a fuzzy match of specific infraspecies within an already matched epithet from the list of endemic species in the ppendemic database.
#'
#' @param df A tibble containing the species data to be matched.
#' @param target_df A tibble representing the ppendemic database containing the reference list of endemic species.
#'
#' @return
#' A tibble with an additional logical column fuzzy_match_infraspecies_within_species, indicating whether the specific infraspecies was successfully fuzzy matched within the matched species (`TRUE`) or not (`FALSE`).
#' @keywords internal
fuzzy_match_infraspecies_within_species <- function(df, target_df = NULL){
  assertthat::assert_that(all(c('Orig.Genus',
                                'Orig.Species',
                                'Orig.Infraspecies',
                                'Matched.Genus') %in% colnames(df)))

  if(nrow(df) == 0){
    if(!all(c('fuzzy_match_infraspecies_within_species',
              'fuzzy_infraspecies_dist') %in% colnames(df))){
      return(tibble::add_column(df,
                                fuzzy_match_infraspecies_within_species = NA,
                                fuzzy_infraspecies_dist = NA))
    } else {
      return(df)
    }
  }

  if('fuzzy_infraspecies_dist' %in% colnames(df)){
    df <- df |>
      dplyr::mutate(fuzzy_infraspecies_dist = NULL)
  }

  res <- df |>
    dplyr::group_by(Matched.Species) |>
    dplyr::group_split() |>
    map_dfr_progress(fuzzy_match_infraspecies_within_species_helper,
                     target_df)

  return(res)
}

fuzzy_match_infraspecies_within_species_helper <- function(df, target_df){
  species <- df |>
    dplyr::distinct(Matched.Species) |>
    unlist()

  get_trees_of_infra <- function(species, target_df = NULL){
    return(target_df |>
             dplyr::filter(Species %in% species) |>
             dplyr::select(c('Genus', 'Species', 'infraspecies')))
  }

  memoised_get_trees_of_infrasp <- memoise::memoise(get_trees_of_infra)

  database_subset <- memoised_get_trees_of_infrasp(species, target_df) |>
    tidyr::drop_na()

  matched <-
    df |>
    fuzzyjoin::stringdist_left_join(database_subset,
                                    by = c('Orig.Infraspecies' = 'infraspecies'),
                                    distance_col = 'fuzzy_infraspecies_dist') |>
    dplyr::mutate(Matched.Infraspecies = infraspecies) |>
    dplyr::select(-c('Species', 'Genus', 'infraspecies')) |>
    dplyr::group_by(Orig.Genus, Orig.Species, Orig.Infraspecies) |>
    dplyr::filter(fuzzy_infraspecies_dist == min(fuzzy_infraspecies_dist)) |>
    dplyr::group_modify(
      ~ifelse(nrow(.x) == 0, return(.x),
              return(dplyr::slice_head(.x, n = 1)))
    ) |>
    dplyr::ungroup()

  unmatched <- fuzzyjoin::stringdist_anti_join(dplyr::filter(df,
                                                             !is.na(Orig.Infraspecies)),
                                               database_subset,
                                               by = c('Orig.Infraspecies' = 'infraspecies'))

  assertthat::assert_that(nrow(df) == (nrow(matched) + nrow(unmatched)))

  combined <-  dplyr::bind_rows(matched,
                                unmatched,
                                .id = 'fuzzy_match_infraspecies_within_species') |>
    dplyr::mutate(fuzzy_match_infraspecies_within_species = (fuzzy_match_infraspecies_within_species == 1)) |>
    dplyr::relocate(c('Orig.Genus',
                      'Orig.Species',
                      'Orig.Infraspecies'))

  return(combined)
}
