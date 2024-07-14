#' Match Genus Name
#'
#' @description
#' This function performs a direct match of genus names against the genus names listed in the ppendemic database.
#'
#' @param df A tibble containing the genus names to be matched.
#' @param target_df A tibble representing the ppendemic database containing the reference list of endemic species.
#'
#' @return
#' A tibble with an additional logical column genus_match indicating whether the genus was successfully matched (`TRUE`) or not (`FALSE`).
#' @keywords internal
genus_match <- function(df, target_df = NULL){
  assertthat::assert_that(all(c('Orig.Genus',
                                'Orig.Species',
                                'Orig.Infraspecies')
                              %in% colnames(df)))

  ## solve issue of empty input tibble and needed to ensure compatilbility with sequential_matching: because there the columns already exists for the second backbone
  if(nrow(df) == 0){
    if(!all(c('genus_match') %in% colnames(df))){
      return(tibble::add_column(df, genus_match = NA))
    }
    else{
      return(df)
    }
  }

  matched <- df |>
    dplyr::semi_join( target_df,
                      by = c('Orig.Genus' = 'Genus')) |>
    dplyr::mutate(Matched.Genus = Orig.Genus)

  unmatched <- df |>
    dplyr::anti_join(target_df,
                     by = c('Orig.Genus' = 'Genus'))

  assertthat::assert_that(nrow(df) == (nrow(matched) + nrow(unmatched)))

  # combine matched and unmatched and add Boolean indicator: TRUE = matched, FALSE = unmatched
  combined <-  dplyr::bind_rows(matched, unmatched,
                                .id = 'genus_match') |>
    dplyr::mutate(genus_match = (genus_match == 1)) |>  ## convert to Boolean
    dplyr::relocate(c('Orig.Genus',
                      'Orig.Species',
                      'Orig.Infraspecies'))
  ## Genus & Species column at the beginning of tibble

  return(combined)
}
