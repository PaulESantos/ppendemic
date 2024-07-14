#' Direct Match
#'
#' @description
#' This function performs a direct match of species names. It matches the genus and species if the name is binomial, and matches the genus, species, and infra species if the name includes a subspecies.
#'
#' @param df A tibble containing the species data to be matched.
#' @param target_df A tibble representing the ppendemic database containing the reference list of endemic species.
#'
#' @return
#' A tibble with an additional logical column direct_match indicating whether the binomial or trinomial name was successfully matched (`TRUE`) or not (`FALSE`).
#'
#' @keywords internal
direct_match <- function(df, target_df = NULL){
  assertthat::assert_that(all(c('Orig.Genus',
                                'Orig.Species',
                                'Orig.Infraspecies') %in%
                                colnames(df)))

  ## solve issue of empty input tibble, and needed to ensure
  ## compatilbility with sequential_matching: because there the
  ## columns already exists for the second backbone
  if(!all(c('direct_match') %in% colnames(df))){
    if(nrow(df) == 0){
      return(tibble::add_column(df, direct_match = NA))
    }
  }

  matched <- df |>
    dplyr::semi_join(target_df,
                     by = c('Orig.Genus' = 'Genus',
                            'Orig.Species' = 'Species',
                            'Orig.Infraspecies' = 'infraspecies')) |>
    dplyr::mutate(Matched.Genus = Orig.Genus,
                  Matched.Species = Orig.Species,
                  Matched.Infraspecies = Orig.Infraspecies)
  unmatched <- df |>
    dplyr::anti_join( target_df,
                      c('Orig.Genus' = 'Genus',
                        'Orig.Species' = 'Species',
                        'Orig.Infraspecies' = 'infraspecies'))

  assertthat::assert_that(nrow(df) == (nrow(matched) + nrow(unmatched)))

  # combine matched and unmatched and add Boolean indicator: TRUE = matched, FALSE = unmatched
  combined <-  dplyr::bind_rows(matched, unmatched,
                                .id = 'direct_match') |>
    dplyr::mutate(direct_match = (direct_match == 1)) |>  ## convert to Boolean
    dplyr::relocate(c('Orig.Genus', 'Orig.Species', 'Orig.Infraspecies'))
  ## Genus & Species column at the beginning of tibble

  return(combined)
}
