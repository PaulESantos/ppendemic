#' Fuzzy Match Infraspecies within Species
#'
#' @description
#' This function performs a fuzzy match of specific infraspecies within an already matched epithet from the list of endemic species in the ppendemic database.
#'
#' @param df A tibble containing the species data to be matched.
#' @param target_df A tibble representing the ppendemic database containing the reference list of endemic species.
#' @param max_dist Maximum edit distance used by fuzzyjoin::stringdist_* joins.
#'
#' @return
#' A tibble with an additional logical column fuzzy_match_infraspecies_within_species, indicating whether the specific infraspecies was successfully fuzzy matched within the matched species (`TRUE`) or not (`FALSE`).
#' @keywords internal
fuzzy_match_infraspecies_within_species <- function(df, target_df = NULL, max_dist = 2){
  assertthat::assert_that(is.numeric(max_dist),
                          length(max_dist) == 1,
                          !is.na(max_dist),
                          max_dist >= 0)

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
    dplyr::group_by(Matched.Genus, Matched.Species, Infra.Rank) |>
    dplyr::group_split() |>
    map_dfr_progress(fuzzy_match_infraspecies_within_species_helper,
                     target_df,
                     max_dist)

  return(res)
}

fuzzy_match_infraspecies_within_species_helper <- function(df, target_df, max_dist){
  df <- df |>
    dplyr::mutate(.row_id = dplyr::row_number())

  genus <- df |>
    dplyr::distinct(Matched.Genus) |>
    unlist()

  species <- df |>
    dplyr::distinct(Matched.Species) |>
    unlist()

  infra_rank <- df |>
    dplyr::distinct(Infra.Rank) |>
    unlist()

  get_trees_of_infra <- function(genus, species, infra_rank, target_df = NULL){
    return(target_df |>
             dplyr::filter(Genus %in% genus,
                           Species %in% species,
                           infraspecific_rank %in% infra_rank) |>
             dplyr::select(c('Genus', 'Species', 'infraspecific_rank',
                             'infraspecies')))
  }

  memoised_get_trees_of_infrasp <- memoise::memoise(get_trees_of_infra)

  database_subset <- memoised_get_trees_of_infrasp(genus, species, infra_rank,
                                                   target_df) |>
    tidyr::drop_na()

  matched <-
    df |>
    fuzzyjoin::stringdist_left_join(database_subset,
                                    by = c('Orig.Infraspecies' = 'infraspecies'),
                                    max_dist = max_dist,
                                    distance_col = 'fuzzy_infraspecies_dist') |>
    dplyr::mutate(Matched.Infraspecies = infraspecies) |>
    dplyr::select(-c('Species', 'Genus', 'infraspecific_rank',
                     'infraspecies')) |>
    dplyr::group_by(.row_id) |>
    dplyr::filter(fuzzy_infraspecies_dist == min(fuzzy_infraspecies_dist)) |>
    dplyr::group_modify(
      ~ifelse(nrow(.x) == 0, return(.x),
              return(dplyr::slice_head(.x, n = 1)))
    ) |>
    dplyr::ungroup()

  unmatched <- fuzzyjoin::stringdist_anti_join(dplyr::filter(df,
                                                             !is.na(Orig.Infraspecies)),
                                               database_subset,
                                               by = c('Orig.Infraspecies' = 'infraspecies'),
                                               max_dist = max_dist)

  assertthat::assert_that(nrow(df) == (nrow(matched) + nrow(unmatched)))

  combined <-  dplyr::bind_rows(matched,
                                unmatched,
                                .id = 'fuzzy_match_infraspecies_within_species') |>
    dplyr::mutate(fuzzy_match_infraspecies_within_species = (fuzzy_match_infraspecies_within_species == 1)) |>
    dplyr::select(-.row_id) |>
    dplyr::relocate(c('Orig.Genus',
                      'Orig.Species',
                      'Orig.Infraspecies'))

  return(combined)
}

