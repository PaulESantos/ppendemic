#' Fuzzy Match Genus Name
#'
#' @description
#' This function performs a fuzzy match of genus names against the ppendemic database using fuzzyjoin::stringdist() to account for slight variations in spelling.
#'
#' @param df A tibble containing the genus names to be matched.
#' @param target_df A tibble representing the ppendemic database containing the reference list of endemic species.
#' @param max_dist Maximum edit distance used by fuzzyjoin::stringdist_* joins.
#' @param save_ambiguous Logical flag. If `TRUE`, ambiguous fuzzy genus matches
#'   are exported to disk.
#' @param ambiguous_path File path used when `save_ambiguous = TRUE`. Defaults
#'   to `"ambiguous_genera.csv"`.
#'
#' @return
#' A tibble with two additional columns:
#' - fuzzy_match_genus: A logical column indicating whether the genus was successfully matched (`TRUE`) or not (`FALSE`).
#' - fuzzy_genus_dist: A numeric column representing the distance for each match.
#'
#' @keywords internal
fuzzy_match_genus <- function(df,
                              target_df = NULL,
                              max_dist = 2,
                              save_ambiguous = FALSE,
                              ambiguous_path = "ambiguous_genera.csv"){
  assertthat::assert_that(is.numeric(max_dist),
                          length(max_dist) == 1,
                          !is.na(max_dist),
                          max_dist >= 0)
  assertthat::assert_that(is.logical(save_ambiguous),
                          length(save_ambiguous) == 1,
                          !is.na(save_ambiguous))
  assertthat::assert_that(is.character(ambiguous_path),
                          length(ambiguous_path) == 1,
                          !is.na(ambiguous_path))

  assertthat::assert_that(all(c('Orig.Genus',
                                'Orig.Species',
                                'Orig.Infraspecies') %in% colnames(df)))

  ## solve issue of empty input tibble, and needed to ensure compatilbility with sequential_matching: because there the columns already exists for the second backbone
  if(nrow(df) == 0){
    if(!all(c('fuzzy_match_genus', 'fuzzy_genus_dist') %in% colnames(df))){
      return(tibble::add_column(df, fuzzy_match_genus = NA, fuzzy_genus_dist = NA))
    }
    else{
      return(df)
    }
  }
  ## solve issue in second iteration of sequential_matching: necessary to remove fuzzy_species_dist column: otherwise 2 columns are generated 'fuzzy_species_dist...1, fuzzy_species_dist...2'
  if('fuzzy_genus_dist' %in% colnames(df)){
    df <- df |>
      dplyr::mutate(fuzzy_genus_dist = NULL)
  } ## TODO: can potentially be removed again????

  Tree.Genera <- target_df |>
    dplyr::distinct(Genus)
  df_work <- df |>
    dplyr::mutate(.row_id = dplyr::row_number())

  # fuzzy match
  matched_temp <- df_work |>
    fuzzyjoin::stringdist_left_join(Tree.Genera,
                                    by = c('Orig.Genus' = 'Genus'),
                                    max_dist = max_dist,
                                    distance_col = 'fuzzy_genus_dist') |>
    # save matched Genus name to Matched.Genus
    dplyr::mutate(Matched.Genus = Genus) |>
    dplyr::select(-c('Genus')) |>
    dplyr::group_by(.row_id) |>
    dplyr::filter(fuzzy_genus_dist == min(fuzzy_genus_dist))


  ambiguous <- matched_temp |>
    dplyr::filter(dplyr::n() > 1) |>
    dplyr::ungroup() |>
    dplyr::arrange(.row_id, fuzzy_genus_dist, Matched.Genus)

  ## If there are multiple matches for the same genus: raise warning.
  if(nrow(ambiguous) > 0){
    warning(paste0("Multiple fuzzy genus matches detected for ",
                   dplyr::n_distinct(ambiguous$.row_id),
                   " input row(s). The algorithm will choose the first match ",
                   "by (fuzzy_genus_dist, Matched.Genus)."),
            call. = FALSE)

    if (save_ambiguous) {
      ambiguous |>
        dplyr::select(dplyr::any_of(c("Orig.Name", "Orig.Genus", "Orig.Species",
                                      "Matched.Genus", "fuzzy_genus_dist"))) |>
        readr::write_csv(file = ambiguous_path)
    }
  }

  ## continue selecting first genus if more than one match (deterministic tie-break)
  matched <- matched_temp |>
    dplyr::ungroup() |>
    dplyr::arrange(.row_id, fuzzy_genus_dist, Matched.Genus) |>
    dplyr::group_by(.row_id) |>
    dplyr::slice_head(n = 1) |>
    dplyr::ungroup()


  unmatched <- df_work |>
    fuzzyjoin::stringdist_anti_join(Tree.Genera,
                                    by = c('Orig.Genus' = 'Genus'),
                                    max_dist = max_dist)
  #unmatched
  assertthat::assert_that(nrow(df) == (nrow(matched) + nrow(unmatched)))

  res <-  dplyr::bind_rows(matched, unmatched,
                           .id = 'fuzzy_match_genus') |>
    dplyr::mutate(fuzzy_match_genus = (fuzzy_match_genus == 1)) |>  ## convert to Boolean
    dplyr::arrange(Orig.Genus, Orig.Species) |>
    dplyr::select(-.row_id) |>
    dplyr::relocate(c('Orig.Genus',
                      'Orig.Species',
                      'Orig.Infraspecies')) ## Genus & Species column at the beginning of tibble
  #res
  return(res)
}

