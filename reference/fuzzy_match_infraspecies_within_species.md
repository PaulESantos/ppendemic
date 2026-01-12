# Fuzzy Match Infraspecies within Species

This function performs a fuzzy match of specific infraspecies within an
already matched epithet from the list of endemic species in the
ppendemic database.

## Usage

``` r
fuzzy_match_infraspecies_within_species(df, target_df = NULL)
```

## Arguments

- df:

  A tibble containing the species data to be matched.

- target_df:

  A tibble representing the ppendemic database containing the reference
  list of endemic species.

## Value

A tibble with an additional logical column
fuzzy_match_infraspecies_within_species, indicating whether the specific
infraspecies was successfully fuzzy matched within the matched species
(`TRUE`) or not (`FALSE`).
